ui_print "-----------------------------------------------"
ui_print "  Unlock Felica on Global Pixel Devices        "
ui_print "-----------------------------------------------"
ui_print "  by @jjyao88      |   Version: 2.1.1          "
ui_print "-----------------------------------------------"
ui_print "  -- Only Support Pixel Devices                "
ui_print "-----------------------------------------------"
ui_print " "

STOCK_APK="/system/system_ext/priv-app/PixelNfc/PixelNfc.apk"
FELICA_CFG="/system/product/etc/felica/common.cfg"
REPLACE_SMALI="\t.locals 1\n\tconst/4 p0, 0x1\n\treturn p0"

ui_print "APK Target: $STOCK_APK"

if ! exist "$STOCK_APK"; then
    abort "PixelNfc.apk is not found. It seems that you are not using a Pixel device."
fi

ui_print " -- Decompiling PixelNfc.apk"
apktool --no-res -f d $STOCK_APK -o "$TMPDIR/pixelnfc"

ui_print " -- Patching PixelNfc.apk"

grep -rnw "$TMPDIR/pixelnfc" -e "isDeviceJapanSku" | while read huh; do
    dir=$(echo "$huh" | cut -f1 -d:)
    start_line=$(echo "$huh" | cut -f2 -d:)
    liner=$(echo "$huh" | cut -f3 -d:)
    [ ! -f "$dir" ] && continue
    [ -z "$liner" ] && continue
    if [[ "$liner" == *".method"* && "$liner" != *".method abstract"* && "$liner" != *".method public abstract"* ]]; then
        end_line=$(awk "/^\.end method/ && NR>$start_line { print NR; exit}" "$dir")
        awk -v start=$((start_line + 1)) -v end=$((end_line - 1)) -v rep="$REPLACE_SMALI" 'NR==start{print rep} NR<start || NR>end' "$dir" >"$dir.tmp"
        mv "$dir.tmp" "$dir"
        break
    fi
done

ui_print " -- Recompiling PixelNfc.apk"
apktool -f b "$TMPDIR/pixelnfc" -o "$TMPDIR/pixelnfc_unsigned.apk"

if ! is_valid "$TMPDIR/pixelnfc_unsigned.apk"; then
    abort "$TMPDIR/pixelnfc_unsigned.apk is not found."
fi

ui_print "  L: Zipaligning PixelNfc.apk"
zipalign -p -f -v 4 "$TMPDIR/pixelnfc_unsigned.apk" "$TMPDIR/pixelnfc_align.apk" >/dev/null
if ! is_valid "$TMPDIR/pixelnfc_align.apk"; then
    abort "$TMPDIR/pixelnfc_align.apk is not found."
fi

ui_print " L: Signing PixelNfc.apk"
run_jar_addon "apksigner.jar" sign --v4-signing-enabled --key "$MODPATH/common/keys/testkey.pk8" --cert "$MODPATH/common/keys/testkey.x509.pem" --in "$TMPDIR/pixelnfc_align.apk" --out "$TMPDIR/pixelnfc.apk"
move "$TMPDIR/pixelnfc.apk" "$MODPATH$STOCK_APK"

if ! is_valid "$MODPATH$STOCK_APK"; then
    abort "An error occurred during the APK signing."
fi

ui_print " -- Setting PixelNfc.apk permission"

ui_print " -- Checking Felica config"
cp $FELICA_CFG "$TMPDIR/felica_common.cfg"

# check if the line is already there
if grep -q "00000018,1" "$TMPDIR/felica_common.cfg"; then
    ui_print " -- Felica config is already patched"
else
    ui_print " -- Patching Felica config"
    echo "00000018,1" >>"$TMPDIR/felica_common.cfg"
fi

move "$TMPDIR/felica_common.cfg" "$MODPATH$FELICA_CFG"

ui_print " "
ui_print " -- Done "
ui_print " "
