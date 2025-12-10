# NenasKita - Firestore Security Rules
## Comprehensive Security Rules Documentation

---

## 1. Overview

This document provides detailed Firestore security rules for the NenasKita application, implementing role-based access control (RBAC) with field-level security for wholesale pricing.

### 1.1 Security Principles

| Principle | Implementation |
|-----------|----------------|
| Least Privilege | Users only access what they need |
| Defense in Depth | Client + server-side validation |
| Fail Secure | Default deny, explicit allow |
| Audit Trail | All admin actions logged |

### 1.2 Role Hierarchy

```
SuperAdmin (highest)
    ↓
  Admin
    ↓
Wholesaler / Farmer / Buyer (equal level, different permissions)
```

---

## 2. Helper Functions

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ============================================
    // HELPER FUNCTIONS
    // ============================================

    // Check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }

    // Get current user's document
    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }

    // Check user role
    function hasRole(role) {
      return isAuthenticated() && getUserData().role == role;
    }

    // Check if user has any of the specified roles
    function hasAnyRole(roles) {
      return isAuthenticated() && getUserData().role in roles;
    }

    // Check if user is admin or superadmin
    function isAdmin() {
      return hasAnyRole(['admin', 'superadmin']);
    }

    // Check if user is superadmin
    function isSuperAdmin() {
      return hasRole('superadmin');
    }

    // Check if user is a farmer
    function isFarmer() {
      return hasRole('farmer');
    }

    // Check if user is a buyer (regular)
    function isBuyer() {
      return hasRole('buyer');
    }

    // Check if user is a wholesaler
    function isWholesaler() {
      return hasRole('wholesaler');
    }

    // Check if user can view wholesale prices
    function canViewWholesalePrices() {
      return hasAnyRole(['wholesaler', 'admin', 'superadmin']);
    }

    // Check if user owns the document
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Validate required fields exist
    function hasRequiredFields(fields) {
      return request.resource.data.keys().hasAll(fields);
    }

    // Check if only allowed fields are being modified
    function onlyModifies(fields) {
      return request.resource.data.diff(resource.data).affectedKeys().hasOnly(fields);
    }
```

---

## 3. Collection Rules

### 3.1 Users Collection

```javascript
    // ============================================
    // USERS COLLECTION
    // ============================================
    match /users/{userId} {
      // Anyone authenticated can read user profiles
      // Phone numbers are visible to all authenticated users
      allow read: if isAuthenticated();

      // Users can only create their own document
      allow create: if isOwner(userId)
        && hasRequiredFields(['name', 'phone', 'role', 'createdAt'])
        && request.resource.data.role in ['farmer', 'buyer', 'wholesaler']
        && request.resource.data.createdAt == request.time;

      // Users can only update their own document
      // Cannot change role (except by admin)
      allow update: if isOwner(userId)
        && !request.resource.data.diff(resource.data).affectedKeys().hasAny(['role', 'createdAt'])
        && request.resource.data.updatedAt == request.time;

      // Admin can update user role
      allow update: if isAdmin()
        && request.resource.data.updatedAt == request.time;

      // No direct deletion - use soft delete or admin action
      allow delete: if false;
    }
