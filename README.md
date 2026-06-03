# 🚕 Taxi App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Google Maps](https://img.shields.io/badge/Google%20Maps-4285F4?style=for-the-badge&logo=google-maps&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-000000?style=for-the-badge&logo=bloc&logoColor=white)

A ride-hailing mobile application built with Flutter, supporting both **User** and **Driver** roles with real-time maps, trip management, and multi-language support.

## ✨ Features

### 👤 User Side
- 🗺️ Real-time map with location tracking
- 🚗 Trip booking and management
- 📋 Trip history
- 👨‍💼 Profile management

### 🚘 Driver Side
- 📍 Live map with trip requests
- 💰 Trip offers and acceptance
- 📋 Trip management and history
- ⚙️ Driver settings and profile

### 🌐 General
- 🔐 Firebase Authentication (Phone / Email)
- 🗺️ Google Maps integration
- 📡 Real-time location tracking
- 🌗 Dark / Light theme support
- 🌍 Multi-language support (English & Arabic)
- 🎬 Onboarding and splash screens
- 📱 Responsive UI with ScreenUtil

## 🏗️ Architecture

The project follows **Clean Architecture** with a feature-first folder structure:

```
lib/
├── core/                   # Shared utilities, services, theme, routing
│   ├── errors/
│   ├── functions/
│   ├── helper/
│   ├── lang/
│   ├── models/
│   ├── routing/
│   ├── services/
│   ├── theme/
│   ├── theme_cubit/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/               # Authentication (login, register, OTP)
│   ├── driver/             # Driver-side features
│   │   ├── driver_map/
│   │   ├── driver_trips/
│   │   ├── offers/
│   │   └── settings/
│   ├── intro/              # Splash, onboarding, welcome
│   ├── language/           # Language selection
│   └── user/               # User-side features
│       ├── home/
│       ├── profile/
│       └── trips/
└── main.dart
```

Each feature follows the layered structure:
- **data/** — Data sources, models, repository implementations
- **domain/** — Entities, repository contracts
- **presentation/** — Cubits/Blocs, pages, widgets

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter (Dart 3.10+) |
| State Management | flutter_bloc / Cubit |
| Navigation | go_router |
| Backend | Firebase (Auth, Firestore) |
| Maps | Google Maps Flutter |
| Networking | Dio |
| DI | get_it |
| Localization | easy_localization |
| Responsive UI | flutter_screenutil |
| Local Storage | shared_preferences |

## 🚀 Getting Started

### 📋 Prerequisites

- Flutter SDK ^3.10
- Dart SDK ^3.10.7
- Firebase project configured
- Google Maps API key

### 📥 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/taxi-app.git
   cd taxi-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Set up a Firebase project
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Ensure `firebase_options.dart` is generated

4. Add your Google Maps API key:
   - **Android:** `android/app/src/main/AndroidManifest.xml`
   - **iOS:** `ios/Runner/AppDelegate.swift`

5. Run the app:
   ```bash
   flutter run
   ```

## 📁 Assets

```
assets/
├── fonts/          # Manrope font family
├── icons/
├── images/
├── json/           # Map style configuration
├── lottie/         # Animations
├── svgs/
└── translations/   # en.json, ar.json
```

## 🎨 Design

- **Design Size:** 390 x 884 (iPhone 14 Pro base)
- **Font:** Manrope (400–800 weights)
- **Themes:** Light and Dark with dynamic switching via ThemeCubit
