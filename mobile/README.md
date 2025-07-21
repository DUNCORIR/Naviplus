# 📱 Naviplus - Mobile App (Flutter)

This is the **Flutter-based mobile app** for visually impaired users, designed to provide **indoor navigation assistance** using voice and screen-based interfaces.

The app interacts with the Django backend and provides spoken instructions for navigating within buildings.

---

## 📲 Features

* 🔐 Login + Signup using token-based auth
* 🧽 Voice-assisted navigation from one PLD to another
* 🏢 Scan available buildings and explore locations
* 🎤 Voice command interface (“Start from X to Y”)
* 🔄 Caches recent selections (building, start, end)
* ♿ Accessible UI with text-to-speech (TTS)

---

## 💠 Tech Stack

* Flutter 3.x (Dart)
* `flutter_tts` for Text-to-Speech
* `speech_to_text` for speech input
* `http` for REST API calls
* `shared_preferences` for local token caching
* Android/iOS platform support

---

## 🔧 Directory Structure

```
lib/
├── main.dart                 # Entry point and route setup
├── models/                  # Data models: Building, PLD
├── screens/                 # UI screens: login, menu, nav assist, etc.
├── services/                # API service layer (with auth token)
└── widgets/                 # Reusable components (buttons, dropdowns, etc.)
```

---

## 🚀 Getting Started

### 1. Clone and Install Dependencies

```bash
cd mobile
flutter pub get
```

### 2. Connect Device or Emulator

```bash
flutter devices
flutter run
```

> ⚠️ Some features like voice recognition (`speech_to_text`) may not work on Linux or web. Use a mobile emulator or real Android device.

---

## 🔐 Auth Flow

* On login, the token is stored in `SharedPreferences`
* All API calls automatically attach `Authorization: Token <token>` using the service layer

---

## 🤖 Voice Commands

Supported speech patterns:

* “Start from entrance to lift”
* “Navigate to reception”
* “Scan building”
* “Logout”

Voice is parsed and routes the user accordingly.

---

## 🗺️ Google Maps Integration

* Integrated Google Maps Flutter SDK
* Uses your API key inside `android/app/src/main/AndroidManifest.xml`

```xml
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_API_KEY_HERE

## ✅ Roadmap

* 🔄 Add turn-by-turn floor logic
* 😣️ Add voice confirmation for actions
* 📍 Use indoor GPS/mapping APIs for real-time position
* 🧪 Unit + widget tests for TTS, auth, API calls