```

**Rationale:**
- Phone numbers visible to all for easy farmer-buyer contact
- Users cannot change their own role (prevents privilege escalation)
- Admin can adjust roles if needed
- No deletion to maintain data integrity

---

### 3.2 Farms Collection

```javascript
    // ============================================
    // FARMS COLLECTION
    // ============================================
    match /farms/{farmId} {
      // Read active farms only (unless admin)
      allow read: if isAuthenticated()
        && (resource.data.isActive == true || isAdmin());

      // Only farmers can create farms
      allow create: if isFarmer()
        && request.resource.data.ownerId == request.auth.uid
        && hasRequiredFields(['ownerId', 'ownerName', 'farmName', 'district', 'isActive', 'createdAt'])
        && request.resource.data.isActive == true
        && request.resource.data.createdAt == request.time;

      // Only owner can update their farm
      allow update: if isOwner(resource.data.ownerId)
        && request.resource.data.ownerId == resource.data.ownerId // Cannot transfer ownership
        && request.resource.data.updatedAt == request.time;

      // Admin can update verification status
      allow update: if isAdmin()
        && onlyModifies(['verifiedByLPNM', 'verifiedAt', 'updatedAt']);

      // Soft delete only (set isActive = false)
      // Hard delete only by superadmin
      allow delete: if isSuperAdmin();

      // ============================================
      // PRODUCTS SUBCOLLECTION
      // ============================================
      match /products/{productId} {
        // Read products - but filter wholesale prices on client side
        // Security rules cannot do field-level read filtering
        // Use Cloud Functions or client-side filtering for wholesale prices
        allow read: if isAuthenticated();

        // Only farm owner can manage products
        allow create: if isOwner(get(/databases/$(database)/documents/farms/$(farmId)).data.ownerId)
          && hasRequiredFields(['name', 'category', 'variety', 'price', 'priceUnit', 'stockStatus'])
          && request.resource.data.updatedAt == request.time;

        allow update: if isOwner(get(/databases/$(database)/documents/farms/$(farmId)).data.ownerId)
          && request.resource.data.updatedAt == request.time;

        allow delete: if isOwner(get(/databases/$(database)/documents/farms/$(farmId)).data.ownerId);
      }
    }
```

**Rationale:**
- Only active farms visible to regular users
- Farmers own their farms permanently (no transfer)
- Admin can only modify verification fields
- Soft delete preferred; hard delete requires SuperAdmin

**Important Note on Wholesale Prices:**
Firestore security rules cannot do field-level read filtering. To hide wholesale prices from regular buyers:

1. **Option A (Recommended):** Store wholesale prices in a separate subcollection:
   ```
   farms/{farmId}/products/{productId}          // Public product data
   farms/{farmId}/wholesalePrices/{productId}   // Wholesale-only data
   ```

2. **Option B:** Use Cloud Functions to filter response data

3. **Option C:** Client-side filtering (less secure, for MVP only)

---

### 3.3 Harvest Plans Collection

```javascript
    // ============================================
    // HARVEST PLANS COLLECTION
    // ============================================
    match /harvestPlans/{planId} {
      // Owner and admins can read full details
      allow read: if isOwner(resource.data.ownerId) || isAdmin();

      // TODO: For aggregate queries (F23 Smart Harvest Calendar),
      // use Cloud Functions to return anonymized/aggregated data
      // Regular users should NOT read individual harvest plans

      // Only farmers can create harvest plans
      allow create: if isFarmer()
        && request.resource.data.ownerId == request.auth.uid
        && hasRequiredFields(['farmId', 'ownerId', 'variety', 'expectedHarvestDate', 'status', 'createdAt'])
        && request.resource.data.createdAt == request.time;

      // Only owner can update their plans
      allow update: if isOwner(resource.data.ownerId)
        && request.resource.data.ownerId == resource.data.ownerId;

      // Only owner can delete their plans
      allow delete: if isOwner(resource.data.ownerId);
    }
```

**Rationale:**
- Harvest plans are sensitive business data
- Aggregate views (for buyers) should use Cloud Functions
- Full details only visible to owner and admin

---

### 3.4 Buyer Requests Collection

```javascript
    // ============================================
    // BUYER REQUESTS COLLECTION
    // ============================================
    match /buyerRequests/{requestId} {
      // All authenticated users can view requests
      allow read: if isAuthenticated();

      // Buyers and wholesalers can create requests
      allow create: if hasAnyRole(['buyer', 'wholesaler'])
        && request.resource.data.buyerId == request.auth.uid
        && hasRequiredFields(['buyerId', 'buyerName', 'category', 'quantityKg', 'status', 'createdAt'])
        && request.resource.data.status == 'open'
        && request.resource.data.createdAt == request.time;

      // Owner can update their request (except status to fulfilled)
      allow update: if isOwner(resource.data.buyerId)
        && request.resource.data.buyerId == resource.data.buyerId
        && !(request.resource.data.status == 'fulfilled' && resource.data.status != 'fulfilled');

      // Farmers can mark requests as fulfilled
      allow update: if isFarmer()
        && resource.data.status == 'open'
        && request.resource.data.status == 'fulfilled'
        && hasRequiredFields(['fulfilledByFarmId', 'fulfilledByFarmName', 'fulfilledAt'])
        && request.resource.data.fulfilledAt == request.time;

      // Owner can delete their request (if still open)
      allow delete: if isOwner(resource.data.buyerId)
        && resource.data.status == 'open';
    }
