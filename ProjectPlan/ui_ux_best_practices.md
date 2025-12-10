# NenasKita - UI/UX Best Practices Guide
## Tailored Design Guidelines for Agricultural Mobile App

---

## 1. Design Philosophy
The design must be clean and modern looking!
### 1.1 Core Principles

| Principle | Application |
|-----------|-------------|
| **Simplicity First** | Rural farmers may have limited tech experience |
| **Thumb-Friendly** | One-handed mobile operation in field conditions |
| **Offline-Aware** | Visual feedback for sync status |
| **Trust Building** | Clear verification badges and credibility indicators |
| **Culturally Relevant** | Malaysian/Melaka context in imagery |

### 1.2 Design Goals

```
┌─────────────────────────────────────────────────────────┐
│                    USER EXPERIENCE GOALS                 │
├─────────────────────────────────────────────────────────┤
│  Task Completion < 3 taps for common actions            │
│  Learning Curve < 5 minutes for core features           │
│  Error Prevention over error handling                   │
│  Confidence in data accuracy and freshness              │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Material Design 3 Implementation

### 2.1 Color System (Amber Theme)

```dart
// Primary Palette - Amber/Gold (Pineapple-inspired)
Primary: #D97706 (Amber 600 - better contrast than 500)
OnPrimary: #FFFFFF
PrimaryContainer: #FEF3C7 (Amber 100)
OnPrimaryContainer: #78350F (Amber 900)

// Secondary Palette - Green (Agricultural)
Secondary: #16A34A (Green 600 - better contrast)
OnSecondary: #FFFFFF
SecondaryContainer: #DCFCE7 (Green 100)
OnSecondaryContainer: #14532D (Green 900)

// Semantic Colors (with required icons - never rely on color alone!)
Success: #16A34A + ✓ icon (Verified, Available)
Warning: #D97706 + ◐ icon (Limited Stock, Pending)
Error: #DC2626 + ✗ icon (Out of Stock, Rejected)
Info: #2563EB + ℹ icon (Announcements)

// Surface Colors (optimized for outdoor/sunlight visibility)
Background: #FFFFFF (pure white - best contrast for outdoor use)
Surface: #FFFFFF
SurfaceVariant: #FEF3C7 (warm white - use for cards/containers only)
Outline: #D1D5DB (borders)
```

**Accessibility Notes:**
- Pure white background ensures readability in bright sunlight (for farmers in fields)
- Amber 600 instead of 500 improves contrast ratio to meet WCAG AA (4.5:1)
- All status indicators MUST include icons (8% of males are red-green colorblind)
- Warm white (#FEF3C7) reserved for card backgrounds only, not page background

### 2.2 Typography Scale

| Style | Size | Weight | Use Case |
|-------|------|--------|----------|
| Display Large | 57sp | 400 | Splash screen title |
| Headline Large | 32sp | 400 | Page titles |
| Headline Medium | 28sp | 400 | Section headers |
| Title Large | 22sp | 500 | Card titles, Farm names |
| Title Medium | 16sp | 500 | Product names |
| Body Large | 16sp | 400 | Primary content |
| Body Medium | 14sp | 400 | Secondary content |
| Label Large | 14sp | 500 | Buttons, Chips |
| Label Small | 11sp | 500 | Timestamps, Badges |

**Recommendation**: Use minimum 14sp for body text (accessibility for older farmers)

### 2.3 Spacing System

```
Base unit: 4dp

