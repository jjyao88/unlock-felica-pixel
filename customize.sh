##########################################################################################
#
# MMT Extended Config Script
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Uncomment and change 'MINAPI' and 'MAXAPI' to the minimum and maximum android version for your mod
# Uncomment DYNLIB if you want libs installed to vendor for oreo+ and system for anything older
# Uncomment PARTOVER if you have a workaround in place for extra partitions in regular magisk install (can mount them yourself - you will need to do this each boot as well). If unsure, keep commented
# Uncomment PARTITIONS and list additional partitions you will be modifying (other than system and vendor), for example: PARTITIONS="/odm /product /system_ext"
MINAPI=30
MAXAPI=34
#DYNLIB=true
#PARTOVER=true
#PARTITIONS=""

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

REPLACE="
/system/system_ext/priv-app/PixelNfc
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
    # For directories (includes files in them):
    # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
    set_perm_recursive $MODPATH/system/system_ext/priv-app/PixelNfc 0 0 0755 0644

    # For files (not in directories taken care of above)
    # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
    set_perm $MODPATH/system/product/etc/felica/common.cfg 0 0 0644
}

##########################################################################################
# MMT Extended Logic - Don't modify anything after this
##########################################################################################

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh
