<!-- <p align="center">
  <!-- PROJECT LOGO: Replace with actual logo 
  <img src="assets\images\AppIcon.jpeg" alt="NenasKita Logo" width="240" height="240">
</p>
-->
<h1 align="center">NenasKita</h1>

<p align="center">
  <strong>Digitalizing Melaka's Pineapple Industry</strong>
  <br>
  <em>Mendigitalkan Industri Nanas Melaka</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.32.8-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.81-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green" alt="Platform">
</p>

<p align="center">
  <!-- <a href="#live-demo--download">View Demo</a> &bull; -->
  <a href="#key-features">Features</a> &bull;
  <a href="#technology-stack">Technology Stack</a> &bull;
  <a href="#getting-started">Get Started</a> &bull;
  <a href="#team">Team</a>
</p>

---

## Executive Summary

**NenasKita** is a comprehensive mobile application developed to digitalize and modernize the pineapple farming industry in Melaka, Malaysia. Built in collaboration with **LPNM (Lembaga Perindustrian Nanas Malaysia)**, this platform connects farmers, buyers and wholesalers in a unified digital ecosystem.

The application addresses critical challenges faced by Melaka's pineapple farmers and entreprenuers, including lack of market visibility, absence of price transparency and inefficient seller-buyer connections. By providing real-time market data, harvest planning tools and direct communication channels, NenasKita empowers local farmers and entreprenuers.

---

## Team

<table>
<tr>
<td align="center">
<strong>Muhammad Akmal Hakim Hishamuddin</strong><br>
B032310162<br>
<em>Project Manager & System Analyst</em>
</td>
<td align="center">
<strong>Muhammad Arif Aiman Bin Karim</strong><br>
B032310257<br>
<em>Backend Developer</em>
</td>
<td align="center">
<strong>Nur Aqilah Binti Zaidi</strong><br>
B032310148<br>
<em>Frontend Developer</em>
</td>
</tr>
<tr>
<td align="center">
<strong>Nur Aina Sofea Binti Ahmad Nazzib</strong><br>
B032310108<br>
<em>Database Designer</em>
</td>
<td align="center">
<strong>Siti Balqis Binti Mat Muharam</strong><br>
B032310135<br>
<em>Software Testing, Validation and Deployment</em>
</td>
<td align="center">
</td>
</tr>
</table>

**Course**: Software Project Management (SULAM) 2025
**Institution**: Universiti Teknikal Malaysia Melaka (UTeM)

---
## Documentation

