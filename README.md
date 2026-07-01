# Zaid Portfolio App — V4 API Connected & Visually Polished

A premium, interactive, and API-powered personal portfolio mobile application built with Flutter and Dart, integrated with a Node.js Express backend for the **Codiora Remote Internship Program — Weeks 1 to 4 Tasks**.

---

## 📱 Project Overview

This mobile application acts as a professional digital portfolio, enabling users to explore career details, educational history, technical skill progressions, and featured projects loaded dynamically from a backend server database. 

Over four weeks, the app evolved from a static single-screen display into a highly interactive, custom-state-managed full-portfolio tool with local preferences persistence, category filtering, search features, profile editing screens, dynamic external links, and custom brand graphics. In **Week 4**, the entire application was restructured into clean modular architectural folders, integrated with real-time REST API endpoints, secure session JWT tokens, and interactive camera/gallery profile image uploads. 

Additionally, the UI was polished with modern **glassmorphic design features**, **3D depth shadows**, **animated background glow orbs**, **staggered entrance curves**, and **emissive progress indicators** to deliver a premium user experience.

---

## ✨ Features Progressions

### 𝑾𝒆𝒆𝒌 1: Foundation
*   **🔐 Login Screen:** Entry validation interface matching credentials.
*   **🏠 Home Screen:** Intro cards, quick statistics, and navigation shortcuts.
*   **👤 Profile Screen:** Basic information, educational background, and technical stack details.
*   **💼 Projects Screen:** Listing of showcase projects.
*   **📞 Contact Screen:** Support links, professional location cards, and connect triggers.

### 𝑾𝒆𝒆𝒌 2: Navigation & Theming
*   **📱 Bottom Navigation:** Glassmorphic persistent bottom bar preserving tab states.
*   **💼 Project Details Screen:** Detailed popup transition displaying project summaries.
*   **📊 Animated Skill Slider:** Skills list with percentage progress bars and curved animations.
*   **🎨 Light & Dark Theme Support:** Dual theme schemes with contrast handling.
*   **🔗 Social links:** LinkedIn, GitHub, Email, and website routing.

### 𝑾𝒆𝒆𝒌 3: Interactive & Visual Upgrades
*   **🎨 Premium UI Card Redesign:** Re-engineered the project listing cards to feature a top cover image, a floating glassmorphic category badge, and an outlined "View Project" action button.
*   **🖼️ High-Fidelity Mockup Assets:** Generated professional project mockup illustrations, saving them in the `assets/` folder to serve as the real graphics for the listing and details pages.
*   **🛡️ Official Brand Logo Badges:** Replaced generic placeholder icons with custom-drawn, official brand logo graphics for **LinkedIn** (custom Inter-font typography widget), **GitHub** (scalable vector path `CustomPainter`), and **Flutter** (framework logo badge widget).
*   **🗂️ Category Filters & Search:** Choice chip tabs generated dynamically from the project list (All, Mobile, Web, AI/ML, Dashboard) working concurrently with a case-insensitive search bar.
*   **🔗 Dynamic External Links:** Integrated external links (GitHub Repo and Live Demo buttons) that resolve safely and launch external native browser/app targets.
*   **✍️ Profile Editing Panel:** Custom scrollable editing form (validation checks on fields and email formatting) to edit Full Name, Role, Bio, Email, and Phone.
*   **💾 Storage Persistence:** Connected the app state to SharedPreferences to remember your edited profile details and dark/light mode preference across restarts.

### 𝑾𝒆𝒆𝒌 4: REST API Backend Integration, Modular Refactor & Visual Polish
*   **🏗️ Modular Directory Refactor:** Cleaned up the monolithic `lib/main.dart` into separate logical packages: config, core (storage, network, theme), models, providers, screens, and widgets.
*   **🔒 Secure Session Storage:** Integrated `flutter_secure_storage` to encrypt and store JSON Web Tokens (JWT) for secure authentication state recovery.
*   **📡 Centralized HTTP Client:** Added `ApiClient` utilizing `http` with dynamic hostname resolution (`10.0.2.2:5000/api` for emulator vs `localhost` for web/desktop), request timeouts, and automated 401 token expiration handlers.
*   **🔄 Dynamic CRUD Syncing:** Re-engineered profile data, skills progress levels, contact information, social links, and project lists to sync directly with Express REST API routers.
*   **🖼️ Profile Picture Uploads:** Leveraged `image_picker` to capture or select images from Camera/Gallery, validating files under 5MB, compressing them, and updating the database dynamically.
*   **🎨 Skeleton Loaders (Task 2):** Created dynamic, pulse-animated shimmer project and skill loaders (`SkeletonProjectCard`/`SkeletonSkillCard`) to display when fetching server-side assets.
*   **✨ Redesigned Splash Screen (Task 3):** Upgraded splash screen with themed background elements, rotating gradient loading rings, custom font headings, and a smooth `FadeTransition` entrance.
*   **💎 GlassCard 3D Depth (Task 4):** Refined card elevation (blurRadius 28, offset `Offset(0, 14)`) and added simulated top-left beveled glass borders using custom `DecoratedBox` overlays.
*   **💥 AnimatedCard Tap Gesture (Task 5):** Added springy scale-down feedback (shrink to 0.96 on tap-down, expand on tap-up) for all project and theme cards.
*   **🌌 Dynamic Backdrop Orbs (Task 6):** Converted static backdrop to a stateful staggered loop, pulsating the opacities of purple, cyan, and gold background orbs over 4-second intervals.
*   **🎗️ Section Header Accents (Task 7):** Positioned vertical linear gradient accents alongside section headers.
*   **🌟 Emissive Skill Progress (Task 8):** Added cyan shadows to active skill levels for a neon-lit, glowing display.
*   **💻 Robust Test Coverage:** Mocked out method channels and HTTP clients within `widget_test.dart` to enable the suite to complete and pass 100% offline.