```

**Rationale:**
- Requests are public to encourage farmer engagement
- Any farmer can fulfill a request (marketplace model)
- Requests can only be deleted when still open

---

### 3.5 Price History Collection

```javascript
    // ============================================
    // PRICE HISTORY COLLECTION
    // ============================================
    match /priceHistory/{historyId} {
      // All authenticated can read (for price trends feature)
      // Wholesale price fields should be filtered client-side
      allow read: if isAuthenticated();

      // Only system/Cloud Functions should write
      // Triggered when product price is updated
      allow create: if false; // Use Cloud Function
      allow update: if false;
      allow delete: if false;
    }
```

**Rationale:**
- Price history auto-generated when prices change
- Use Cloud Function to ensure data integrity
- TTL policy handles automatic cleanup (1 year)

---

### 3.6 Audit Logs Collection

```javascript
    // ============================================
    // AUDIT LOGS COLLECTION
    // ============================================
    match /auditLogs/{logId} {
      // Only admins can read audit logs
      allow read: if isAdmin();

      // Only admins can create audit logs
      allow create: if isAdmin()
        && request.resource.data.adminId == request.auth.uid
        && hasRequiredFields(['adminId', 'adminName', 'action', 'timestamp'])
        && request.resource.data.timestamp == request.time;

      // Audit logs are immutable
      allow update: if false;
      allow delete: if false;
    }
```

**Rationale:**
- Audit logs are sensitive compliance data
- Immutable for legal/audit purposes
- Only admins can view and create

---

### 3.7 Announcements Collection

```javascript
    // ============================================
    // ANNOUNCEMENTS COLLECTION
    // ============================================
    match /announcements/{announcementId} {
      // All authenticated users can read
      // Client filters by targetRoles and expiresAt
      allow read: if isAuthenticated();

      // Only admins can create announcements
      allow create: if isAdmin()
        && hasRequiredFields(['title', 'body', 'type', 'targetRoles', 'createdBy', 'createdAt'])
        && request.resource.data.createdBy == request.auth.uid
        && request.resource.data.createdAt == request.time;

      // Only admins can update
      allow update: if isAdmin();

      // Only admins can delete
      allow delete: if isAdmin();
    }
