# The Magisk module to Unlock Felica on Global Pixel Devices

## Description
This module will *systemlessly* patch **PixelNfc** system app, which will check whether the pixel is Japanese SKU. Also mark FeliCa enabled in `felica_common.cfg`

I have only tested on Pixel 4 XL with Android 13, Should work on any Google Pixel device that runs Android 11+ at least.

## Download
[Download latest version](https://github.com/jjyao88/unlock-felica-pixel/releases)

## Recommend Apps to Install
- [Osaifu-Keitai](https://play.google.com/store/apps/details?id=com.felicanetworks.mfm.main) [com.felicanetworks.mfm.main]
- [Mobile FeliCa Client](https://play.google.com/store/apps/details?id=com.felicanetworks.mfc) [com.felicanetworks.mfc]
- [Osaifu-Keitai Setting Application](https://play.google.com/store/apps/details?id=com.felicanetworks.mfs) [com.felicanetworks.mfs]
- [Google Play services for payments](https://play.google.com/store/apps/details?id=com.google.android.gms.pay.sidecar) [com.google.android.gms.pay.sidecar]

After installing the module, for further use please install all the apps above from Play Store.

## Credits
- [Deep dive into enabling osaifu-keitai feature by Kormax](https://github.com/kormax/osaifu-keitai-google-pixel)

- [BlessGO's Dynamic Installer](https://forum.xda-developers.com/t/zip-dual-installer-dynamic-installer-stable-4-7-b3-android-10-or-earlier.4279541/)
