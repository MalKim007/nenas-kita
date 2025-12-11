## Database Schema

### Firestore Collections

```
firestore/
├── users/                      # User profiles
│   └── {userId}
│       ├── name, email, phone
│       ├── role (farmer|buyer|wholesaler|admin)
│       ├── district
│       └── isVerified
│
├── farms/                      # Farm registrations
│   └── {farmId}
│       ├── ownerId, ownerName, ownerPhone
│       ├── name, description
│       ├── location (GeoPoint)
│       ├── district
│       ├── licenseNumber, licenseExpiry
│       ├── varieties[] (Morris, Josapine, etc.)
│       ├── hasDelivery
│       ├── isVerified, verifiedAt, verifiedBy
│       └── socialLinks (whatsapp, facebook, instagram)
│
├── farms/{farmId}/products/    # Products (subcollection)
│   └── {productId}
│       ├── name, description
│       ├── category (fresh|processed)
│       ├── variety
│       ├── retailPrice, priceUnit
│       ├── wholesalePrice, minWholesaleQty
│       ├── stockStatus (available|limited|out)
│       └── images[]
│
├── harvestPlans/               # Harvest planning
│   └── {planId}
│       ├── farmId, farmName
│       ├── variety
│       ├── quantity
│       ├── plantingDate
│       ├── expectedHarvestDate
│       ├── actualHarvestDate
│       └── status (planned|growing|ready|harvested)
│
├── priceHistory/               # Price change tracking
├── buyerRequests/              # Buyer purchase requests
├── auditLogs/                  # LPNM verification actions (immutable)
├── announcements/              # System announcements
└── appConfig/                  # App-wide settings
```

### Data Models (Freezed)

All models use **Freezed** for immutability and include `fromFirestore()` / `toFirestore()` converters:

- `UserModel` - User profile with role
- `FarmModel` - Farm registration with location
- `ProductModel` - Product with pricing
- `HarvestPlanModel` - Harvest schedule
- `AuditLogModel` - Verification records
- `AnnouncementModel` - Admin notifications