```

---

### 3.8 App Config Collection

```javascript
    // ============================================
    // APP CONFIG COLLECTION
    // ============================================
    match /appConfig/{configId} {
      // All authenticated users can read config
      allow read: if isAuthenticated();

      // Only superadmin can modify config
      allow write: if isSuperAdmin();
    }

  } // end match /databases/{database}/documents
} // end service cloud.firestore
```

---

## 4. Complete Rules File

Copy this entire block to your `firestore.rules` file:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ============================================
    // HELPER FUNCTIONS
    // ============================================

    function isAuthenticated() {
      return request.auth != null;
    }

    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }

    function hasRole(role) {
      return isAuthenticated() && getUserData().role == role;
    }

    function hasAnyRole(roles) {
      return isAuthenticated() && getUserData().role in roles;
    }

    function isAdmin() {
      return hasAnyRole(['admin', 'superadmin']);
    }

    function isSuperAdmin() {
      return hasRole('superadmin');
    }

    function isFarmer() {
      return hasRole('farmer');
    }

    function isWholesaler() {
      return hasRole('wholesaler');
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    function hasRequiredFields(fields) {
      return request.resource.data.keys().hasAll(fields);
    }

    function onlyModifies(fields) {
      return request.resource.data.diff(resource.data).affectedKeys().hasOnly(fields);
    }

    // ============================================
    // USERS
    // ============================================
    match /users/{userId} {
      allow read: if isAuthenticated();

      allow create: if isOwner(userId)
        && hasRequiredFields(['name', 'phone', 'role', 'createdAt'])
        && request.resource.data.role in ['farmer', 'buyer', 'wholesaler']
        && request.resource.data.createdAt == request.time;

      allow update: if (isOwner(userId)
        && !request.resource.data.diff(resource.data).affectedKeys().hasAny(['role', 'createdAt']))
        || isAdmin();

      allow delete: if false;
    }

    // ============================================
    // FARMS
    // ============================================
    match /farms/{farmId} {
      allow read: if isAuthenticated()
        && (resource.data.isActive == true || isAdmin());

      allow create: if isFarmer()
        && request.resource.data.ownerId == request.auth.uid
        && hasRequiredFields(['ownerId', 'ownerName', 'farmName', 'district', 'isActive', 'createdAt'])
        && request.resource.data.isActive == true;

      allow update: if (isOwner(resource.data.ownerId)
        && request.resource.data.ownerId == resource.data.ownerId)
        || (isAdmin() && onlyModifies(['verifiedByLPNM', 'verifiedAt', 'updatedAt']));

      allow delete: if isSuperAdmin();

      // Products subcollection
      match /products/{productId} {
        allow read: if isAuthenticated();

        allow create, update: if isOwner(
          get(/databases/$(database)/documents/farms/$(farmId)).data.ownerId
        );

        allow delete: if isOwner(
          get(/databases/$(database)/documents/farms/$(farmId)).data.ownerId
        );
      }
    }

    // ============================================
    // HARVEST PLANS
    // ============================================
    match /harvestPlans/{planId} {
      allow read: if isOwner(resource.data.ownerId) || isAdmin();

      allow create: if isFarmer()
        && request.resource.data.ownerId == request.auth.uid;

      allow update: if isOwner(resource.data.ownerId)
        && request.resource.data.ownerId == resource.data.ownerId;

      allow delete: if isOwner(resource.data.ownerId);
    }

    // ============================================
    // BUYER REQUESTS
    // ============================================
    match /buyerRequests/{requestId} {
      allow read: if isAuthenticated();

      allow create: if hasAnyRole(['buyer', 'wholesaler'])
        && request.resource.data.buyerId == request.auth.uid
        && request.resource.data.status == 'open';

      allow update: if (isOwner(resource.data.buyerId)
        && request.resource.data.buyerId == resource.data.buyerId)
        || (isFarmer()
            && resource.data.status == 'open'
            && request.resource.data.status == 'fulfilled');

      allow delete: if isOwner(resource.data.buyerId)
        && resource.data.status == 'open';
    }

    // ============================================
    // PRICE HISTORY
    // ============================================
    match /priceHistory/{historyId} {
      allow read: if isAuthenticated();
      allow write: if false; // Cloud Function only
    }

    // ============================================
    // AUDIT LOGS
    // ============================================
    match /auditLogs/{logId} {
      allow read: if isAdmin();
      allow create: if isAdmin()
        && request.resource.data.adminId == request.auth.uid;
      allow update, delete: if false;
    }

    // ============================================
    // ANNOUNCEMENTS
    // ============================================
    match /announcements/{announcementId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin()
        && request.resource.data.createdBy == request.auth.uid;
      allow update, delete: if isAdmin();
    }

    // ============================================
    // APP CONFIG
    // ============================================
    match /appConfig/{configId} {
      allow read: if isAuthenticated();
      allow write: if isSuperAdmin();
    }
  }
}
```

---

## 5. Handling Wholesale Price Security

Since Firestore cannot do field-level read filtering, here are implementation options:

### Option A: Separate Collection (Recommended)

