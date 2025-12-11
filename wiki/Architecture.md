
## Architecture

### Feature-First Modular Design

NenasKita follows a **feature-first architecture** that promotes code organization, maintainability, and team scalability:

```
┌────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                      │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐            │
│  │ Screens │  │ Widgets │  │  Shell  │  │ Routing │            │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘            │
└───────┼────────────┼────────────┼────────────┼─────────────────┘
        │            │            │            │
┌───────┴────────────┴────────────┴────────────┴─────────────────┐
│                         STATE LAYER                            │
│         ┌──────────────────────────────────────┐               │
│         │      RIVERPOD PROVIDERS              │               │
│         │  (Generated with @riverpod)          │               │
│         └──────────────────────────────────────┘               │
└────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────┴──────────────────────────────────┐
│                         DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ Repositories│  │   Models    │  │  Services   │             │
│  │  (Firestore)│  │  (Freezed)  │  │ (APIs/Auth) │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────┴──────────────────────────────────┐
│                       EXTERNAL SERVICES                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │ Firebase │  │ Weather  │  │Cloudinary│  │   Maps   │        │
│  │Firestore │  │   API    │  │   CDN    │  │   OSM    │        │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘        │
└────────────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

| Decision | Rationale |
|----------|-----------|
| **Offline-First** | Firestore persistence ensures app works in rural areas with poor connectivity |
| **Code Generation** | Riverpod + Freezed reduce boilerplate and catch errors at compile time |
| **Feature Modules** | Each feature is self-contained with its own models, providers, repos, and screens |
| **Repository Pattern** | Abstracts Firestore operations for testability and consistency |
| **Role-Based UI** | StatefulShellRoute provides role-specific bottom navigation |


## User Journey

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
