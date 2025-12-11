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

---

## About

**NenasKita** is a mobile application developed to digitalize the pineapple farming industry in Melaka, Malaysia. Built in collaboration with **LPNM (Lembaga Perindustrian Nanas Malaysia)**, this platform connects farmers, buyers and wholesalers in a unified digital ecosystem.

## Key Features

### For Farmers / Entrepreneurs
- **Business Profile Management** - Farm registration with LPNM license & location
- **Product Catalog** - List fresh and processed products with pricing
- **Harvest Planner** - Calendar-based planning with status tracking
- **WhatsApp Integration** - Direct buyer communication

### For Buyers & Wholesalers
- **Farm Discovery** - Search farms by district, verification status
- **Interactive Map** - OpenStreetMap showing farm locations
- **Price Comparison** - Compare products across different farms
- **Price History** - View price trends with interactive charts

## Tech Stack

| Category | Technologies |
|----------|-------------|
| **Frontend** | Flutter 3.32.8, Dart 3.8.1 |
| **State** | Riverpod, Freezed |
| **Backend** | Firebase (Firestore, Auth, FCM) |
| **Maps** | OpenStreetMap (flutter_map) |
| **Storage** | Cloudinary CDN |

## Quick Start

```bash
# Clone
git clone https://github.com/MalKim007/nenas-kita.git
cd nenas_kita

# Install dependencies
flutter pub get

# Generate code (Riverpod + Freezed)
dart run build_runner build --delete-conflicting-outputs

# Run
flutter run
```

## Documentation

For detailed documentation, see our [Wiki](https://github.com/MalKim007/nenas-kita/wiki):

- [Architecture](https://github.com/MalKim007/nenas-kita/wiki/Architecture)
- [Project Structure](https://github.com/MalKim007/nenas-kita/wiki/Project-Structure)
- [Database Schema](https://github.com/MalKim007/nenas-kita/wiki/Database-Schema)
- [API Integrations](https://github.com/MalKim007/nenas-kita/wiki/API-Integrations)
- [Roadmap](https://github.com/MalKim007/nenas-kita/wiki/Roadmap)

---

## Team

| Name | Role |
|------|------|
| **Muhammad Akmal Hakim Hishamuddin** (B032310162) | Project Manager & System Analyst |
| **Muhammad Arif Aiman Bin Karim** (B032310257) | Backend Developer |
| **Nur Aqilah Binti Zaidi** (B032310148) | Frontend Developer |
| **Nur Aina Sofea Binti Ahmad Nazzib** (B032310108) | Database Designer |
| **Siti Balqis Binti Mat Muharam** (B032310135) | Software Testing & Deployment |

**Course**: Software Project Management (SULAM) 2025
**Institution**: Universiti Teknikal Malaysia Melaka (UTeM)

---

## Acknowledgments

- **LPNM** - For the opportunity to contribute to Melaka's pineapple industry
- **UTeM** - For providing the educational platform
- **Sir Muhammad Huzaifah Bin Ismail** - Course instructor guidance

---

## Contact

- **Email**: mkim8189@gmail.com
- **Phone**: 011-72731088

---

<p align="center">
  <strong>NenasKita</strong> - Empowering Melaka's Pineapple Farmers Through Technology
  <br>
  <em>Made with Flutter & Firebase</em>
</p>
