#Magisk modules use $MODPATH as main path
#Your script starts here:
ui_print "-----------------------------------------------"
ui_print "  Unlock Felica on Global Pixel Devices        "
ui_print "-----------------------------------------------"
ui_print "  by @jjyao88      |   Version: 1.0            "
ui_print "-----------------------------------------------" 
ui_print "  -- Only Support Pixel Devices                "
ui_print "-----------------------------------------------" 
ui_print " "

STOCK_APK=$(find_apk com.google.android.pixelnfc /system/system_ext)
FELICA_CFG="/system/product/etc/felica/common.cfg"

REPLACE_SMALI='
    .locals 1
    const/4 p0, 0x1
    return p0
'

ui_print " -- Decompiling PixelNfc.apk"
dynamic_apktool -decompile $STOCK_APK -output "$TMP/pixelnfc"

ui_print " -- Patching PixelNfc.apk"
smali_kit -check -method "isDeviceJapanSku" -dir "$TMP/pixelnfc" -static-name "DeviceInfoContentProvider.smali" -remake "$REPLACE_SMALI"

ui_print " -- Recompiling PixelNfc.apk"
dynamic_apktool -recompile "$TMP/pixelnfc" -output "$TMP/pixelnfc_unsigned.apk" -zipalign
ui_print " L: Signing PixelNfc.apk"
run_jar_addon "apksigner.jar" sign --v4-signing-enabled --key "$addons/keys/testkey.pk8" --cert "$addons/keys/testkey.x509.pem" --in "$TMP/pixelnfc_unsigned.apk" --out "$TMP/pixelnfc.apk"
move "$TMP/pixelnfc.apk" "$MODPATH$STOCK_APK"

if ! is_valid "$MODPATH$STOCK_APK"; then
   abort "An error occurred during the APK recompilation."
fi

ui_print " -- Setting PixelNfc.apk permission"
set_context "$STOCK_APK" "$MODPATH$STOCK_APK"

# ui_print " -- Installing Osaifu-keitai apps and Google Play services for payments"
# package_extract_dir apks $TMP/apks
# apk_install_recursive $TMP/apks

ui_print " -- Update Felica config"
cp $FELICA_CFG "$TMP/felica_common.cfg"
add_lines_string "00000018,1" "$TMP/felica_common.cfg"
move "$TMP/felica_common.cfg" "$MODPATH$FELICA_CFG"
set_context "$FELICA_CFG" "$MODPATH$FELICA_CFG"

ui_print " "
ui_print " -- Done "
ui_print " "