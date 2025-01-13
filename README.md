# The Magisk module to Unlock Felica on Global Pixel Devices

## Description
This module will *systemlessly* patch **PixelNfc** system app, which will check whether the pixel device is Japanese SKU. Also mark FeliCa enabled in `felica/common.cfg`.

Both Magisk and KernelSU root solutions are supported.

## Download
[Download latest version](https://github.com/jjyao88/unlock-felica-pixel/releases)

## For KernelSU users
> [!IMPORTANT]  
> In KernelSU, all non-root apps cannot read modified system files by default.
> 
> To make unlocking Felica successfully, you must open KernelSU Manager and **disable Umount modules** option for all related apps in App Profile.
<img src="https://github.com/jjyao88/unlock-felica-pixel/assets/11062997/1d6a416c-bd5c-4be2-80b9-a3a3be0bdd08" height="500">

## Device Support Table
Feel free to leave test result in the issues if your device isn't listed below.

| Device | Unlockable? | Notes |
|---------|---------------|-------|
| Pixel 4a (sunfish) | ✅ | tested on Android 13
| Pixel 4 XL (coral) | ✅ | tested on Android 13
| Pixel 4a 5G (bramble) | ✅ | tested on Android 14
| Pixel 5 (redfin) | ✅ | v2.2 tested on Android 14
| Pixel 6 (oriole) | ✅ | v2.2 tested on Android 14
| Pixel 6 Pro (raven) | ✅ | v2.2 tested on Android 13
| Pixel 7 (panther) | ✅ | feedback from [#11](https://github.com/jjyao88/unlock-felica-pixel/issues/11)
| Pixel 7 Pro (cheetah) | ✅ | v2.2 tested
| Pixel 7a (lynx) | ✅ | v2.1.1 fully worked on A14, see [#12](https://github.com/jjyao88/unlock-felica-pixel/issues/12)
| Pixel 8 (shiba) | ✅ | v2.2 tested
| Pixel 8 Pro (husky) | ✅ | v2.2 tested
| Pixel 9 (tokay) | ✅ | on Android 15 [#27](https://github.com/jjyao88/unlock-felica-pixel/issues/27)
| Pixel 9 Pro XL (komodo) | ✅ | on Android 14 / 15 [#24](https://github.com/jjyao88/unlock-felica-pixel/issues/24)
| Pixel 9 Pro Fold (comet) | ✅ | on Android 14 / 15 [#19](https://github.com/jjyao88/unlock-felica-pixel/issues/19)

## Recommend Apps to Install
- [Osaifu-Keitai](https://play.google.com/store/apps/details?id=com.felicanetworks.mfm.main) [com.felicanetworks.mfm.main]
- [Mobile FeliCa Client](https://play.google.com/store/apps/details?id=com.felicanetworks.mfc) [com.felicanetworks.mfc]
- [Osaifu-Keitai Setting Application](https://play.google.com/store/apps/details?id=com.felicanetworks.mfs) [com.felicanetworks.mfs]
- [Google Play services for payments](https://play.google.com/store/apps/details?id=com.google.android.gms.pay.sidecar) [com.google.android.gms.pay.sidecar]

After installing the module, for further use please install all the apps above from Play Store.

## FAQ
- After installing the module, I am still unable to complete the initial card setup or open the Osaifu-Keitai app.
  - KernelSU users: Ensure that the "Unmount modules" option is disabled.
  - SUList root solution users (e.g., Kitsune Delta): While it may seem unusual, please add the "Osaifu-Keitai app" to your SUList. If you have any concerns regarding security, consider using KernelSU as an alternative.
- I can open the Osaifu-Keitai app and manage my card successfully, but I am unable to use my card to pass the gate at the station.
  - Please ensure that you have not activated any NFC-related modules (e.g., NFC card emulator) that may interfere with Felica functionality.

## Credits
- [Deep dive into enabling osaifu-keitai feature by Kormax](https://github.com/kormax/osaifu-keitai-google-pixel)

- [BlessGO's Dynamic Installer](https://forum.xda-developers.com/t/zip-dual-installer-dynamic-installer-stable-4-7-b3-android-10-or-earlier.4279541/)
