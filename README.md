# Ripple 🌊 | High-Performance Social Media Ecosystem

<p align="center">
  <img src="assets/images/logo.webp" width="120" alt="Ripple Logo">
  <br>
  <b>An Enterprise-Grade Social Experience built with Flutter & Firebase.</b>
  <br>
  <i>"Engineered for Scalability, Designed for Elegance."</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase">
  <img src="https://img.shields.io/badge/Architecture-Clean--Feature--First-green?style=for-the-badge" alt="Clean Architecture">
  <img src="https://img.shields.io/badge/FCM--v1-Secure-orange?style=for-the-badge" alt="FCM v1">
</p>

---

## 🚀 Architectural Vision

**Ripple** isn't just an app; it's a technical manifesto. It demonstrates how to build a scalable social network using modern software engineering principles.

### 💎 Technical Core
*   **FCM v1 Enterprise Messaging**: Implemented the latest **HTTP v1 API** with **Google OAuth 2.0** for secure, server-side notification delivery.
*   **Feature-First Clean Architecture**: Decoupled modules (Auth, Feed, Profile) ensuring 100% testability and independent scaling.
*   **Sub-collection Optimization**: Advanced Firestore schema design using sub-collections for Comments and Replies to minimize document size and optimize read costs.
*   **Dynamic UI Engine**: A custom-built theming and localization system that handles RTL (Arabic) and LTR (English) transitions instantly without state loss.
*   **Cloudinary Media Stack**: High-speed image transformation and CDN delivery integrated via Cloudinary API.

---

## 📸 Premium UI Showcase

<div align="center">
  <table>
    <tr>
      <td align="center"><b>🏠 Dynamic Feed</b></td>
      <td align="center"><b>👤 User Profile</b></td>
      <td align="center"><b>💬 Real-time Engagement</b></td>
    </tr>
    <tr>
      <td><img src="assets/screenshots/home.png" width="260"></td>
      <td><img src="assets/screenshots/profile.png" width="260"></td>
      <td><img src="assets/screenshots/comments.png" width="260"></td>
    </tr>
  </table>
</div>

---

## 🏗 System Design & Engineering

The application is built on a **Modular Clean Architecture** to ensure that business logic is completely isolated from the UI and external frameworks.

### Engineering Layers:
1.  **Presentation Layer**: `Cubit` (BLoC) for state management with optimized `buildWhen` logic to prevent redundant UI jank.
2.  **Domain Layer**: Pure Dart entities and repository interfaces defining the "What" of the application.
3.  **Data Layer**: Implementation of repositories, handling Firestore streams, Cloudinary uploads, and Local Caching.

```mermaid
graph LR
    subgraph UI_Layer
    A[Widgets] --> B[Cubit/States]
    end
    subgraph Domain_Layer
    B --> C[Repository Interfaces]
    C --> D[Use Cases/Entities]
    end
    subgraph Data_Layer
    D --> E[Firestore & FCM v1]
    D --> F[Cloudinary API]
    end
```

---

## 🛠 Tech Stack

*   **Core**: Flutter Stable (Dart)
*   **State Management**: BLoC / Cubit (Production Pattern)
*   **Backend**: Firebase (Authentication, Firestore, Messaging v1)
*   **Storage & CDN**: Cloudinary
*   **DI**: GetIt (Service Locator)
*   **Architecture Patterns**: Repository Pattern, Factory, Singleton, Observer

---

## 📊 GitHub Contribution & Stats

<p align="center">
  <img src="https://github-readme-stats.vercel.app/api?username=OmarShawkey13&show_icons=true&theme=tokyonight" alt="GitHub Stats">
  <br>
  <img src="https://github-readme-stats.vercel.app/api/top-langs/?username=OmarShawkey13&layout=compact&theme=tokyonight" alt="Top Languages">
</p>

---

## 📂 Project Structure (The Architecture)

The project is engineered using a **Feature-First Modular Clean Architecture**, ensuring strict separation between core infrastructure and business features.

```bash
lib/
├── core/
│   ├── di/               # Dependency Injection (GetIt) & Service Locator
│   ├── models/           # Data Transfer Objects (User, Post, Comment models)
│   ├── network/          # Data Layer: Repositories & External Services (Firebase, Cloudinary)
│   ├── theme/            # Design System: ColorsManager, TextStylesManager, & AppTheme
│   └── utils/
│       ├── constants/    # Spacing Manager, Routes, & Localized Constants
│       │   └── primary/  # Atomic Reusable Components (ConditionalBuilder, etc.)
│       └── cubit/        # Global Logic (ThemeCubit, AuthCubit, HomeCubit)
└── features/
    ├── home/             # Presentation Layer: Infinite Feed, Posting, & Engagement
    ├── profile/          # User Identity, Social Graph, & Account Settings
    ├── login/register/   # Secure Authentication Modular Flow
    └── on_boarding/      # Premium UX Entry Experience
```

---

## 🏁 Getting Started

1.  **Clone**: `git clone https://github.com/OmarShawkey13/ripple.git`
2.  **Config**: Add `google-services.json` and FCM v1 Service Account keys.
3.  **Deploy**: `flutter pub get` && `flutter run --release`

---

## 👨‍💻 Developed By
**Omar Shawkey** - *Senior Flutter Engineer*

[![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?style=for-the-badge&logo=github)](https://github.com/OmarShawkey13)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-0A66C2?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/omarshawkey)

> "True engineering is making the complex seem simple. Ripple is a testament to that."

---
⭐ **Star this repository if you find this architecture helpful!**