---

## 🛠️ Technology Stack

*   **Frontend Mobile**: Flutter & Dart (Material 3)
*   **Backend Server**: Node.js & Express (with Mongoose/MongoDB)
*   **State Management**: `Provider` (architectural multi-provider scopes)
*   **Encrypted Tokens**: `flutter_secure_storage` (AES encrypted session values)
*   **Data Serialization**: JSON-model mapping builders
*   **Media Picker**: `image_picker` (Gallery / Camera resolution)
*   **Local Caches**: `shared_preferences` (theme state configuration)
*   **API Utilities**: `http`, `connectivity_plus`, `mime`, `cached_network_image`

---

## 📂 Project Structure

```text
zaid_portfolio_app/
│
├── android/            ← Configured for NDK debug builds with custom spacing-path corrections
├── assets/             ← Local mockup previews and fallback images
├── run_portfolio.bat   ← Unified automatic startup script (starts server + runs Flutter)
│
├── lib/
│   ├── config/
│   │   └── api_config.dart             ← Platform-aware API endpoints
│   ├── core/
│   │   ├── network/
│   │   │   └── api_client.dart         ← Centralized HTTP requests & 401 callback
│   │   ├── storage/
│   │   │   ├── preferences_service.dart ← Non-sensitive data wrapping
│   │   │   └── secure_storage_service.dart ← Encrypted session storage
│   │   ├── theme/
│   │   │   └── app_theme.dart          ← Material 3 dark/light palettes
│   │   └── utils/
│   │       └── validators.dart         ← Form input validations
│   ├── models/
│   │   ├── auth_response_model.dart
│   │   ├── project_model.dart
│   │   ├── skill_model.dart
│   │   └── user_model.dart
│   ├── providers/
│   │   ├── auth_provider.dart          ← Login, logout, session restoration
│   │   ├── portfolio_provider.dart     ← Profile, skills, projects state & image upload
│   │   └── theme_provider.dart         ← Theme configuration provider
│   ├── screens/
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   ├── contact/
│   │   │   └── contact_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── navigation/
│   │   │   └── main_navigation_screen.dart
│   │   ├── profile/
│   │   │   ├── edit_profile_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── projects/
│   │   │   ├── project_details_screen.dart
│   │   │   └── projects_screen.dart
│   │   └── splash/
│   │       └── splash_screen.dart       ← Session recovery loader
│   ├── widgets/
│   │   ├── common/                      ← Reusable premium cards, avatars, backgrounds, skeletons
│   │   ├── profile/                     ← Skill progress bars
│   │   └── projects/                    ← Project cards and listings
│   └── main.dart                        ← App entry point & mock initialization setup
│
├── test/
│   └── widget_test.dart                 ← Interactive widget test coverage suite
│
├── pubspec.yaml        ← Dependency configuration
└── README.md
```

---

## 🚀 Installation & Setup

### Option 1: Automated Run (Recommended)
Simply double-click the **`run_portfolio.bat`** file in the project root directory. This will:
1. Automatically start your backend Node.js Express server on Port 5000 in a minimized background terminal.
2. Automatically run your Flutter application on your active emulator or connected device.

### Option 2: Manual Run
1. **Start the Backend API Server**:
   Navigate to the Node.js Express server directory and run:
   ```bash
   cd path/to/server
   npm install
   node server.js
   ```
2. **Build and Run the Flutter Application**:
   Navigate to this project directory and run:
   ```bash
   flutter pub get
   flutter run
   ```

### Option 3: Default Credentials
*   **Email**: `zaidautomates@gmail.com`
*   **Password**: `Zaid@2026`

---

## 👨‍💻 Developer Information

*   **Zaid Ali** — Computer Science Student (Abdul Wali Khan University Mardan)
*   **GitHub:** [zaidautomates](https://github.com/zaidautomates)
*   **LinkedIn:** [zaidautomates](https://linkedin.com/in/zaidautomates)
