# Tasks

## Add Internet Permission to Android Manifest

- **Objective:** Ensure the map tiles load correctly on Android.
- **Details:** Add the following permission in `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  ```
- **Steps:**
  1. Open `android/app/src/main/AndroidManifest.xml`.
  2. Add the permission line above within the `<manifest>` tag.
  3. Rebuild and reinstall the app on Android.


Add in gradle 
 android {
    ndkVersion = "27.0.12077973"
}