XS:  4dp  (icon padding)
S:   8dp  (inline spacing)
M:  16dp  (component padding)
L:  24dp  (section spacing)
XL: 32dp  (page margins)
XXL: 48dp (major sections)
```

---

## 3. User-Specific Design Guidelines

### 3.1 Farmer Interface

**User Profile**: Ages 30-60, varying tech literacy, using app in outdoor/field conditions

| Guideline | Implementation |
|-----------|----------------|
| Large touch targets | Minimum 48x48dp, prefer 56x56dp |
| High contrast | Dark text on light backgrounds |
| Clear CTAs | Single primary action per screen |
| Visual feedback | Loading states, success confirmations |
| Forgiving inputs | Auto-format phone numbers, flexible date entry |

**Key Screens Design**:

```
┌─────────────────────────────────────┐
│  FARMER DASHBOARD                   │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ Weather Widget              │   │  <- Prominent, glanceable
│  │ 28°C | Partly Cloudy        │   │
│  │ Rain: 20% | Humidity: 75%   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌──────────┐  ┌──────────┐        │
│  │ Products │  │ Harvest  │        │  <- Large icon buttons
│  │    12    │  │ Planner  │        │
│  └──────────┘  └──────────┘        │
│                                     │
│  LPNM Announcement                 │  <- Notification banner
│  New subsidy available...          │
│                                     │
│  UPCOMING HARVESTS                 │
│  - Morris (Plot A) - 7 days        │  <- Countdown format
│  - Josapine (Plot B) - 14 days     │
└─────────────────────────────────────┘
```

### 3.2 Buyer Interface

**User Profile**: Business-oriented, comparing options, time-sensitive

| Guideline | Implementation |
|-----------|----------------|
| Scannable lists | Key info visible without expansion |
| Filter-first | Prominent search and filter controls |
| Quick actions | WhatsApp button always accessible |
| Comparison support | Consistent card layouts |
| Location awareness | Distance/district prominently shown |

**Farm Discovery Card**:

```
┌─────────────────────────────────────────┐
│ [Farm Image]                            │
│                                         │
│ Pak Ali Pineapple Farm       Verified   │
│ Jasin - 12km away                       │
│                                         │
│ Morris, Josapine, MD2                   │
│ Stock: Available                        │
│                                         │
│ RM 2.50 - RM 4.00 /kg                   │
│                                         │
│ [WhatsApp]  [View Details]              │
└─────────────────────────────────────────┘
```

### 3.3 Admin Interface (Web Portal)

**User Profile**: LPNM staff, data-driven, multi-tasking

| Guideline | Implementation |
|-----------|----------------|
| Dense information | Tables, dashboards, bulk actions |
| Keyboard navigation | Shortcuts for common tasks |
| Status visibility | Clear verification queues |
| Audit trail | Action history always accessible |
| Responsive | Works on tablet for field inspections |

---

## 4. Component Design Patterns

### 4.1 Cards

**Farm Card** (Discovery List):
- Image: 16:9 aspect ratio, placeholder for missing
- Badge: Verification status top-right
- Title: Farm name (max 2 lines, ellipsis)
- Metadata: District, varieties, stock status
- Actions: WhatsApp CTA, View details

**Product Card**:
- Image: 1:1 square, multiple image indicator
- Price: Prominent, with unit
- Stock indicator: Color-coded chip
- Last updated: Relative timestamp

### 4.2 Forms

**Best Practices**:

```
┌─────────────────────────────────────┐
│ Add Product                         │
├─────────────────────────────────────┤
│                                     │
│ Product Name *                      │
│ ┌─────────────────────────────────┐│
│ │ Fresh Morris Pineapple          ││  <- Floating label
│ └─────────────────────────────────┘│
│                                     │
│ Category *                          │
│ ┌─────────────────────────────────┐│
│ │ Fresh       │ Processed         ││  <- Segmented buttons
│ └─────────────────────────────────┘│     (not dropdown)
│                                     │
│ Price (RM) *         Unit *         │
│ ┌─────────────┐  ┌───────────────┐ │
│ │ 3.50        │  │ per kg        │ │
│ └─────────────┘  └───────────────┘ │
│                                     │
│ Stock Status *                      │
│ O Available  O Limited  O Out      │  <- Radio chips
│                                     │
│ [Cancel]              [Save Product]│
└─────────────────────────────────────┘
```

**Form Guidelines**:
- Group related fields
- Show required fields with asterisk (*)
- Inline validation with helpful messages
- Auto-save drafts for long forms
- Confirmation before destructive actions

### 4.3 Navigation

**Bottom Navigation** (Mobile):

```
┌─────────────────────────────────────┐
│  Home    Discover  Products  Settings│
└─────────────────────────────────────┘
```

- Maximum 5 items
- Active state: Filled icon + label
- Badge for notifications
- Consistent across user roles (with role-specific items)

**Navigation Rail** (Web Admin):
- Expanded sidebar on desktop
- Collapsible on tablet
- Icon + label always visible

### 4.4 Status Indicators

> **Important:** Always use icon + color + label together. Never rely on color alone (colorblind accessibility).

| Status | Color | Icon | Label | Hex |
|--------|-------|------|-------|-----|
| Verified | Green | ✓ | LPNM Verified | #16A34A |
| Pending | Amber | ⏳ | Pending Verification | #D97706 |
| Rejected | Red | ✗ | Rejected | #DC2626 |
| Available | Green | ✓ | Available | #16A34A |
| Limited | Amber | ◐ | Limited Stock | #D97706 |
| Out of Stock | Red | ✗ | Out of Stock | #DC2626 |
| Online | Green | ● | Online | #16A34A |
| Offline | Gray | ○ | Offline | #6B7280 |

**Implementation Example:**
```dart
// Always combine icon + color + text
Row(
  children: [
    Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 16),
    SizedBox(width: 4),
    Text('Available', style: TextStyle(color: Color(0xFF16A34A))),
  ],
)
```

### 4.5 Interaction Consistency

**Actionable Elements Must Look Actionable:**

| Element | Visual Cues |
|---------|-------------|
| Buttons | Filled/outlined, rounded corners, elevation on press |
| Text Links | Primary color, underline on hover (web) |
| Input Fields | Border, placeholder text, focus ring |
| Tappable Cards | Subtle shadow/elevation, ripple effect on tap |
| Icons (actionable) | Wrapped in IconButton with splash |

**Element States:**

| State | Appearance | Example |
|-------|------------|---------|
| Default | Normal colors | Button ready to tap |
| Hover | Slight brightness change | Web only |
| Pressed | Scale down 0.95, darker shade | Tap feedback |
| Focused | 2dp outline ring (primary color) | Keyboard/accessibility |
| Disabled | 50% opacity, no interaction | Greyed out button |
| Loading | Spinner replaces content, disabled | "Saving..." |

**Implementation Example:**
```dart
// Disabled button
ElevatedButton(
  onPressed: isLoading ? null : _onSubmit,
  child: isLoading
    ? SizedBox(
        width: 20, height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
    : Text('Save'),
)

// Tappable card with feedback
InkWell(
  onTap: () => _openFarmDetail(farm),
  borderRadius: BorderRadius.circular(12),
  child: FarmCard(farm: farm),
)
```

**Consistency Rules:**
- All primary actions use `ElevatedButton` with primary color
- All secondary actions use `OutlinedButton`
- All destructive actions use red color
- All tappable cards use `InkWell` wrapper
- All disabled elements show 50% opacity

---

## 5. Interaction Patterns

### 5.1 Loading States

**Skeleton Loading** (Preferred):
```
┌─────────────────────────────────────┐
│ ████████████████████                │  <- Shimmer animation
│ ████████  ████                      │
│ ██████████████████                  │
└─────────────────────────────────────┘
```

**Pull to Refresh**:
- Show last updated timestamp
- Subtle haptic feedback
- "Updated just now" confirmation

### 5.2 Empty States

```
┌─────────────────────────────────────┐
│                                     │
│          [Pineapple Icon]           │
│                                     │
│       No products yet               │
│                                     │
│    Add your first product to        │
│    start selling                    │
│                                     │
│       [+ Add Product]               │
│                                     │
└─────────────────────────────────────┘
```

**Guidelines**:
- Friendly illustration (not error-like)
- Clear messaging
- Clear action button
- Context-specific messaging

### 5.3 Error Handling

**Toast Messages** (Non-blocking):
- Success: Green, auto-dismiss 3s
- Error: Red, requires dismiss
- Info: Blue, auto-dismiss 4s

**Error States**:
```
┌─────────────────────────────────────┐
│  Unable to load data                │
│                                     │
│  Please check your internet         │
│  connection and try again           │
│                                     │
│           [Retry]                   │
└─────────────────────────────────────┘
```

### 5.4 Offline Mode UI

```
┌─────────────────────────────────────┐
│ Offline Mode                        │  <- Persistent banner
│ Changes will sync when connected    │
└─────────────────────────────────────┘
```

**Offline Indicators**:
- Persistent top banner when offline
- Grayed sync icon in app bar
- "Pending sync" badges on modified items
- Disable actions requiring network (e.g., image upload)

---

## 6. Accessibility Guidelines

### 6.1 Visual Accessibility

| Requirement | Implementation |
|-------------|----------------|
| Color contrast | Minimum 4.5:1 for text |
| Don't rely on color alone | Use icons + labels |
| Scalable text | Support system font scaling |
| Touch targets | Minimum 48x48dp |
| Focus indicators | Visible focus rings |

### 6.2 Screen Reader Support

```dart
// Example: Semantic labels
Semantics(
  label: 'Farm verified by LPNM',
  child: Icon(Icons.verified, color: Colors.green),
)

// Example: Button accessibility
ElevatedButton(
  onPressed: _contactFarmer,
  child: Text('WhatsApp'),
  semanticsLabel: 'Contact farmer via WhatsApp',
)
```

### 6.3 Considerations for Rural Users

- **Low bandwidth**: Compress images, lazy load
- **Older devices**: Test on low-end Android
- **Bright sunlight**: High contrast mode option
- **Limited literacy**: Icon-first design where possible

---

## 7. Image Guidelines

### 7.1 Photo Requirements

| Type | Aspect Ratio | Min Resolution | Max Size |
|------|--------------|----------------|----------|
| Farm cover | 16:9 | 1280x720 | 2MB |
| Product photo | 1:1 | 800x800 | 1MB |
| Profile avatar | 1:1 | 200x200 | 500KB |

### 7.2 Image Placeholders

```
┌─────────────────────────────────────┐
│                                     │
│       [Pineapple Icon]              │
│                                     │
│         No image                    │
│                                     │
└─────────────────────────────────────┘
```

- Use pineapple-themed placeholder
- Consistent brand colors
- Subtle, not distracting

### 7.3 Image Upload UX

1. Show upload progress with percentage
2. Allow multiple selection
3. Preview before confirming
4. Option to crop/rotate
5. Compress automatically
6. Retry failed uploads
7. Queue for offline sync

---

## 8. Map Integration UX

### 8.1 Farm Location Display

```
┌─────────────────────────────────────┐
│                                     │
│    Farm markers (clustered)         │
│                                     │
│  [Map View]                         │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Your location               │   │
│  │ O 5km  O 10km  O 20km       │   │  <- Radius filter
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 8.2 Location Picker (Farm Registration)

1. Start with user's current location
2. Allow map drag to adjust
3. Search by address
4. Confirm with reverse geocoding
5. Show district auto-detected
6. Save offline for later sync

---

## 9. WhatsApp Integration UX

### 9.1 Button Placement

- **Always visible** on farm detail and product detail
- **Floating action button** style preferred
- Green color (#25D366) for brand recognition

### 9.2 Pre-filled Message Template

```
Hi, I'm interested in {product_name} from {farm_name}.
Is stock still available?

---
Sent via NenasKita App
```

### 9.3 Click Flow

1. User taps WhatsApp button
2. Show confirmation: "Open WhatsApp?" with contact info
3. Open WhatsApp with pre-filled message
4. Log analytics event

---

## 10. Performance UX

### 10.1 Perceived Performance

| Technique | Application |
|-----------|-------------|
| Skeleton screens | List loading |
| Optimistic updates | Like, save actions |
| Progressive loading | Image galleries |
| Infinite scroll | Farm discovery list |
| Background sync | Price updates |

### 10.2 Data Freshness Indicators

```
Price updated: 2 hours ago
```

- Show relative timestamps
- Highlight stale data (>24h old)
- Auto-refresh on foreground

---

## 11. Onboarding Flow

### 11.1 First-Time User Experience

```
Step 1: Welcome
┌─────────────────────────────────────┐
│      [Pineapple Logo]               │
│        NenasKita                    │
│                                     │
│  Digital platform for Melaka's      │
│  pineapple industry                 │
│                                     │
│         [Get Started]               │
└─────────────────────────────────────┘

Step 2: Phone Verification
┌─────────────────────────────────────┐
│  Phone Number                       │
│  ┌─────────────────────────────┐   │
│  │ +60 │ 12-345 6789           │   │
│  └─────────────────────────────┘   │
│                                     │
│  We will send you an OTP code       │
│                                     │
│           [Send Code]               │
└─────────────────────────────────────┘

Step 3: Role Selection
┌─────────────────────────────────────┐
│  I am a...                          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Farmer                      │   │
│  │ I grow and sell pineapples  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Buyer                       │   │
│  │ I'm looking to purchase     │   │
│  │ pineapples                  │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘

Step 4: Profile Setup (contextual to role)
```

### 11.2 Feature Discovery

- **Coach marks** for key features on first visit
- **Tooltip hints** for complex actions
- **Progress indicator** for profile completion
- **Contextual help** buttons (?) where needed

---

## 12. Animation Guidelines

### 12.1 Motion Principles

| Principle | Application |
|-----------|-------------|
| Purposeful | Animations convey meaning |
| Quick | 200-300ms for most transitions |
| Natural | Ease-out for entering, ease-in for exiting |
| Subtle | Don't distract from content |

### 12.2 Recommended Animations

| Interaction | Animation |
|-------------|-----------|
| Page transition | Slide + fade (300ms) |
| List item appear | Stagger fade-in (50ms delay) |
| Button press | Scale down 0.95 (100ms) |
| Card expand | Shared element transition |
| Pull to refresh | Bouncy spring |
| Success action | Checkmark draw animation |

### 12.3 Reduce Motion

- Respect system "reduce motion" setting
- Provide instant transitions as fallback
- Never auto-play video without user consent

---

## 13. Language & Localization

### 13.1 English Only

The app uses **English** exclusively. No language toggle required.

**Text Guidelines:**
- Use simple, clear English (avoid jargon)
- Keep sentences short for readability
- Use familiar terms for farmers (e.g., "farm" not "agricultural establishment")

**Standard UI Labels:**
| Element | Label |
|---------|-------|
| Navigation | Home, Search, Settings, Profile |
| Actions | Add, Edit, Delete, Save, Cancel, Submit |
| Status | Loading..., Retry, Available, Limited Stock, Out of Stock |
| Verification | Verified, Pending, Rejected |
| Products | Products, Farms, Harvest Plans |

---

## 14. Malaysian Input Formatting

### 14.1 Phone Number (+60)

```dart
// Format: +60 12-345 6789
// Validation: 9-10 digits after country code

TextField(
  decoration: InputDecoration(
    prefixText: '+60 ',
    hintText: '12-345 6789',
    labelText: 'Phone Number',
  ),
  keyboardType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
    // Custom formatter for XX-XXX XXXX pattern
  ],
)
```

**Validation Rules:**
- Must start with valid prefix (10, 11, 12, 13, 14, 16, 17, 18, 19)
- Length: 9-10 digits (excluding +60)
- Display format: +60 12-345 6789

### 14.2 Currency (RM)

```dart
// Format: RM 3.50
// Always show 2 decimal places

Text('RM ${price.toStringAsFixed(2)}')

// Input field for price
TextField(
  decoration: InputDecoration(
    prefixText: 'RM ',
    hintText: '0.00',
    labelText: 'Price',
  ),
  keyboardType: TextInputType.numberWithOptions(decimal: true),
)
```

**Display Rules:**
- Prefix: "RM " (with space)
- Decimal: Always 2 places (RM 3.00, not RM 3)
- Thousands separator: Optional (RM 1,000.00 or RM 1000.00)
- Price range: "RM 2.50 - RM 4.00"

### 14.3 Date & Time

```dart
// Date format: DD/MM/YYYY (Malaysian standard)
// Example: 25/12/2024

DateFormat('dd/MM/yyyy').format(date)

// Relative dates (for timestamps)
// "Just now"
// "5 minutes ago"
// "2 hours ago"
// "Yesterday"
// "25 Dec 2024" (Older dates)
```

**Date Picker Guidelines:**
- Use Material date picker
- Start week on Monday
- Show English month names (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)

### 14.4 Quantity (Weight)

```dart
// Format: XX kg or XX.X kg
TextField(
  decoration: InputDecoration(
    suffixText: 'kg',
    hintText: '0',
    labelText: 'Quantity',
  ),
  keyboardType: TextInputType.number,
)
```

---

## 15. Search UX

### 15.1 Farm Discovery Search

```
┌─────────────────────────────────────┐
│ 🔍 Search farms or products...      │  <- Persistent search bar
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ RECENT SEARCHES                     │  <- Recent searches
│ • Morris Jasin                      │
│ • Pak Ali Farm                      │
│                                     │
│ SUGGESTIONS                         │  <- Suggestions
│ • Morris    • Josapine    • MD2     │
└─────────────────────────────────────┘
```

### 15.2 Search Behavior

| State | Behavior |
|-------|----------|
| Empty | Show recent searches + popular suggestions |
| Typing | Live filter (debounce 300ms) |
| No Results | Show "No results found" + suggest filters |
| Results | Show count "12 farms found" |

### 15.3 Filter Bottom Sheet

```
┌─────────────────────────────────────┐
│ FILTER                         [X]  │
├─────────────────────────────────────┤
│ District                            │
│ ○ All  ● Jasin  ○ Alor Gajah       │
│        ○ Melaka Tengah              │
│                                     │
│ Pineapple Variety                   │
│ [Morris] [Josapine] [MD2]           │
│                                     │
│ Stock Status                        │
│ ☑ Available  ☑ Limited  ☐ Out      │
│                                     │
│ [Reset]                [Apply]      │
└─────────────────────────────────────┘
```

---

## 16. Confirmation & Success States

### 16.1 Confirmation Dialogs

**When to Show:**
- Deleting items (products, harvest plans)
- Price changes
- Logout
- Destructive actions

**Dialog Pattern:**
```
┌─────────────────────────────────────┐
│ Delete Product?                     │
│                                     │
│ "Fresh Morris Pineapple" will be    │
│ deleted. This action cannot be      │
│ undone.                             │
│                                     │
│         [Cancel]    [Delete]        │
└─────────────────────────────────────┘
```

**Button Colors:**
- Destructive action: Red background
- Cancel: Text button (no background)

### 16.2 Success States

**Toast/Snackbar Messages:**
```dart
// Success - Green, auto-dismiss 3s
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Product added successfully'),
    backgroundColor: Color(0xFF16A34A),
    duration: Duration(seconds: 3),
  ),
);
```

**Success Animation (after form submit):**
```
┌─────────────────────────────────────┐
│                                     │
│            ✓                        │  <- Animated checkmark
│                                     │
│     Saved Successfully!             │
│                                     │
│  (auto-navigate back after 1.5s)    │
└─────────────────────────────────────┘
```

### 16.3 Common Messages

| Action | Success Message | Error Message |
|--------|-----------------|---------------|
| Save | Saved successfully | Failed to save |
| Delete | Deleted successfully | Failed to delete |
| Update | Updated successfully | Failed to update |
| Upload | Uploaded successfully | Failed to upload |
| Send | Sent successfully | Failed to send |
| Login | Welcome! | Invalid OTP code |
| Network | - | No internet connection |

---

## 17. Design Checklist

### 17.1 Pre-Development Review

- [ ] Colors meet contrast requirements (4.5:1)
- [ ] Touch targets minimum 48x48dp
- [ ] Typography scale applied consistently
- [ ] Spacing uses 4dp grid
- [ ] Empty states designed
- [ ] Error states designed
- [ ] Loading states designed
- [ ] Offline states designed
- [ ] All text in English

### 17.2 Pre-Release Review

- [ ] Tested on low-end Android device
- [ ] Tested with system font scaling (up to 200%)
- [ ] Tested with screen reader
- [ ] Tested in bright light conditions
- [ ] Tested offline flow end-to-end
- [ ] Images have alt text
- [ ] Analytics events tracked
- [ ] All English text reviewed for spelling/grammar

---

## 18. Design Resources

### 18.1 Recommended Tools

| Tool | Purpose |
|------|---------|
| Figma | UI design, prototyping |
| Material Theme Builder | Color system generation |
| Google Fonts | Typography (Roboto) |
| Unsplash | Stock photos (pineapple, farming) |
| Lucide Icons | Consistent iconography |

### 18.2 Reference Links

- [Material Design 3 Guidelines](https://m3.material.io/)
- [Flutter Material Components](https://docs.flutter.dev/ui/widgets/material)
- [Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

---

*Document Version: 1.3*
*Last Updated: December 2024*
*Project: NenasKita - LPNM Melaka Pineapple Digitalization*

**Version History:**
| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Dec 2024 | Initial UI/UX guidelines |
| 1.1 | Dec 2024 | Improved color system for outdoor visibility & colorblind accessibility |
| 1.2 | Dec 2024 | Added English localization, Malaysian input formatting, search UX, confirmation/success states |
| 1.3 | Dec 2024 | Added interaction consistency guidelines (element states, actionable patterns) |