For detailed documentation, see our [Wiki](https://github.com/MalKim007/nenas-kita/wiki):
- [Architecture](wiki/Architecture)
- [Project Structure](Wiki/Project-Structure)
- [Database Schema](wiki/Database-Schema)
- [API Integrations](wiki/API-Integrations)
- [Roadmap](wiki/Roadmap)

---

## Contact

For inquiries about NenasKita:

- **Email**: [mkim8189@gmail.com]
- **Phone Number**: [011-72731088]

---

## Table of Contents

- [The Problem](#the-problem)
- [Our Solution](#our-solution)
- [Key Features](#key-features)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [Deployment](#deployment)
- [Acknowledgements](#acknowledgments)

---

## The Problem

Melaka's pineapple industry faces several critical challenges that hinder growth and efficiency:

| Challenge | Impact |
|-----------|--------|
| **Price Opacity** | No standardized pricing reference; buyers and farmers/entreprenuers negotiate blindly |
| **No Stock Visibility** | Buyers cannot easily find available products across multiple farms |
| **Absence of Planning Tools** | Farmers manage months of harvest cycles manually without digital assistance |
| **Difficult Discovery** | Buyers struggle to locate and connect with verified local farmers |

### Industry Context

- **Major Varieties**: Morris, Josapine, MD2, Sarawak, Yankee and more
- **3 Districts**: Melaka Tengah, Alor Gajah, Jasin
- **Harvest Cycle**: Multiple months from planting to harvest
- **Stakeholders**: Individual farmers, family farms, local buyers, wholesalers, processing companies

---

## Our Solution

NenasKita provides a **unified digital platform** that addresses each challenge:

```
Problem                          Solution
─────────────────────────────────────────────────────────────
No market information      ──►   Real-time product listings
Price opacity              ──►   Price history & trend analytics
No stock visibility        ──►   Centralized product catalog
No planning tools          ──►   Harvest planner with calendar
Difficult discovery        ──►   Map-based farm finder
```

### User Journey

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                                 NENASKITA ECOSYSTEM                            │
├────────────────────────────────────────────────────────────────────────────────┤
│                                                            LPNM ADMIN          │
│           BUYER                    Business Owner        (not implemented yet) │
│   ┌───────────────────┐          ┌─────────────────┐      ┌────────────┐       │
│   │ Register Business │          │ Discover Farms  │      │ Verify     │       │
│   │ List Products     │◄────────►│ Browse Products │      │ Farms      │       │
│   │ Plan Harvests     │          │ Compare Prices  │      │ Audit Logs │       │
│   │ Update Prices     │          │ Contact Farmer  │      │ Announce   │       │
│   └───────────────────┘          └─────────────────┘      └────────────┘       │
│          │                            │                       │                │
│          └────────────────────────────┼───────────────────────┘                │
│                                       │                                        │
│                          ┌────────────┴────────────┐                           │ 
│                          │    FIREBASE BACKEND     │                           │
│                          │  Firestore • Auth • FCM │                           │
│                          └─────────────────────────┘                           │
└────────────────────────────────────────────────────────────────────────────────┘
```

---

## Key Features

### For Farmers / Entreprenuers 

| Feature | Description |
|---------|-------------|
| **Business Profile Management** | Complete farm registration with LPNM license, location, varieties grown and social links |
| **Product Catalog** | List fresh and processed pineapple products with retail & wholesale pricing |
| **Harvest Planner** | Calendar-based planning with status tracking (Planned → Growing → Ready → Harvested) |
| **Social Media (Facebook & Instagram) and WhatsApp Integration** | Direct buyer communication via WhatsApp deep links |

### For Buyers & Wholesalers 

| Feature | Description |
|---------|-------------|
| **Farm Discovery** | Search and filter farms by district, verification status and delivery availability |
| **Interactive Map View** | OpenStreetMap integration showing farm locations across Melaka |
| **Product Search** | Filter by category (Fresh/Processed), variety, and price range |
| **Price Comparison** | Compare up to 3 products side-by-side across different farms |
| **Price History Analytics** | View 7/14/30/90-day price trends with interactive charts |
| **Distance Calculator** | See distance from current location to farm |
| **Direct Contact** | One-tap WhatsApp, call, or view social media links |

### For LPNM Administrators

> **Note**: Backend infrastructure (models, repositories, security rules) is fully implemented. Web portal UI is planned for Phase 2.

| Feature | Status | Description |
|---------|--------|-------------|
| **Farm Verification** | Backend Ready | Data models and Firestore rules for verification workflow |
| **Audit Log System** | Backend Ready | Immutable records infrastructure for compliance |
| **Announcements** | Backend Ready | Notification system with role/district targeting |
| **Admin Web Portal** | *Coming Soon* | Full management dashboard UI (Phase 2) |


---

## Technology Stack

<table>
<tr>
<td align="center" width="150">

**Frontend**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)

Flutter 3.32.8<br>Dart 3.8.1

</td>
<td align="center" width="150">

**State Management**

![Riverpod](https://img.shields.io/badge/Riverpod-0553B1?style=for-the-badge)

Riverpod 2.0.31<br>Freezed

</td>
<td align="center" width="150">

**Backend**

![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

Firestore<br>Auth • FCM

</td>
<td align="center" width="150">

**Maps**

![OpenStreetMap](https://img.shields.io/badge/OpenStreetMap-7EBC6F?style=for-the-badge&logo=openstreetmap&logoColor=white)

flutter_map<br>Geolocator

</td>
</tr>
<tr>
<td align="center">

**Weather**

![Weather](https://img.shields.io/badge/OpenWeather-EB6E4B?style=for-the-badge)

OpenWeatherMap<br>API

</td>
<td align="center">

**Storage**

![Cloudinary](https://img.shields.io/badge/Cloudinary-3448C5?style=for-the-badge)

Image CDN<br>Optimization

</td>
<td align="center">

**Charts**

![Charts](https://img.shields.io/badge/FL_Chart-FF6384?style=for-the-badge)

Price Trends<br>Analytics

</td>
<td align="center">

**Navigation**

![GoRouter](https://img.shields.io/badge/GoRouter-00B4AB?style=for-the-badge)

Type-safe<br>Routing

</td>
</tr>
</table>

### Full Dependency List

| Category | Libraries |
|----------|-----------|
| **Core** | flutter_riverpod, riverpod_annotation, freezed, json_serializable |
| **Firebase** | firebase_core, cloud_firestore, firebase_auth, firebase_messaging, firebase_analytics |
| **Navigation** | go_router |
| **Maps & Location** | flutter_map, latlong2, geolocator |
| **UI** | google_fonts, shimmer, fl_chart, table_calendar, cached_network_image |
| **Utilities** | intl, url_launcher, connectivity_plus, image_picker |
| **Storage** | hive, hive_flutter, cloudinary_public |


---

## Getting Started

### Prerequisites

- **Flutter SDK** 3.32.8 or higher
- **Dart Version** 3.8.1 or higher
- **Firebase CLI** 14.27.0 or higher
- **DevTools** 2.45.1 or higher
- **Android Studio** or **VS Code** with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MalKim007/nenas-kita.git
   cd nenas_kita
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Riverpod + Freezed)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # For Android/iOS
   flutter run

   # For Web
   flutter run -d chrome
   ```

### Common Commands

```bash
# Install dependencies
flutter pub get

# Generate Freezed/Riverpod code (run after modifying models)
dart run build_runner build --delete-conflicting-outputs

# Run analyzer
flutter analyze

# Run tests
flutter test

# Build Android APK
flutter build apk --release

# Build for web
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

---

## Deployment

### Android APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Web (Firebase Hosting)

```bash
# Build web app
flutter build web

# Deploy to Firebase
firebase deploy --only hosting
```
---
## Acknowledgments

We would like to express our sincere gratitude to:

- **LPNM (Lembaga Perindustrian Nanas Malaysia)** - For the opportunity to contribute to Melaka's pineapple industry digitalization
- **Universiti Teknikal Malaysia Melaka (UTeM)** - For providing the educational platform and resources
- **Course Instructors** - Sir 	Muhammad Huzaifah Bin Ismail for guidance throughout the Software Project Management course
- **Flutter & Firebase Communities** - For excellent documentation and open-source tools
- **Melaka Pineapple Farmers** - For inspiring this solution

---

<p align="center">
  <strong>NenasKita</strong> - Empowering Melaka's Pineapple Farmers Through Technology
  <br>
  <em>Memperkasakan Petani Nanas Melaka Melalui Teknologi</em>
</p>

<p align="center">
  Made with Flutter & Firebase
</p>
