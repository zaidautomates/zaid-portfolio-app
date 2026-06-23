# Zaid Portfolio App — V3 Interactive

A premium, interactive personal portfolio mobile application built with Flutter and Dart for the **Codiora Remote Internship Program — Weeks 1 to 3 Mobile App Development Tasks**.

---

## 📱 Project Overview

This mobile application acts as a professional digital portfolio, enabling users to explore career details, educational history, technical skill progressions, and featured projects. 

Over three weeks, the app evolved from a static single-screen display into a highly interactive, custom-state-managed full-portfolio tool with local preferences persistence, category filtering, search features, profile editing screens, dynamic external links, and custom brand graphics.

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
*   **📊 Animated Skill Sliders:** Skills list with percentage progress bars and curved animations.
*   **🎨 Light & Dark Theme Support:** Dual theme schemes with contrast handling.
*   **🔗 Social links:** LinkedIn, GitHub, Email, and website routing.

### 𝑾𝒆𝒆𝒌 3: Interactive & Visual Upgrades
*   **🎨 Premium UI Card Redesign:** Re-engineered the project listing cards to feature a top cover image, a floating glassmorphic category badge, and an outlined "View Project" action button.
*   **🖼️ High-Fidelity Mockup Assets:** Generated 6 professional project mockup and diagram illustrations using AI image generation, saving them in the `assets/` folder to serve as the real graphics for the listing and details pages.
*   **🛡️ Official Brand Logo Badges:** Replaced generic placeholder icons with custom-drawn, official brand logo graphics for **LinkedIn** (custom Inter-font typography widget), **GitHub** (scalable vector path `CustomPainter`), and **Flutter** (framework logo badge widget).
*   **🗂️ Dynamic Category Filters & Search:** Implemented choice chip tabs generated dynamically from the active project list (All, Mobile, Web, AI/ML, Dashboard) working concurrently with a case-insensitive search bar.
*   **🔗 Dynamic External Links:** Integrated external links (GitHub Repo and Live Demo buttons) that resolve safely and launch external native browser/app targets.
*   **✍️ Profile Editing Panel:** Custom scrollable editing form (validation checks on fields and email formatting) to edit Full Name, Role, Bio, Email, and Phone.
*   **💾 Storage Persistence:** Connected the app state to SharedPreferences to remember your edited profile details and dark/light mode preference across restarts.
*   **⚡ Performance & Build Optimizations:** Centralized state in a lightweight `ChangeNotifier` and optimized Android packaging to bypass space-path bugs and Kotlin cross-drive compiler caching issues.

---

## 🛠️ Technology Stack

*   **Frontend:** Flutter & Dart
*   **State Management:** `ChangeNotifier` & `AnimatedBuilder` (Lightweight, zero-overhead reactive state)
*   **Local Storage:** `shared_preferences`
*   **Routings & Utilities:** `url_launcher`
*   **Vector Drawing:** `CustomPainter` & custom path Beziers
*   **Theme Engine:** Material 3 Dark/Light configurations

---

## 📂 Project Structure

```text
zaid_portfolio_app/
│
├── android/            ← Configured for NDK debug builds with custom spacing-path corrections
├── assets/
│   ├── Profile.jpeg            ← Profile photo
│   ├── personal_portfolio.png  ← Mockup for Portfolio app
│   ├── ai_workflows.png        ← Mockup for AI Automation
│   ├── edunest_lms.png         ← Mockup for LMS Dashboard
│   ├── ecotrack.png            ← Mockup for Carbon Tracker
│   ├── devconnect.png          ← Mockup for Collaborative workspace
│   └── smarthome.png           ← Mockup for IoT Smart Home
│
├── lib/
│   └── main.dart       ← Contains App State, Model definitions, navigation flow, and all UI screens
│
├── pubspec.yaml        ← Dependency mapping (shared_preferences, url_launcher)
└── README.md
```

---

## 🚀 Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/zaidautomates/zaid-portfolio-app.git
    cd zaid-portfolio-app
    ```
2.  **Verify configuration targets:**
    If building on Windows without OS developer/symlink mode enabled, disable the Windows desktop platform first:
    ```bash
    flutter config --no-enable-windows-desktop
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run on Android emulator:**
    ```bash
    flutter devices
    ```
    ```bash
    flutter run
    ```

---

## 👨‍💻 Developer Information

*   **Zaid Ali** — Computer Science Student (Abdul Wali Khan University Mardan)
*   **GitHub:** [zaidautomates](https://github.com/zaidautomates)
*   **LinkedIn:** [zaidautomates](https://linkedin.com/in/zaidautomates)