```
farms/{farmId}/products/{productId}
  - name, category, variety, price, priceUnit, stockStatus, images

farms/{farmId}/wholesalePrices/{productId}
  - wholesalePrice, wholesaleMinQty

// Security rule for wholesalePrices
match /farms/{farmId}/wholesalePrices/{productId} {
  allow read: if isOwner(get(/databases/$(database)/documents/farms/$(farmId)).data.ownerId)
    || isWholesaler()
    || isAdmin();
  allow write: if isOwner(get(/databases/$(database)/documents/farms/$(farmId)).data.ownerId);
}
```

### Option B: Cloud Function Filter

```javascript
// Cloud Function: getProducts
exports.getProducts = functions.https.onCall(async (data, context) => {
  const userRole = await getUserRole(context.auth.uid);
  const products = await getProductsFromFirestore(data.farmId);

  if (!['wholesaler', 'admin', 'superadmin'].includes(userRole)) {
    // Remove wholesale fields for regular buyers
    products.forEach(p => {
      delete p.wholesalePrice;
      delete p.wholesaleMinQty;
    });
  }

  return products;
});
```

---

## 6. Common Attack Scenarios & Prevention

| Attack | Prevention |
|--------|------------|
| Privilege escalation (change own role) | Users cannot modify `role` field |
| Data theft (read all users) | Allowed - phone visibility is by design |
| Unauthorized farm creation | Only `farmer` role can create |
| Farm takeover | `ownerId` cannot be changed |
| Delete competitor's farm | Only owner can soft-delete, SuperAdmin for hard delete |
| View competitor's harvest plans | Only owner and admin can read |
| Fake fulfillment | Only farmers can fulfill requests |
| Audit log tampering | Logs are immutable (no update/delete) |
| Price manipulation | Price history written by Cloud Function only |

---

## 7. Testing Security Rules

### 7.1 Firebase Emulator Testing

```javascript
// test/security-rules.test.js
const { assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');

describe('Farms Collection', () => {
  it('allows farmer to create farm', async () => {
    const farmerDb = getFirestore({ uid: 'farmer1', role: 'farmer' });
    await assertSucceeds(farmerDb.collection('farms').add({
      ownerId: 'farmer1',
      ownerName: 'Test Farmer',
      farmName: 'Test Farm',
      district: 'Jasin',
      isActive: true,
      createdAt: firebase.firestore.FieldValue.serverTimestamp()
    }));
  });

  it('denies buyer from creating farm', async () => {
    const buyerDb = getFirestore({ uid: 'buyer1', role: 'buyer' });
    await assertFails(buyerDb.collection('farms').add({
      ownerId: 'buyer1',
      farmName: 'Fake Farm'
    }));
  });

  it('hides inactive farms from regular users', async () => {
    const buyerDb = getFirestore({ uid: 'buyer1', role: 'buyer' });
    await assertFails(
      buyerDb.collection('farms')
        .where('isActive', '==', false)
        .get()
    );
  });
});
```

### 7.2 Manual Testing Checklist

- [ ] Farmer can create farm
- [ ] Farmer cannot create second farm (if enforced)
- [ ] Buyer cannot create farm
- [ ] Farmer can update own farm
- [ ] Farmer cannot update other's farm
- [ ] Buyer can view active farms
- [ ] Buyer cannot view inactive farms
- [ ] Admin can view all farms
- [ ] Wholesaler can see wholesale prices
- [ ] Regular buyer cannot see wholesale prices
- [ ] Farmer can fulfill buyer request
- [ ] Buyer cannot fulfill request
- [ ] Admin can create audit log
- [ ] Non-admin cannot read audit logs

---

## 8. Deployment

```bash
# Deploy rules only
firebase deploy --only firestore:rules

# Deploy with indexes
firebase deploy --only firestore

# Test locally first
firebase emulators:start --only firestore
```

---

*Document Version: 1.0*
*Last Updated: December 2024*
*Project: NenasKita - LPNM Melaka Pineapple Digitalization*
