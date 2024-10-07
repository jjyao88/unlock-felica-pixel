ui_print "-----------------------------------------------"
ui_print "  Unlock Felica on Global Pixel Devices        "
ui_print "-----------------------------------------------"
ui_print "  by @jjyao88      |   Version: 2.3            "
ui_print "-----------------------------------------------"
ui_print "  -- Only Support Pixel Devices                "
ui_print "-----------------------------------------------"
ui_print " "

STOCK_APK="/system/system_ext/priv-app/PixelNfc/PixelNfc.apk"
FELICA_CFG="/system/product/etc/felica/common.cfg"

ui_print " -- Checking Felica config"

if ! exist "$FELICA_CFG"; then
    abort "felica/common.cfg is missing. It seems that you are not using a Pixel device."
fi

cp $FELICA_CFG "$TMPDIR/felica_common.cfg"

ui_print " -- Patching Felica config"

remove_line_by_pattern() {
    pattern="$1"
    file="$2"

    grep -nw "$pattern" "$2" | while read huh; do
        start_line=$(echo "$huh" | cut -f1 -d:)
        awk -v start=$((start_line)) -v end=$((start_line)) 'NR<start || NR>end' "$2" >"$2.tmp"
        mv "$2.tmp" "$2"
    done
}

remove_line_by_pattern "00000014" "$TMPDIR/felica_common.cfg"
remove_line_by_pattern "00000015" "$TMPDIR/felica_common.cfg"

if ! grep -q "00000018,1" "$TMPDIR/felica_common.cfg"; then
    printf "00000018,1\n" >>"$TMPDIR/felica_common.cfg"
fi

move "$TMPDIR/felica_common.cfg" "$MODPATH$FELICA_CFG"

ui_print " "
ui_print " -- Done "
ui_print " "
