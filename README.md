# The Magisk module to Unlock Felica on Global Pixel Devices

## Description
This module will *systemlessly* patch **PixelNfc** system app, which will check whether the pixel device is Japanese SKU. Also mark FeliCa enabled in `felica/common.cfg`.

Both Magisk and KernelSU root solutions are supported.

## Download
[Download latest version](https://github.com/jjyao88/unlock-felica-pixel/releases)

## Device Support Table
Feel free to leave test result in the issues if your device isn't listed below.

| Device | Unlockable? | Notes |
|---------|---------------|-------|
| Pixel 4 XL (coral) | ✅ | tested on Android 13
| Pixel 8 Pro (husky) | ❌ | failed during initial setup in version 2.1.1 (see [#3](https://github.com/jjyao88/unlock-felica-pixel/issues/3))

## Recommend Apps to Install
- [Osaifu-Keitai](https://play.google.com/store/apps/details?id=com.felicanetworks.mfm.main) [com.felicanetworks.mfm.main]
- [Mobile FeliCa Client](https://play.google.com/store/apps/details?id=com.felicanetworks.mfc) [com.felicanetworks.mfc]
- [Osaifu-Keitai Setting Application](https://play.google.com/store/apps/details?id=com.felicanetworks.mfs) [com.felicanetworks.mfs]
- [Google Play services for payments](https://play.google.com/store/apps/details?id=com.google.android.gms.pay.sidecar) [com.google.android.gms.pay.sidecar]

After installing the module, for further use please install all the apps above from Play Store.

## Credits
- [Deep dive into enabling osaifu-keitai feature by Kormax](https://github.com/kormax/osaifu-keitai-google-pixel)

- [BlessGO's Dynamic Installer](https://forum.xda-developers.com/t/zip-dual-installer-dynamic-installer-stable-4-7-b3-android-10-or-earlier.4279541/)
