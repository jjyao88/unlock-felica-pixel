#!/sbin/sh

###################################################
# Partial code from Dynamic Installer by @BlassGO #
###################################################
is_number() { echo "$1" | grep -Eq "^[0-9]+([.][0-9]+)?$"; }

delete() { rm -f "$@"; }

delete_recursive() { rm -rf "$@"; }

echo2() { echo >&2 "$@"; }

set_perm2() {
   #Ensure this format
   local uid gid mod
   [ -n "$1" ] && uid=$1 || return 1
   [ -n "$2" ] && gid=$2 || return 1
   [ -n "$3" ] && mod=$3 || return 1
   shift 3
   while [ "$1" ]; do
      testrw "$(dirname "$1")" || return 1
      chown "$uid:$gid" "$1" 2>/dev/null || chown "$uid.$gid" "$1"
      chmod "$mod" "$1"
      shift
   done
}

create_dir() {
   local dir return=0
   for dir; do if [ ! -d "$dir" ]; then
      mkdir -p "$dir" 2>/dev/null
      if [ -d "$dir" ]; then set_perm2 $di_uid $di_gid $di_perm_d "$dir"; elif [ -e "$dir" ]; then echo2 "Already exist some reference called: $dir" && return=1; else
         testrw "$(dirname "$dir")" || return=1
         echo2 "Cant create dir: $dir" && return=1
      fi
   else testrw "$dir" || return=1; fi; done
   return $return
}

exist() {
   local flag file folder symlink block any
   flag=$(echo "$1" | grep -E '^(any|file|folder|symlink|block)$')
   if [ -n "$flag" ]; then
      eval "$flag=true"
      shift
   else any=true; fi
   [ $# == 0 ] && return 1
   while [ $# != 0 ]; do
      [[ -n "$any" && -e "$1" ]] || [[ -n "$file" && -f "$1" ]] || [[ -n "$folder" && -d "$1" ]] || [[ -n "$symlink" && -L "$1" ]] || [[ -n "$block" && -b "$1" ]] || return 1
      shift
   done
   return 0
}

getdefault() {
   grep -m1 "^setdefault $2" "$1" | tr -d '"' | sed s/"setdefault $2 "//
}

savestate() {
   setdefault "$1" "$(md5sum "$2" | awk '{ print $1; }')"
}

checkvar() {
   while [ "$1" ]; do
      eval "[ -n \"\${${1}}\" ] && echo \"\${${1}}\""
      shift
   done
}

is_valid() {
   [ $# == 0 ] && return 1
   while [ $# != 0 ]; do
      [ -e "$1" ] && grep -q '[^[:space:]]' "$1" || return 1
      shift
   done
   return 0
}

defined() {
   [ $# == 0 ] && return 1
   while [ $# != 0 ]; do
      [ -z "$(checkvar "$1")" ] && return 1
      shift
   done
   return 0
}

undefined() {
   [ $# == 0 ] && return 1
   while [ $# != 0 ]; do
      [ -n "$(checkvar "$1")" ] && return 1
      shift
   done
   return 0
}

copy() {
   if ([ -d "$2" ] || create_dir "$(dirname "$2")") && cp -prf "$1" "$2" 2>/dev/null; then
      return 0
   else
      echo2 "Cant copy: \"$1\" in \"$2\""
      return 1
   fi
}

move() {
   if ([ -d "$2" ] || create_dir "$(dirname "$2")") && (mv -f "$1" "$2" || cp -prf "$1" "$2") 2>/dev/null; then
      if testrw "$(dirname "$1")" 2>/dev/null; then
         rm -rf "$1"
      else
         echo2 "Copied to \"$2\", but cant remove \"$1\""
      fi
      return 0
   else
      echo2 "Cant move: \"$1\" in \"$2\""
      return 1
   fi
}

run_jar() {
   local dalvikvm file main
   #Inspired in the osm0sis method
   [ -z "$dalvik_logging" ] && local dalvik_logging=false
   if /system/bin/dalvikvm -showversion >/dev/null 2>&1; then
      dalvikvm=/system/bin/dalvikvm
   elif dalvikvm -showversion >/dev/null 2>&1; then
      dalvikvm=dalvikvm
   else
      [ -z "$ANDROID_ART_ROOT" ] && ANDROID_ART_ROOT=$(find /apex -type d -name "com.android.art*" 2>/dev/null | head -n1)
      if [ -n "$ANDROID_ART_ROOT" ]; then
         dalvikvm=$(readlink -f "$(find "$ANDROID_ART_ROOT" \( -type f -o -type l \) -name "dalvikvm")")
         if [ -z "$dalvikvm" ]; then if $IS64BIT; then dalvikvm=$(find "$ANDROID_ART_ROOT" \( -type f -o -type l \) -name "dalvikvm64"); else dalvikvm=$(find "$ANDROID_ART_ROOT" \( -type f -o -type l \) -name "dalvikvm32"); fi; fi
      fi
      if ! $dalvikvm -showversion >/dev/null 2>&1; then
         echo2 "--------DALVIKVM LOGGING--------"
         if [ -f "$(readlink -f "$dalvikvm")" ]; then
            echo2 "$($dalvikvm -Xuse-stderr-logger -verbose:class,collector,compiler,deopt,gc,heap,interpreter,jdwp,jit,jni,monitor,oat,profiler,signals,simulator,startup,threads,verifier,verifier-debug,image,systrace-locks,plugin,agents,dex -showversion 2>&1)"
         else
            echo2 "Unable to find dalvikvm!"
            [ -d /apex ] && echo2 "$(find /apex -type f -name "dalvikvm*")"
         fi
         echo2 "--------------------------------"
         echo "CANT LOAD DALVIKVM " && return 1
      fi
   fi
   file="$1"
   if [ ! -f "$file" ]; then echo2 "CANT FIND: $file" && return 1; fi
   main=$(unzip -qp "$file" "META-INF/MANIFEST.MF" 2>/dev/null | grep -m1 "^Main-Class:" | cut -f2 -d: | tr -d " " | dos2unix)
   if [ -z "$main" ]; then
      echo "Cant get main: $file " && return 1
   fi
   shift 1
   if ! $dalvikvm -Djava.io.tmpdir=. -Xnodex2oat -cp "$file" $main "$@" 2>/dev/null; then if $dalvik_logging; then $dalvikvm -Xuse-stderr-logger -Djava.io.tmpdir=. -Xnoimage-dex2oat -cp "$file" $main "$@"; else $dalvikvm -Djava.io.tmpdir=. -Xnoimage-dex2oat -cp "$file" $main "$@"; fi; fi
}

run_jar_addon() {
   local file
   file="$1"
   shift 1
   run_jar "$jars/$file" "$@"
}

apktool() {
   [ ! -f "$TMPDIR/1.apk" ] && cp -f /system/framework/framework-res.apk "$TMPDIR/1.apk"
   if [ ! -e "$jars/apktool.jar" ]; then ui_print " Cant find apktool.jar " && return 1; fi
   run_jar "$jars/apktool.jar" -a "$tools/aapt" --use-aapt1 -p "$TMPDIR" "$@"
}
