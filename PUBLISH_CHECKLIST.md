# TireMax Publish Checklist

Status (2026-10-13): `flutter analyze` clean, `flutter test` 60 passed, `flutter build apk --release` and `appbundle --release` succeed. Current builds are DEBUG-SIGNED because `android/key.properties` does not exist yet - not uploadable until step 1 is done. iOS/macOS/Windows/Linux not built here (no toolchain check).

## 1. Android signing
1. `keytool -genkey -v -keystore ~/tiremax-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
2. `cp flutter_app/android/key.properties.example flutter_app/android/key.properties` and fill in passwords, alias, absolute `storeFile`.
3. `cd flutter_app && flutter build appbundle --release` (signed automatically when key.properties exists).
4. Back up the .jks + passwords outside the repo (both are gitignored). Enrol in Play App Signing.
5. Output: `flutter_app/build/app/outputs/bundle/release/app-release.aab`.

## 2. Version / build bump
Edit `version: 1.0.0+1` in `flutter_app/pubspec.yaml` (name+buildNumber; build number must increase each upload), or override: `flutter build appbundle --release --build-name=1.0.1 --build-number=2`.
Production API is the default (`https://api.tiremaxiq.com/api/v1`); override only with `--dart-define=API_BASE_URL=...`.

## 3. Store listing needs
- App name TireMax, short (80) + full (4000) description, EN and AR.
- Icon 512x512 (Play) / 1024x1024 no alpha (App Store) - source `assets/icon/app_icon.png` (1024, RGB).
- Feature graphic 1024x500 (Play); phone screenshots (min 2; iOS 6.7" and 6.5" sets), ideally in EN and AR.
- Category (Auto / Shopping), contact email, support URL.
- Privacy policy URL: the web page `privacy-policy` in the Next.js app (`frontend/app/[locale]/privacy-policy`), i.e. `https://tiremaxiq.com/en/privacy-policy` (confirm the live domain/path before submitting).
- Play Data safety form: account info (name/email/phone), addresses, purchase/order history, photos (optional, image_picker), tokens stored on device; data in transit encrypted (HTTPS). Apple privacy "nutrition" labels equivalent.
- Content rating questionnaire; target audience adults; account-deletion route (Play and Apple require in-app/web deletion path if accounts can be created) - verify.
- iOS: needs Apple Developer account, bundle id registered, signing/provisioning set in Xcode, `flutter build ipa` on macOS.

## 4. What was configured
- Name "TireMax": Android label, iOS CFBundleDisplayName/CFBundleName, web manifest/title, macOS PRODUCT_NAME, Windows/Linux window titles.
- Android: INTERNET permission in main manifest, no cleartext flag (HTTPS only), R8 minify + resource shrink, `proguard-rules.pro` (Flutter, secure storage/Tink, Play Core dontwarn).
- iOS Info.plist: NSPhotoLibraryUsageDescription, NSCameraUsageDescription, LSApplicationQueriesSchemes https/tel/mailto/whatsapp.
- No debug print/logging of tokens in `lib`; `debugShowCheckedModeBanner: false` in MaterialApp.app (covers all screens).
- Dependencies: `flutter pub upgrade` within existing constraints only (28 minor/patch bumps); build_runner, analyze, tests re-run clean. 22 major-version upgrades deliberately skipped.

## 5. Needs owner decision
- Application ID `com.tiremax.tiremax_app` (kept). It is permanent once published; consider `com.tiremax.app` / a domain-based id (`iq.tiremaxiq.app`) BEFORE first upload. Changing needs android namespace/applicationId, iOS PRODUCT_BUNDLE_IDENTIFIER, macOS, Linux APPLICATION_ID (currently `com.example.flutter_app`), and moving the Kotlin package dir.
- Dart package name is still `flutter_app` (internal only; renaming touches all imports).
- Icon: 1024 RGB with no transparency, used as adaptive foreground on #0E0E0E - confirm visually that the logo is not cropped by the adaptive-icon safe zone (inner ~66%); likely needs padding.
- Release APK is 68 MB fat; Play delivers per-ABI from the AAB. Use `--split-per-abi` for sideloaded APKs.
- Unused/discontinued transitive packages (`flutter_secure_storage_macos`, `js`) come from pinned majors; major upgrades (e.g. flutter_secure_storage 10, go_router) need a separate tested pass.
- Android compile warning "source value 8 obsolete" comes from a plugin, harmless.
