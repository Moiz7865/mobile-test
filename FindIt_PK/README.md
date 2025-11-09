FindIt_PK - Flutter Local Services Browser

How to run (latest stable Flutter):
- Ensure Flutter stable (3.x) is installed and on PATH.
- From this directory:
  - flutter pub get
  - flutter run
  - flutter build apk
  - flutter build appbundle

Key implementation notes:
- Uses Android v2 embedding:
  - MainActivity is Kotlin extending FlutterActivity (see [FindIt_PK/android/app/src/main/kotlin/com/example/findit_pk/MainActivity.kt](FindIt_PK/android/app/src/main/kotlin/com/example/findit_pk/MainActivity.kt)).
  - AndroidManifest declares <meta-data android:name="flutterEmbedding" android:value="2"/> and a single MainActivity entry.
- Uses Material 3 with colorSchemeSeed in [FindIt_PK/lib/main.dart:15](FindIt_PK/lib/main.dart:15).
- No database or local storage:
  - All businesses are defined as in-memory constants in [FindIt_PK/lib/main.dart:45](FindIt_PK/lib/main.dart:45).
  - Helper file [FindIt_PK/lib/business_data.dart:1](FindIt_PK/lib/business_data.dart:1) simply re-exports this static list.
- Features:
  - Home screen:
    - Search bar filters by name, category, and city.
    - Horizontal category chips including "All".
    - Responsive layout: list on phones, grid on wider screens.
  - Detail screen:
    - Shows name, category, city, description, and hero-style image.
    - Buttons:
      - Call: launches tel: link via url_launcher.
      - WhatsApp: opens wa.me with cleaned phone.
      - Get Directions: opens Google Maps search URL.
- Dependencies:
  - url_launcher ^6.3.0 (configured in [FindIt_PK/pubspec.yaml:12](FindIt_PK/pubspec.yaml:12)).
- Assets:
  - assets/images/ declared (for future use). Current UI uses remote sample images via HTTPS.

Build compatibility checklist:
- Min SDK / Gradle / Kotlin are expected to be configured by your local `flutter create`. If any android/ files are missing (e.g., build.gradle, settings.gradle, etc.), create the project via:
  - flutter create FindIt_PK
  - Then replace:
    - lib/main.dart with this repository’s [FindIt_PK/lib/main.dart](FindIt_PK/lib/main.dart)
    - android/app/src/main/AndroidManifest.xml with this repository’s manifest
    - android/app/src/main/kotlin/.../MainActivity.kt with this repository’s MainActivity
    - pubspec.yaml with this repository’s [FindIt_PK/pubspec.yaml](FindIt_PK/pubspec.yaml)
- Afterwards, `flutter build apk` and `flutter build appbundle` should succeed on modern stable.