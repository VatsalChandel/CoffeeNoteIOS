# CoffeeNote - Development Roadmap & Tasks

## 📱 App Overview
CoffeeNote is an iOS app for coffee enthusiasts to track the coffee shops they've visited, rate their experiences, and discover new places to explore through a vibrant community.

**Current Status:** Phase 2 Complete ✅ | Phase 3 In Progress ⏸️ | Phase 4 Planned 📋

---

## 📑 Table of Contents

### Quick Reference
- [Development Phases](#-development-phases-overview)
- [Timeline](#-project-timeline)
- [Task Summary](#-task-summary-by-phase)

### Planning & Strategy
- [Important Decisions](#-important-questions--decisions)
- [Success Metrics](#-success-metrics)
- [Potential Issues](#-potential-issues-to-watch-for)
- [Technical Resources](#-technical-resources-needed)

### Implementation Tasks
- [Phase 1: MVP (Tasks 1-5)](#phase-1-mvp-tasks-1-5--completed)
- [Phase 2: Polish & Features (Tasks 6-35)](#phase-2-polish--features-tasks-6-35--completed)
- [Phase 3: Monetization (Tasks 36-41)](#phase-3-monetization-tasks-36-41--in-progress)
- [Phase 4: Community Features (Tasks 42-81)](#phase-4-community-features-tasks-42-81--planned)
- [Phase 5: Future Enhancements](#phase-5-future-enhancements--ideas)

### Development Guide
- [AI-Assisted Development](#-ai-assisted-development-guide)

---

## 🎯 Development Phases Overview

### Phase 1: MVP (Minimum Viable Product) ✅ **COMPLETED**
**Goal:** Core functionality working, ready for personal use
- Authentication (Email/Password - Apple Sign In pending paid account)
- Add/Edit/Delete coffee shop visits
- Basic list view of visits
- Simple map view with pins
- Basic profile with key stats

### Phase 2: Polish & Features ✅ **COMPLETED**
**Goal:** App Store ready
- Wishlist functionality
- Advanced filtering and sorting
- Improved UI/UX and animations
- Empty states and error handling
- Map clustering and filters
- All profile statistics

### Phase 3: Monetization ⏸️ **IN PROGRESS**
**Goal:** Revenue generation
- Premium features (paywalls ✅)
- StoreKit integration (pending - Tasks 36-41)
- Advanced analytics (pending)
- Testing

### Phase 4: Community Features ⏸️ **PLANNED**
**Goal:** Social engagement and discovery
- Public review system (Tasks 42-48)
- Coffee shop community pages (Tasks 49-53)
- Tagging and search (Tasks 54-64)
- Comments and social interactions (Tasks 65-69)
- Privacy and moderation (Tasks 70-73)
- Gamification and analytics (Tasks 74-81)
- **Estimated Duration:** 6-8 weeks

### Phase 5: Growth & Platform Expansion
**Goal:** User acquisition and retention
- Widgets (Home Screen, Lock Screen)
- Shortcuts/Siri integration
- Apple Watch companion app
- Marketing materials
- App Store optimization
- User feedback implementation
- International expansion (multiple currencies)
- iPad optimization

---

## 📅 Project Timeline

**Phase 1 (MVP):** ✅ **COMPLETED** (4-6 weeks)
- Week 1: Setup, authentication, data models
- Week 2: Add visit form and location services
- Week 3: List view, detail view, edit/delete
- Week 4: Map view integration
- Week 5: Profile and statistics
- Week 6: Bug fixes and polish

**Phase 2 (Polish):** ✅ **COMPLETED** (2-3 weeks)
- Wishlist feature
- UI/UX improvements
- Advanced map features
- Testing

**Phase 3 (Monetization):** ⏸️ **IN PROGRESS** (2-3 weeks)
- Premium features (paywalls ✅)
- StoreKit integration (pending - Tasks 36-41)
- Advanced analytics (pending)
- Testing

**Phase 4 (Community Features):** ⏸️ **PLANNED** (6-8 weeks)
- Week 1-2: Data models, Firestore schema, backend services (Tasks 42-53)
- Week 3-4: Core UI - Community tab, views, components (Tasks 54-64)
- Week 5: Social features - ViewModels, likes, comments, sharing (Tasks 65-69)
- Week 6: Privacy controls, moderation, blocking (Tasks 70-73)
- Week 7: Polish - Notifications, gamification, analytics (Tasks 74-79)
- Week 8: Testing, optimization, beta testing (Tasks 80-81)

**Phase 5 (Growth & Expansion):** ⏸️ **FUTURE** (4-6 weeks)
- Widgets, Shortcuts, Siri integration
- Apple Watch app
- Marketing and ASO
- International expansion
- User feedback iteration

**Total Development Time:**
- **Completed:** ~6-9 weeks (Phases 1-2)
- **In Progress:** ~2-3 weeks (Phase 3)
- **Planned:** ~10-14 weeks (Phases 4-5)
- **Grand Total:** ~18-26 weeks from start to full feature set

---

## 📊 Task Summary by Phase

| Phase | Status | Tasks | Description |
|-------|--------|-------|-------------|
| Phase 1 | ✅ Complete | 1-5 | Setup, Auth, Data Models, Theme |
| Phase 2 | ✅ Complete | 6-35 | Location, Firestore, Add Visit, Lists, Map, Wishlist, Profile, Tab Nav |
| Phase 3 | ⏸️ In Progress | 36-41 | StoreKit, IAP, Subscriptions, Restore Purchases |
| Phase 4 | 📋 Planned | 42-81 | Community Reviews, Tags, Search, Comments, Moderation, Gamification |
| Phase 5 | 💡 Ideas | - | Widgets, Watch, Siri, Social expansion |

**Total Tasks:** 81 defined tasks + future enhancements

---

## 🤔 Important Questions & Decisions

### ✅ Decided
- **Rating scale:** 1-5 stars with 0.5 increments
- **Multiple visits:** Yes - each visit is a separate entry
- **Photo uploads:** NOT IMPLEMENTING - No photos/images anywhere in the app
- **Authentication:** Apple Sign In (when paid account available) + Email/Password
- **Social features:** Phase 4 - Community features with public reviews
- **Monetization timing:** Phase 3, after core features polished
- **Location input:** MKLocalSearch (primary) + Current Location (secondary) + Manual (fallback)
- **Items field:** List of items (users can add multiple items per visit)
- **Currency:** USD only for now (can expand later)
- **Free tier limit:** 25 shops maximum
- **Free tier restrictions:**
  - Map page blocked (premium only)
  - "Want to Go" wishlist page blocked (premium only)
  - Community features blocked (premium only) - OR read-only access for free users (TBD)
  - Visits list always available
- **Data export:** Not implementing initially (family & friends release)
- **App name:** TBD - can decide later before App Store submission
- **Privacy:** Clear disclosure about location usage for shop tracking

### ⚠️ To Decide Later (Community Features - Phase 4)
- [ ] **Community access model:** Full premium-only OR read-only free + posting requires premium
- [ ] **Shop identification:** MKMapItem placeID vs coordinate clustering vs hybrid approach
- [ ] **Review aggregation:** Real-time Cloud Functions vs scheduled batch processing vs hybrid
- [ ] **Content moderation:** Manual vs ML-based vs hybrid approach
- [ ] **Minimum review length:** 20 characters vs 50 vs 100 for quality control
- [ ] **Tag requirements:** Mandatory vs optional when publishing reviews
- [ ] **Anonymous posting:** Allow anonymous reviews or always require display name
- [ ] **Age restrictions:** 18+ for community features or allow all ages with parental controls
- [ ] **Coffee shop claiming:** Allow business owners to claim/manage their pages (Phase 5)

### ⚠️ To Decide Later (General)
- [ ] **App name:** Need to check App Store availability before submission
- [ ] **Data export:** Consider adding in future if user base grows
- [ ] **International expansion:** Multiple currencies if going global

---

## 🎯 Success Metrics

### MVP Success Criteria (Phase 1-2)
- User can sign in with Email/Password
- User can add a visit with location
- User can view all visits in a list
- User can see visits on a map
- User can view basic profile stats
- Data persists in Firebase

### Launch Readiness (Phase 3)
- No critical bugs
- Tested on multiple devices
- Privacy policy and terms created
- App Store listing ready
- TestFlight beta completed
- Performance is acceptable
- StoreKit integration working

### Community Features Success (Phase 4)

**Activation:**
- % of users who view community tab within first week
- % of users who publish at least one review
- Time to first review publication

**Engagement:**
- Daily/Monthly active community users
- Average reviews per active user
- Average comments per review
- Average likes per review
- Search queries per user session

**Content Quality:**
- Average review length (target: 100+ characters)
- % reviews with multiple tags
- Review edit rate (lower is better - indicates quality first time)
- Tag diversity (variety of tags used across reviews)

**Community Health:**
- Report rate (lower is better)
- Ban rate (lower is better)
- Positive sentiment ratio
- User retention in community features

**Business Impact:**
- Community feature conversion to premium (%)
- Premium retention for community users
- User acquisition through shared reviews (deep links)

---

## 🔍 Potential Issues to Watch For

### Technical Challenges
- **Map performance:** With hundreds of pins, clustering is essential
- **Location accuracy:** GPS can be inaccurate indoors
- **Data aggregation:** Calculating stats efficiently across many visits
- **Network connectivity:** Require internet connection - show friendly message if offline
- **Community scale (Phase 4):**
  - Firestore read/write costs with growing community
  - Real-time listener performance at scale (thousands of concurrent users)
  - Duplicate coffee shop consolidation across different spellings/locations
  - Search performance with fuzzy matching and filtering

### Design Challenges
- **Form UX:** Adding a visit shouldn't feel tedious
- **Empty states:** First-time user experience is critical
- **Navigation:** 4-5 tabs - make sure it's not confusing (5th tab for Community in Phase 4)
- **Search results:** Need good UX for location autocomplete
- **Community UX (Phase 4):**
  - Encouraging users to make first review public
  - Balancing personal tracking vs. community sharing
  - Handling negative reviews gracefully
  - Preventing review fatigue (too many prompts to share)
  - Making community features discoverable

### Business Challenges
- **User retention:** How to keep users coming back?
- **Monetization timing:** When to introduce premium?
- **Competition:** Are there similar apps? What's unique?
- **Privacy:** Users are sensitive about location data
- **Community challenges (Phase 4):**
  - Content moderation at scale (fake reviews, spam, offensive content)
  - Review bombing from competitors
  - User harassment and toxic behavior
  - Legal liability for user-generated content
  - GDPR compliance and right to be forgotten
  - Balancing free vs premium access to maximize both engagement and revenue

---

## 📚 Technical Resources Needed

### Apple Frameworks
- SwiftUI
- MapKit (MKLocalSearch, MKMapView)
- CoreLocation (CLLocationManager, CLGeocoder)
- AuthenticationServices (Apple Sign In)
- StoreKit 2 (for monetization - Phase 3)
- UserNotifications (push notifications - Phase 4)

### Third-Party
- Firebase SDK
  - Firebase Auth
  - Firestore (primary database)
  - Firebase Cloud Functions (for community aggregations - Phase 4)
  - Firebase Cloud Messaging (push notifications - Phase 4)
  - Firebase ML Kit (optional - content moderation - Phase 4)

### Documentation to Review
- [ ] MapKit MKLocalSearch documentation
- [ ] Firebase Apple Sign In integration guide
- [ ] Firestore data modeling best practices
- [ ] StoreKit 2 subscription documentation
- [ ] Firebase Cloud Functions for Firestore triggers (Phase 4)
- [ ] Firestore security rules best practices (Phase 4)
- [ ] Firebase Cloud Messaging setup guide (Phase 4)
- [ ] Deep linking and Universal Links (Phase 4)
- [ ] UIActivityViewController for sharing (Phase 4)
- [ ] Content moderation strategies and ML Kit (Phase 4)

---

# 🚀 DETAILED IMPLEMENTATION TASKS

---

## Phase 1: MVP (Tasks 1-5) ✅ **COMPLETED**

### Task 1: Project Setup ✅ **COMPLETED**
- ✅ Create new SwiftUI iOS project
- ✅ Set minimum deployment target to iOS 17
- ✅ Configure bundle ID and team signing
- ✅ Add Firebase SDK via SPM (FirebaseAuth, FirebaseFirestore)
- ✅ Create basic folder structure (Models, Views, ViewModels, Services, Utilities)

### Task 2: Firebase Configuration ✅ **COMPLETED**
- ✅ Add GoogleService-Info.plist to project
- ✅ Create FirebaseManager singleton class
- ✅ Initialize Firebase in App file
- ✅ Test Firebase connection

### Task 3: Info.plist Configuration ✅ **COMPLETED**
- ✅ Add location permission descriptions
- ⏸️ Add Sign in with Apple capability (requires paid Apple Developer account - skipped for now)
- ✅ Configure any required background modes

### Task 4: Data Models ✅ **COMPLETED**
- ✅ Create `CoffeeShopVisit` struct (Codable, Identifiable)
- ✅ Create `WantToGoLocation` struct (Codable, Identifiable)
- ✅ Create `UserProfile` struct for storing user data
- ✅ Add convenience methods for Firestore conversion

### Task 5: Color Scheme & Theme ✅ **COMPLETED**
- ✅ Define app color palette (coffee theme)
- ✅ Create Color extension with custom colors
- ✅ Create reusable typography styles
- ✅ Set up dark mode support

---

## Phase 2: Polish & Features (Tasks 6-35) ✅ **COMPLETED**

### Authentication (Tasks 6-9) ⚠️ **IMPLEMENTED WITH EMAIL/PASSWORD**

**NOTE:** Tasks 6-9 have been completed using **Email/Password authentication** instead of Apple Sign In because Apple Sign In requires a paid Apple Developer account ($99/year). When the paid account is obtained, we can add Apple Sign In alongside the existing authentication.

**What was implemented:**
- ✅ `AuthenticationService` with Email/Password (sign up, sign in, sign out, password reset)
- ✅ `AuthViewModel` with full auth state management
- ✅ `AuthView` with sign in/sign up UI
- ✅ Auth state manager in `CoffeeNoteApp.swift`
- ✅ All authentication flows working with Firebase Auth

**Original Tasks (NOT doing Apple Sign In until paid account):**

**Task 6: Authentication Service** ⏸️ **SKIPPED (USING EMAIL/PASSWORD INSTEAD)**
- ⏸️ Create `AuthenticationService` class
- ⏸️ Implement Apple Sign In method using AuthenticationServices
- ⏸️ Link Apple Sign In to Firebase Authentication
- ⏸️ Handle authentication state changes

**Task 7: Authentication ViewModel** ⏸️ **SKIPPED (USING EMAIL/PASSWORD INSTEAD)**
- ⏸️ Create `AuthViewModel` (ObservableObject)
- ⏸️ Properties: isAuthenticated, currentUser, error
- ⏸️ Methods: signIn(), signOut(), checkAuthState()
- ⏸️ Handle error states

**Task 8: Sign In View** ⏸️ **SKIPPED (USING EMAIL/PASSWORD INSTEAD)**
- ⏸️ Create SignInView SwiftUI view
- ⏸️ Add app logo/title
- ⏸️ Add "Sign in with Apple" button (SignInWithAppleButton)
- ⏸️ Show loading state during sign in
- ⏸️ Display errors if sign in fails

**Task 9: Auth State Manager** ⏸️ **SKIPPED (USING EMAIL/PASSWORD INSTEAD)**
- ⏸️ Create main app entry point that checks auth state
- ⏸️ Show SignInView if not authenticated
- ⏸️ Show main TabView if authenticated
- ⏸️ Handle auth state transitions smoothly

---

### Location Services (Tasks 10-12) ✅ **COMPLETED**

**Task 10: LocationManager** ✅ **COMPLETED**
- ✅ Create `LocationManager` class (ObservableObject)
- ✅ Request location permissions
- ✅ Get current location coordinates
- ✅ Handle location errors and permissions denial
- ✅ Implement CLLocationManagerDelegate

**Task 11: Location Search Service** ✅ **COMPLETED**
- ✅ Create `LocationSearchService` class
- ✅ Implement MKLocalSearch for location autocomplete
- ✅ Method: searchLocations(query: String) -> [MKMapItem]
- ✅ Return results as array of locations
- ✅ Bonus: searchCoffeeShopsNearby() method
- ✅ Bonus: MKMapItem extension for formatted addresses

**Task 12: Geocoding Service** ✅ **COMPLETED**
- ✅ Create `GeocodingService` class
- ✅ Implement forward geocoding (address → coordinates)
- ✅ Implement reverse geocoding (coordinates → address)
- ✅ Handle geocoding errors
- ✅ Bonus: CLPlacemark extensions for address formatting

---

### Firestore Service (Tasks 13-15) ✅ **COMPLETED**

**Task 13: Firestore Service - Visits** ✅ **COMPLETED**
- ✅ Create `VisitService` class
- ✅ Implement: createVisit(visit: CoffeeShopVisit)
- ✅ Implement: fetchVisits(for userId: String) -> [CoffeeShopVisit]
- ✅ Implement: updateVisit(visit: CoffeeShopVisit)
- ✅ Implement: deleteVisit(id: String)
- ✅ Add error handling
- ✅ Bonus: Real-time listeners with listenToVisits()
- ✅ Bonus: Query methods (sortByDate, sortByRating, countVisits)

**Task 14: Firestore Service - Wishlist** ✅ **COMPLETED**
- ✅ Create `WishlistService` class
- ✅ Implement: addToWishlist(location: WantToGoLocation)
- ✅ Implement: fetchWishlist(for userId: String) -> [WantToGoLocation]
- ✅ Implement: deleteFromWishlist(id: String)
- ✅ Add error handling
- ✅ Bonus: Real-time listeners with listenToWishlist()
- ✅ Bonus: Query methods (sortByDate, countWishlist)

**Task 15: User Profile Service** ✅ **COMPLETED**
- ✅ Create `UserProfileService` class
- ✅ Implement: createUserProfile(userId: String, name: String?)
- ✅ Implement: getUserProfile(userId: String) -> UserProfile?
- ✅ Store subscription status (free/premium)
- ✅ Update subscription status method
- ✅ Bonus: getOrCreateUserProfile() helper
- ✅ Bonus: Real-time listeners with listenToUserProfile()
- ✅ Bonus: Subscription helpers (isPremiumUser, upgradeToPremium, downgradeToFree)

---

### Add Visit Feature (Tasks 16-20) ✅ **COMPLETED**

**Task 16: Location Search Component** ✅ **COMPLETED**
- ✅ Create `LocationSearchView` (reusable component)
- ✅ Text field with real-time search
- ✅ Display search results in a List
- ✅ Handle result selection (return MKMapItem)
- ✅ Add "Use Current Location" button
- ✅ Show loading state while searching

**Task 17: Items List Component** ✅ **COMPLETED**
- ✅ Create `ItemsListEditor` view (reusable)
- ✅ Text field to add new items
- ✅ Display added items in a List
- ✅ Delete items with X button
- ✅ Return array of strings

**Task 18: Rating Picker Component** ✅ **COMPLETED**
- ✅ Create `StarRatingPicker` view (reusable)
- ✅ Display 5 stars
- ✅ Allow selection of 0.5 increments (half stars)
- ✅ Return Double (0.5 - 5.0)
- ✅ Visual feedback on selection
- ✅ Bonus: StarRatingDisplay component for read-only display

**Task 19: Add Visit View** ✅ **COMPLETED**
- ✅ Create `AddVisitView`
- ✅ Integrate LocationSearchView
- ✅ Shop name field (pre-filled from location)
- ✅ ItemsListEditor for items
- ✅ StarRatingPicker for rating
- ✅ Price TextField with $ formatting
- ✅ DatePicker (default: today)
- ✅ Notes TextEditor (optional)
- ✅ Save and Cancel buttons

**Task 20: Add Visit ViewModel** ✅ **COMPLETED**
- ✅ Create `AddVisitViewModel`
- ✅ Properties for all form fields
- ✅ Validation logic (required fields)
- ✅ Method: saveVisit() async
- ✅ Call VisitService to save to Firestore
- ✅ Handle success/error states
- ✅ Bonus: reset() method to clear form

---

### Visits List Feature (Tasks 21-24) ✅ **COMPLETED**

**Task 21: Visit Card Component** ✅ **COMPLETED**
- ✅ Create `VisitCardView` (reusable)
- ✅ Display: shop name, date, rating (stars), price
- ✅ Display: first 2-3 items ordered
- ✅ Coffee-themed design
- ✅ Tappable to navigate to detail
- ✅ Bonus: Notes preview, address display

**Task 22: Visits List View** ✅ **COMPLETED**
- ✅ Create `VisitsListView`
- ✅ Fetch and display all visits
- ✅ Use VisitCardView for each item
- ✅ Pull to refresh
- ✅ Context menu with delete action
- ✅ Empty state (no visits yet)
- ✅ Add "+" button to add new visit
- ✅ Bonus: Stats header (total visits, total spent, avg rating)
- ✅ Bonus: Search functionality

**Task 23: Visits List ViewModel** ✅ **COMPLETED**
- ✅ Create `VisitsListViewModel`
- ✅ Fetch visits from VisitService
- ✅ Properties: visits array, isLoading, error
- ✅ Methods: loadVisits(), deleteVisit(id:), refreshVisits()
- ✅ Sort options (date, rating, name, price)
- ✅ Search/filter functionality
- ✅ Bonus: Real-time listener support
- ✅ Bonus: Statistics (totalVisits, totalSpent, averageRating)

**Task 24: Visit Detail View** ✅ **COMPLETED**
- ✅ Create `VisitDetailView`
- ✅ Display all visit information (full details)
- ✅ Show mini map with location pin
- ✅ Display all items ordered
- ✅ Delete button (with confirmation alert)

---

### Map View Feature (Tasks 25-27) ✅ **COMPLETED**

**Task 25: Custom Map Annotations** ✅ **COMPLETED**
- ✅ Create `MapAnnotation` struct (Identifiable)
- ✅ Properties: coordinate, title, subtitle, type (visit/wishlist)
- ✅ Store visit/wishlist data
- ✅ Different types for visited vs wishlist (MapAnnotationType enum)

**Task 26: Map View** ✅ **COMPLETED**
- ✅ Create `CoffeeMapView` using Map from SwiftUI
- ✅ Display all visits as pins (brown cup.and.saucer.fill icon)
- ✅ Display all wishlist items as pins (gold star.fill icon)
- ✅ Center on user location with "Center on Me" button
- ✅ Tap pin to show detail sheet (VisitDetailView or WishlistDetailSheet)
- ✅ Custom AnnotationView with shop name labels
- ✅ Filter controls with toggle buttons for Visits and Wishlist
- ✅ Empty state view when no locations exist

**Task 27: Map View ViewModel & Clustering** ✅ **COMPLETED**
- ✅ Create `MapViewModel`
- ✅ Fetch visits and wishlist items with real-time listeners
- ✅ Convert to map annotations
- ✅ Filter toggles: showVisits, showWishlist, showAll
- ✅ "Zoom to fit all pins" method
- ✅ Handle empty state
- ✅ Statistics: visitCount, wishlistCount

---

### Wishlist Feature (Tasks 28-30) ✅ **COMPLETED**

**Task 28: Add to Wishlist View** ✅ **COMPLETED**
- ✅ Create `AddToWishlistView`
- ✅ Create `AddWishlistViewModel` with form validation
- ✅ Reuse LocationSearchView for location selection
- ✅ Shop name field (auto-filled from location)
- ✅ Notes TextEditor (optional - why they want to visit)
- ✅ Save button with validation
- ✅ Call WishlistService to save to Firestore

**Task 29: Wishlist List View** ✅ **COMPLETED**
- ✅ Create `WishlistView` with NavigationView
- ✅ Create `WishlistViewModel` with real-time listeners
- ✅ Create `WishlistCardView` component for list items
- ✅ Display all wishlist items in scrollable list
- ✅ Show distance from current location (using LocationManager)
- ✅ Context menu with delete action
- ✅ Tap to see detail (opens WishlistDetailView)
- ✅ Empty state with "Add Your First Shop" button
- ✅ Stats header showing total wishlist count
- ✅ Pull to refresh functionality

**Task 30: Wishlist Detail & "Mark as Visited"** ✅ **COMPLETED**
- ✅ Create `WishlistDetailView` with full location details
- ✅ Display location on mini map with star annotation
- ✅ Edit notes inline with save/cancel buttons
- ✅ Delete button with confirmation alert
- ✅ "Mark as Visited" button functionality
  - ✅ Opens AddVisitView with location pre-filled (via MarkAsVisitedView wrapper)
  - ✅ Automatically deletes from wishlist after visit is saved
- ✅ Updated AddVisitView to support optional callback and viewModel injection
- ✅ Updated WishlistService with convenience methods (updateWishlistLocation, deleteFromWishlist with id only)

---

### Profile & Statistics (Tasks 31-33) ✅ **COMPLETED**

**Task 31: Statistics Calculator** ✅ **COMPLETED**
- ✅ Create `StatisticsCalculator` class
- ✅ Create `CoffeeStatistics` struct to hold all stats
- ✅ Calculate: total visits, average rating, total spent, average price
- ✅ Calculate: favorite item (most frequently ordered)
- ✅ Calculate: most visited shop (visited more than once)
- ✅ Calculate: highest rated shop (4.5+ rating)
- ✅ Calculate: most expensive visit, first visit date
- ✅ Return as struct with all stats

**Task 32: Profile Statistics ViewModel** ✅ **COMPLETED**
- ✅ Create `ProfileViewModel` with @MainActor
- ✅ Fetch all visits and wishlist items
- ✅ Use StatisticsCalculator to compute stats
- ✅ Properties: stats, userProfile, isLoading, errorMessage
- ✅ Real-time updates via Firestore listeners
- ✅ Subscription management (isPremiumUser, upgradeToPremium)
- ✅ Sign out functionality

**Task 33: Profile View** ✅ **COMPLETED**
- ✅ Create `ProfileView` with NavigationView
- ✅ Display user info (email from Firebase Auth)
- ✅ Display "Member since" with first visit date
- ✅ Subscription status section (Free/Premium with upgrade button)
- ✅ Display statistics in cards/grid:
  - ✅ Main stats grid (Total Visits, Wishlist, Total Spent, Avg Rating)
  - ✅ Additional stats rows (Favorite Item, Most Visited, Highest Rated, Most Expensive, Avg Price)
- ✅ Create reusable components: StatCard, StatRow, SettingsRow
- ✅ Settings section:
  - ✅ Location usage explanation
  - ✅ Privacy policy link (placeholder)
  - ✅ Terms of service link (placeholder)
  - ✅ Sign out button with confirmation
  - ✅ Delete account button with confirmation (placeholder)
- ✅ Pull to refresh functionality

---

### UI/UX Polish (Tasks 34-35) ✅ **COMPLETED**

**Task 34: Tab Bar Navigation** ✅ **COMPLETED**
- ✅ Create `MainTabView` with 4 tabs
- ✅ Tab 1: VisitsListView (SF Symbol: "cup.and.saucer.fill") - Always available
- ✅ Tab 2: MapView (SF Symbol: "map.fill") - Shows PaywallView for free users
- ✅ Tab 3: WishlistView (SF Symbol: "star.fill") - Shows PaywallView for free users
- ✅ Tab 4: ProfileView (SF Symbol: "person.fill") - Always available
- ✅ Style tab bar with coffee brown accent color
- ✅ Integrate ProfileViewModel to check subscription status
- ✅ Updated CoffeeNoteApp.swift to use MainTabView

**Task 35: Premium Paywalls** ✅ **COMPLETED**
- ✅ Create `PaywallView` (reusable with parameters)
- ✅ Show feature-specific benefits list
- ✅ Display all premium features (Map, Wishlist, Unlimited Visits)
- ✅ Show pricing ($2.99/month or $9.99 one-time)
- ✅ "Upgrade to Premium" button with gradient styling
- ✅ Create reusable components: BenefitRow, FeatureRow
- ✅ Implement upgrade functionality (calls UserProfileService)
- ✅ Use on Map tab for free users
- ✅ Use on Wishlist tab for free users
- ✅ Check subscription status via ProfileViewModel before showing
- ✅ Beautiful gradient background and lock icon
- ✅ Demo disclaimer note

---

## Phase 3: Monetization (Tasks 36-41) ⏸️ **IN PROGRESS**

### In-App Purchase Implementation

**Task 36: StoreKit Configuration File** ⏸️ **NEXT**
- [ ] Create `.storekit` configuration file in Xcode
- [ ] Add product: Monthly Subscription (`coffee_note_premium_monthly` - $2.99/month)
- [ ] Add product: Lifetime Purchase (`coffee_note_premium_lifetime` - $9.99 one-time)
- [ ] Configure subscription group and duration
- [ ] Set up product localizations
- [ ] Enable StoreKit testing in scheme

**Task 37: SubscriptionManager Service** ⏸️ **NEXT**
- [ ] Create `SubscriptionManager` class using StoreKit 2
- [ ] Implement product fetching from App Store
- [ ] Method: `loadProducts() async -> [Product]`
- [ ] Method: `purchase(product: Product) async throws -> Transaction?`
- [ ] Handle transaction states (purchased, pending, failed)
- [ ] Transaction listener for updates
- [ ] Store subscription status in UserDefaults/Firestore

**Task 38: Receipt Validation & Verification** ⏸️ **NEXT**
- [ ] Implement local receipt validation with StoreKit 2
- [ ] Verify transaction authenticity
- [ ] Update UserProfile subscription tier in Firestore
- [ ] Handle subscription renewals automatically
- [ ] Handle subscription cancellations
- [ ] Sync subscription status across devices

**Task 39: Update PaywallView for Real Purchases** ⏸️ **NEXT**
- [ ] Integrate SubscriptionManager into PaywallView
- [ ] Fetch and display real products with prices
- [ ] Replace mock upgrade with real purchase flow
- [ ] Show loading state during purchase
- [ ] Handle purchase success (show confirmation, dismiss paywall)
- [ ] Handle purchase errors (show user-friendly messages)
- [ ] Add purchase completion animations

**Task 40: Restore Purchases** ⏸️ **NEXT**
- [ ] Add "Restore Purchases" button in ProfileView
- [ ] Implement restore functionality in SubscriptionManager
- [ ] Check for existing transactions
- [ ] Update subscription status if valid purchase found
- [ ] Show success/failure alert to user
- [ ] Required by Apple for all apps with IAP

**Task 41: Subscription Management UI** ⏸️ **NEXT**
- [ ] Update ProfileView subscription section
- [ ] Show active subscription details (plan, renewal date)
- [ ] Link to Apple's subscription management
- [ ] Show purchase history
- [ ] Add "Restore Purchases" button
- [ ] Handle subscription expiration gracefully
- [ ] Test all subscription states (active, expired, grace period)

### App Store Connect Setup (Production Only)
- [ ] Create products in App Store Connect
  - [ ] Monthly auto-renewable subscription ($2.99/month)
  - [ ] One-time non-consumable purchase ($9.99)
- [ ] Create subscription group
- [ ] Set up pricing in all regions
- [ ] Configure subscription benefits
- [ ] Add product screenshots/descriptions
- [ ] Submit for review with app

### Testing Strategy
- [ ] Test with StoreKit configuration file (local)
- [ ] Test with sandbox accounts (App Store Connect)
- [ ] Test all purchase flows (success, failure, cancellation)
- [ ] Test restore purchases on multiple devices
- [ ] Test subscription renewal
- [ ] Test subscription cancellation
- [ ] Test family sharing (if enabled)
- [ ] Test edge cases (no internet, App Store unavailable)

### Premium Features
- [ ] Unlimited shop tracking (free = 25 shops limit)
  - [ ] Implement visit counter
  - [ ] Show remaining visits in free tier
  - [ ] Block adding new visits at 25 for free users
  - [ ] Show upgrade prompt when limit reached
- [ ] Map View access (blocked for free users)
  - [ ] Show paywall/upgrade screen on Map tab for free users
  - [ ] Explain benefits of seeing shops on map
- [ ] Wishlist/Want to Go access (blocked for free users)
  - [ ] Show paywall/upgrade screen on Wishlist tab for free users
  - [ ] Explain benefits of tracking future visits
- [ ] Community Features access (blocked for free users) **NEW - Phase 4**
  - [ ] Show paywall/upgrade screen on Community tab for free users
  - [ ] Explain benefits of discovering shops and sharing reviews
  - [ ] Read-only access to community for free users (alternative option)
- [ ] Export data to CSV/PDF
- [ ] Advanced statistics dashboard
- [ ] Custom themes

### Monetization Strategy (To Decide)
- [ ] Freemium with in-app purchase
- [ ] Monthly subscription ($2.99/month?)
- [ ] One-time premium unlock ($9.99?)

---

## Phase 4: Community Features (Tasks 42-81) ⏸️ **PLANNED**

### Overview
Add social/community aspect where users can share reviews publicly, discover coffee shops through community ratings, and engage with other coffee enthusiasts.

**Core Concept:**
- Users can toggle their private visits to "public" to share with the community
- Public reviews appear on Coffee Shop Community Pages
- Each coffee shop has an aggregated community page with all public reviews
- Users can comment on public reviews
- Tagging system for shop attributes (work-friendly, loud, clean, fast service, etc.)
- Community tab for discovering and searching coffee shops
- **NO PHOTOS/IMAGES** - Text-based only

---

### Data Models & Structure (Community)

**Task 42: PublicReview Model** ⏸️ **PENDING**
- [ ] Create `PublicReview` struct (extends/references CoffeeShopVisit)
  - [ ] id: String (unique review ID)
  - [ ] userId: String (reviewer's Firebase user ID)
  - [ ] userName: String (display name - anonymized or real based on user settings)
  - [ ] visitId: String (reference to original CoffeeShopVisit)
  - [ ] shopName: String (normalized coffee shop name)
  - [ ] shopAddress: String
  - [ ] placeID: String? (MKMapItem place ID for shop aggregation)
  - [ ] latitude: Double
  - [ ] longitude: Double
  - [ ] itemsOrdered: [String]
  - [ ] rating: Double (1-5 stars)
  - [ ] price: Double
  - [ ] reviewText: String (detailed review/notes)
  - [ ] tags: [CoffeeShopTag] (array of tags)
  - [ ] datePosted: Date
  - [ ] dateVisited: Date
  - [ ] likeCount: Int (number of likes)
  - [ ] commentCount: Int (denormalized for performance)
  - [ ] isEdited: Bool
  - [ ] lastEditedDate: Date?

**Task 43: CoffeeShopTag Enum** ⏸️ **PENDING**
- [ ] Create `CoffeeShopTag` enum (String, CaseIterable, Codable)
  - [ ] Ambiance tags: cozy, modern, rustic, minimalist, artistic, trendy
  - [ ] Noise level tags: quiet, moderate, loud, lively
  - [ ] Work-friendliness tags: workFriendly, hasWifi, powerOutlets, quietForCalls, noLaptops
  - [ ] Service tags: fastService, slowService, friendlyStaff, knowledgeableBaristas
  - [ ] Cleanliness tags: veryClean, clean, needsImprovement
  - [ ] Seating tags: plentyOfSeating, limitedSeating, outdoorSeating, comfortableSeating
  - [ ] Specialty tags: locallyOwned, chain, organicOptions, dairyFreeOptions, petFriendly, instagrammable
  - [ ] Parking tags: easyParking, streetParkingOnly, noParkingNearby, paidParking
  - [ ] Price tags: affordable, moderate, pricey
- [ ] Add display names and SF Symbol icons for each tag
- [ ] Add tag colors for visual categorization

**Task 44: CoffeeShopCommunityPage Model** ⏸️ **PENDING**
- [ ] Create `CoffeeShopCommunityPage` struct (aggregated data)
  - [ ] id: String (unique shop identifier)
  - [ ] shopName: String (normalized name)
  - [ ] placeID: String? (MKMapItem place ID)
  - [ ] primaryAddress: String (most common address from reviews)
  - [ ] latitude: Double
  - [ ] longitude: Double
  - [ ] totalReviews: Int (count of public reviews)
  - [ ] averageRating: Double (calculated from all reviews)
  - [ ] averagePrice: Double (calculated from all reviews)
  - [ ] popularItems: [String: Int] (item name: frequency count)
  - [ ] popularTags: [CoffeeShopTag: Int] (tag: frequency count)
  - [ ] topReviewIds: [String] (most helpful/liked reviews - top 3-5)
  - [ ] firstReviewDate: Date
  - [ ] lastReviewDate: Date

**Task 45: Comment Model** ⏸️ **PENDING**
- [ ] Create `Comment` struct (Codable, Identifiable)
  - [ ] id: String
  - [ ] reviewId: String (parent review)
  - [ ] userId: String (commenter)
  - [ ] userName: String
  - [ ] commentText: String (max 500 characters)
  - [ ] datePosted: Date
  - [ ] likeCount: Int
  - [ ] isEdited: Bool
  - [ ] lastEditedDate: Date?

**Task 46: UserCommunityProfile Model** ⏸️ **PENDING**
- [ ] Create `UserCommunityProfile` struct
  - [ ] userId: String
  - [ ] displayName: String (can be different from real name)
  - [ ] bio: String? (optional short bio)
  - [ ] publicReviewCount: Int
  - [ ] totalLikesReceived: Int
  - [ ] joinedDate: Date
  - [ ] privacySettings: CommunityPrivacySettings
  - [ ] isProfilePublic: Bool (show/hide profile page)
  - [ ] blockedUserIds: [String] (users they've blocked)

**Task 47: CommunityPrivacySettings Model** ⏸️ **PENDING**
- [ ] Create `CommunityPrivacySettings` struct
  - [ ] allowComments: Bool (allow others to comment on their reviews)
  - [ ] showRealName: Bool (vs. anonymous username)
  - [ ] allowDirectMessages: Bool (future feature)

---

### Firestore Collections Structure

**Task 48: Design Community Firestore Schema** ⏸️ **PENDING**

Design and implement the following Firestore structure:

```
/publicReviews/{reviewId}
  - All PublicReview fields
  - Indexed by: shopName, placeID, userId, datePosted, rating

/publicReviews/{reviewId}/comments/{commentId}
  - All Comment fields (subcollection)

/publicReviews/{reviewId}/likes/{userId}
  - userId: String
  - likedAt: Date
  - (existence indicates like)

/coffeeShops/{shopId}
  - CoffeeShopCommunityPage aggregated data
  - Updated via Cloud Functions when reviews are added/modified

/users/{userId}/communityProfile
  - UserCommunityProfile data

/users/{userId}/publicReviewIds/{reviewId}
  - reviewId: String (for quick lookup of user's public reviews)

/users/{userId}/likedReviews/{reviewId}
  - reviewId: String
  - likedAt: Date

/users/{userId}/blockedUsers/{blockedUserId}
  - blockedAt: Date
```

**Considerations:**
- [ ] Set up Firestore indexes for efficient queries
- [ ] Implement Firestore security rules for read/write permissions
- [ ] Design for scalability (denormalize where necessary)
- [ ] Add pagination for large datasets
- [ ] Consider using Cloud Functions for aggregations

---

### Backend Services

**Task 49: PublicReviewService** ⏸️ **PENDING**
- [ ] Create `PublicReviewService` class
- [ ] Method: publishVisitAsReview(visit: CoffeeShopVisit, tags: [CoffeeShopTag], reviewText: String)
  - [ ] Convert private visit to public review
  - [ ] Add to /publicReviews collection
  - [ ] Update user's publicReviewIds
  - [ ] Trigger Cloud Function to update coffee shop aggregations
- [ ] Method: unpublishReview(reviewId: String)
  - [ ] Delete from /publicReviews
  - [ ] Update aggregations
- [ ] Method: fetchPublicReviewsForShop(placeID: String) -> [PublicReview]
- [ ] Method: fetchPublicReviewsForShop(shopName: String, vicinity: CLLocationCoordinate2D) -> [PublicReview]
- [ ] Method: fetchUserPublicReviews(userId: String) -> [PublicReview]
- [ ] Method: updateReview(reviewId: String, updates: PublicReviewUpdate)
- [ ] Method: likeReview(reviewId: String)
- [ ] Method: unlikeReview(reviewId: String)
- [ ] Method: reportReview(reviewId: String, reason: String) (for moderation)
- [ ] Real-time listeners for review updates

**Task 50: CommentService** ⏸️ **PENDING**
- [ ] Create `CommentService` class
- [ ] Method: addComment(reviewId: String, commentText: String)
- [ ] Method: fetchComments(for reviewId: String) -> [Comment]
- [ ] Method: deleteComment(commentId: String)
- [ ] Method: editComment(commentId: String, newText: String)
- [ ] Method: likeComment(commentId: String)
- [ ] Method: reportComment(commentId: String, reason: String)
- [ ] Real-time listeners for comments

**Task 51: CommunitySearchService** ⏸️ **PENDING**
- [ ] Create `CommunitySearchService` class
- [ ] Method: searchCoffeeShops(query: String) -> [CoffeeShopCommunityPage]
- [ ] Method: searchByTags(tags: [CoffeeShopTag], location: CLLocationCoordinate2D?) -> [CoffeeShopCommunityPage]
- [ ] Method: getNearbyShopsWithReviews(location: CLLocationCoordinate2D, radius: Double) -> [CoffeeShopCommunityPage]
- [ ] Method: getTopRatedShops(limit: Int) -> [CoffeeShopCommunityPage]
- [ ] Method: getTrendingShops() -> [CoffeeShopCommunityPage] (most reviews in last 30 days)
- [ ] Advanced filtering: by rating range, price range, tags

**Task 52: CommunityProfileService** ⏸️ **PENDING**
- [ ] Create `CommunityProfileService` class
- [ ] Method: createCommunityProfile(userId: String, displayName: String)
- [ ] Method: updateCommunityProfile(profile: UserCommunityProfile)
- [ ] Method: getCommunityProfile(userId: String) -> UserCommunityProfile?
- [ ] Method: updatePrivacySettings(settings: CommunityPrivacySettings)
- [ ] Method: blockUser(userId: String)
- [ ] Method: unblockUser(userId: String)
- [ ] Method: getBlockedUsers() -> [String]

**Task 53: CoffeeShopAggregationService** ⏸️ **PENDING**
- [ ] Create service for aggregating shop data
- [ ] Method: aggregateShopData(placeID: String) -> CoffeeShopCommunityPage
  - [ ] Calculate average rating from all reviews
  - [ ] Calculate average price
  - [ ] Count total reviews
  - [ ] Find most popular items (top 5)
  - [ ] Find most common tags (top 10)
  - [ ] Identify top reviews (most liked)
- [ ] Method: normalizeShopName(name: String) -> String (handle variations)
- [ ] Method: linkReviewsToShop(placeID: String?, shopName: String, coordinate: CLLocationCoordinate2D)
- [ ] Consider using Firebase Cloud Functions for automatic aggregation

---

### UI Components & Views

**Task 54: Community Tab Navigation** ⏸️ **PENDING**
- [ ] Add 5th tab to MainTabView: "Community" (SF Symbol: "person.3.fill")
- [ ] Make Community tab premium-only (show PaywallView for free users)
- [ ] Update tab bar styling
- [ ] Update ProfileViewModel to check premium status

**Task 55: CommunityHomeView** ⏸️ **PENDING**
- [ ] Create `CommunityHomeView` (main landing page)
- [ ] Search bar for coffee shop search
- [ ] Quick filter chips for popular tags
- [ ] "Nearby Coffee Shops" section with reviews
- [ ] "Trending This Week" section
- [ ] "Top Rated" section
- [ ] "Recent Reviews" feed
- [ ] Empty state for first-time users
- [ ] Pull to refresh

**Task 56: TagFilterView Component** ⏸️ **PENDING**
- [ ] Create reusable `TagFilterView`
- [ ] Display all CoffeeShopTag options in categories
- [ ] Multi-select capability
- [ ] Apply filters button
- [ ] Clear all filters
- [ ] Visual feedback for selected tags
- [ ] Group tags by category (Ambiance, Noise, Work, etc.)

**Task 57: CoffeeShopCommunityDetailView** ⏸️ **PENDING**
- [ ] Create view for individual coffee shop community page
- [ ] Header section:
  - [ ] Shop name, address, map thumbnail
  - [ ] Average rating (large, prominent)
  - [ ] Total reviews count
  - [ ] Average price
- [ ] Popular tags section (visual tag cloud or chips)
- [ ] Popular items section (top 5 most ordered)
- [ ] Reviews list (sorted by: Most Recent, Highest Rated, Most Liked)
- [ ] "Add Your Review" button (if user hasn't reviewed this shop)
- [ ] Navigate to individual reviews
- [ ] Empty state (no reviews yet)

**Task 58: PublicReviewCardView Component** ⏸️ **PENDING**
- [ ] Create reusable `PublicReviewCardView`
- [ ] User info (display name, date posted)
- [ ] Star rating
- [ ] Tags displayed as chips
- [ ] Review text (truncated with "Read more" for long reviews)
- [ ] Items ordered
- [ ] Price
- [ ] Like button with count
- [ ] Comment button with count
- [ ] Share button
- [ ] Three-dot menu (report, edit if own review)
- [ ] Tappable to see full detail view

**Task 59: PublicReviewDetailView** ⏸️ **PENDING**
- [ ] Full review view with all details
- [ ] User profile link (if public)
- [ ] All review information expanded
- [ ] Comments section at bottom
- [ ] Add comment text field (if allowed)
- [ ] Like/unlike functionality
- [ ] Share sheet integration
- [ ] Edit button (if user's own review)
- [ ] Delete button (if user's own review)
- [ ] Report button (for moderation)

**Task 60: CommentsSection Component** ⏸️ **PENDING**
- [ ] Create `CommentsSection` view
- [ ] List all comments for a review
- [ ] Comment input field with character limit (500)
- [ ] Post comment button
- [ ] Individual comment cards:
  - [ ] User name
  - [ ] Comment text
  - [ ] Date posted
  - [ ] Like button
  - [ ] Delete button (if own comment)
  - [ ] Report button
- [ ] Load more pagination for many comments
- [ ] Empty state (no comments yet - be the first!)

**Task 61: PublishReviewView (Make Private Review Public)** ⏸️ **PENDING**
- [ ] Create view for publishing a private visit as public review
- [ ] Pre-populate with visit data
- [ ] Add/edit review text field (expand notes)
- [ ] Tag selector (multi-select from CoffeeShopTag enum)
- [ ] Privacy reminder/disclaimer
- [ ] Preview how review will look
- [ ] "Publish to Community" button
- [ ] Validation: require at least 20 characters in review text
- [ ] Option to publish anonymously vs. with real name

**Task 62: MyPublicReviews View** ⏸️ **PENDING**
- [ ] Create view in ProfileView to see user's public reviews
- [ ] List all user's published reviews
- [ ] Stats: total reviews, total likes received, total comments
- [ ] Make review private button (unpublish)
- [ ] Edit review button
- [ ] Sort options: Most Recent, Most Liked, Highest Rated
- [ ] Empty state (no public reviews yet)

**Task 63: CommunityProfileView** ⏸️ **PENDING**
- [ ] Create public profile view for users
- [ ] Display name, bio
- [ ] Join date, review count, likes received
- [ ] List of user's public reviews
- [ ] "Follow" button (future feature)
- [ ] Block user option
- [ ] Privacy settings (for user's own profile)
- [ ] Empty state for private profiles

**Task 64: CommunitySearchView** ⏸️ **PENDING**
- [ ] Create advanced search interface
- [ ] Search bar for coffee shop name
- [ ] Filter by tags (multi-select)
- [ ] Filter by rating (min rating slider)
- [ ] Filter by price range
- [ ] Sort options: Distance, Rating, Price, Reviews Count
- [ ] "Near Me" toggle for location-based search
- [ ] Search results list (CoffeeShopCommunityPage cards)
- [ ] Map view toggle for search results
- [ ] Save search filters as preset (future)

---

### View Models

**Task 65: CommunityHomeViewModel** ⏸️ **PENDING**
- [ ] Create `CommunityHomeViewModel`
- [ ] Properties: nearbyShops, trendingShops, topRatedShops, recentReviews
- [ ] Properties: isLoading, errorMessage
- [ ] Method: loadNearbyShops(location: CLLocationCoordinate2D)
- [ ] Method: loadTrendingShops()
- [ ] Method: loadTopRated()
- [ ] Method: loadRecentReviews()
- [ ] Method: refreshAll()
- [ ] Real-time listeners for recent reviews

**Task 66: PublicReviewViewModel** ⏸️ **PENDING**
- [ ] Create `PublicReviewViewModel`
- [ ] Properties: review, comments, isLiked, likeCount, commentCount
- [ ] Method: loadReview(reviewId: String)
- [ ] Method: toggleLike()
- [ ] Method: addComment(text: String)
- [ ] Method: deleteComment(commentId: String)
- [ ] Method: shareReview() (generate share sheet)
- [ ] Method: reportReview(reason: String)
- [ ] Real-time listeners for likes and comments

**Task 67: PublishReviewViewModel** ⏸️ **PENDING**
- [ ] Create `PublishReviewViewModel`
- [ ] Properties: visit, selectedTags, reviewText, isPublishing
- [ ] Method: loadVisit(visitId: String)
- [ ] Method: toggleTag(tag: CoffeeShopTag)
- [ ] Method: publishReview() async
- [ ] Validation: review text length (min 20 chars)
- [ ] Validation: at least one tag selected
- [ ] Error handling

**Task 68: CoffeeShopCommunityViewModel** ⏸️ **PENDING**
- [ ] Create `CoffeeShopCommunityViewModel`
- [ ] Properties: shopData, reviews, selectedSort, isLoading
- [ ] Method: loadShopData(placeID: String OR shopName + coordinate)
- [ ] Method: loadReviews()
- [ ] Sort options: mostRecent, highestRated, mostLiked
- [ ] Method: filterReviewsByTags(tags: [CoffeeShopTag])
- [ ] Real-time listeners for new reviews

**Task 69: CommunitySearchViewModel** ⏸️ **PENDING**
- [ ] Create `CommunitySearchViewModel`
- [ ] Properties: searchQuery, selectedTags, results, filters
- [ ] Method: search()
- [ ] Method: applyFilters(rating: Double?, priceRange: ClosedRange<Double>?)
- [ ] Method: sortResults(by: SortOption)
- [ ] Debounce search input for performance
- [ ] Handle empty results state

---

### Privacy, Moderation & Safety

**Task 70: Privacy Controls Implementation** ⏸️ **PENDING**
- [ ] Toggle in VisitDetailView: "Make this review public"
- [ ] Confirmation dialog explaining what becomes public
- [ ] Privacy settings page in profile:
  - [ ] Default visibility for new reviews (private/public)
  - [ ] Display name vs anonymous
  - [ ] Allow comments on reviews toggle
  - [ ] Make profile public/private
- [ ] Clear explanations of what data is shared
- [ ] Option to unpublish reviews at any time

**Task 71: Content Moderation System** ⏸️ **PENDING**
- [ ] Report review functionality
  - [ ] Report reasons: Spam, Offensive, Fake Review, Harassment, Other
  - [ ] Store reports in Firestore: /reports/{reportId}
- [ ] Report comment functionality
- [ ] Admin moderation dashboard (separate admin app or web interface)
- [ ] Auto-hide reviews with multiple reports (pending review)
- [ ] Ban/suspend user capability
- [ ] Content filtering for profanity/inappropriate content
- [ ] Consider using ML Kit for automatic content moderation

**Task 72: Blocking & Safety Features** ⏸️ **PENDING**
- [ ] Block user functionality
  - [ ] Hide all content from blocked users
  - [ ] Prevent blocked users from seeing your content
  - [ ] Prevent blocked users from commenting on your reviews
- [ ] Unblock user capability
- [ ] View blocked users list in settings
- [ ] Safety tips/guidelines page
- [ ] Community guidelines page
- [ ] Terms of service specific to community features

**Task 73: Spam Prevention** ⏸️ **PENDING**
- [ ] Rate limiting on posting reviews (max 10/day)
- [ ] Rate limiting on comments (max 50/day)
- [ ] Duplicate review detection (same shop within short timeframe)
- [ ] CAPTCHA for suspicious activity (optional)
- [ ] Verified user badge (premium + email verified + account age > 30 days)

---

### Additional Features & Polish

**Task 74: Social Sharing Integration** ⏸️ **PENDING**
- [ ] Share review to social media (UIActivityViewController)
- [ ] Deep linking to reviews (open app to specific review)
- [ ] Copy review link to clipboard
- [ ] Share review text and link to Messages, social media, etc.

**Task 75: Notifications (Push)** ⏸️ **PENDING**
- [ ] Set up Firebase Cloud Messaging
- [ ] Notify when someone comments on your review
- [ ] Notify when someone likes your review
- [ ] Notify when nearby coffee shop gets new review
- [ ] Notification settings (granular controls)
- [ ] In-app notification center

**Task 76: Leaderboards & Gamification** ⏸️ **PENDING**
- [ ] Top reviewers leaderboard (most reviews this month)
- [ ] Top contributors (most helpful/liked reviews)
- [ ] Badges/achievements:
  - [ ] First review badge
  - [ ] 10 reviews badge
  - [ ] 50 reviews badge
  - [ ] "Coffee Explorer" - reviewed in 5 different cities
  - [ ] "Local Expert" - 20 reviews in same city
  - [ ] "Helpful Reviewer" - 100 total likes received
- [ ] Display badges on profile and reviews

**Task 77: Advanced Analytics for Users** ⏸️ **PENDING**
- [ ] Community impact stats:
  - [ ] Total views on your reviews
  - [ ] Total likes received
  - [ ] Total comments received
  - [ ] Most popular review
  - [ ] Coffee shops discovered through you
- [ ] Graph of review activity over time
- [ ] Tag usage analytics (which tags you use most)

**Task 78: Discover Feed Algorithm** ⏸️ **PENDING**
- [ ] Personalized feed based on user preferences
- [ ] "For You" algorithm:
  - [ ] Based on user's visited shops (similar shops)
  - [ ] Based on user's ratings (recommend high-rated shops)
  - [ ] Based on tags user frequently uses
  - [ ] Based on location (nearby shops)
- [ ] Trending algorithm (reviews gaining traction)
- [ ] Machine learning for personalization (future)

**Task 79: Coffee Shop Claiming (Future)** ⏸️ **PENDING**
- [ ] Allow coffee shop owners to claim their shop page
- [ ] Verification process (business email, documentation)
- [ ] Claimed shop badge
- [ ] Owner response to reviews
- [ ] Update business info (hours, menu, photos)
- [ ] Analytics for shop owners (views, review sentiment)

---

### Testing & Quality Assurance

**Task 80: Community Feature Testing** ⏸️ **PENDING**
- [ ] Unit tests for all community services
- [ ] UI tests for community flows
- [ ] Test with large datasets (100+ reviews per shop)
- [ ] Test privacy controls thoroughly
- [ ] Test blocking/unblocking flows
- [ ] Test moderation workflows
- [ ] Performance testing for search and filtering
- [ ] Test real-time listeners under load
- [ ] Security testing for Firestore rules
- [ ] Penetration testing for reporting system abuse

---

### Analytics & Metrics

**Task 81: Community Analytics Tracking** ⏸️ **PENDING**
- [ ] Track community feature usage:
  - [ ] Reviews published
  - [ ] Reviews unpublished
  - [ ] Comments posted
  - [ ] Likes given
  - [ ] Searches performed
  - [ ] Tags used
  - [ ] Shares completed
- [ ] Engagement metrics:
  - [ ] Daily active community users
  - [ ] Review engagement rate (likes + comments per review)
  - [ ] Search conversion (searches → shop page views → reviews)
- [ ] Content metrics:
  - [ ] Average review length
  - [ ] Most popular tags
  - [ ] Most reviewed shops
- [ ] Moderation metrics:
  - [ ] Reports submitted
  - [ ] Reports resolved
  - [ ] Banned users
  - [ ] Spam blocked

---

### Important Architecture Decisions (Phase 4)

**Shop Identification Strategy:**
- [ ] How to handle same coffee shop with multiple names/spellings?
  - Option 1: Use MKMapItem placeID as primary identifier (reliable but not always available)
  - Option 2: Use coordinates + fuzzy name matching (complex but more flexible)
  - Option 3: Manual shop database with admin curation (high effort)
  - **Recommendation:** Hybrid approach - prefer placeID, fall back to coordinate clustering + name similarity

**Review Aggregation:**
- [ ] Real-time vs scheduled?
  - Option 1: Real-time Cloud Functions (expensive but always up-to-date)
  - Option 2: Scheduled batch processing (cheaper but delayed)
  - **Recommendation:** Real-time for critical metrics (count, avg rating), scheduled for complex aggregations (popular items, tags)

**Content Moderation:**
- [ ] Manual vs automated?
  - Option 1: Fully manual (high quality but doesn't scale)
  - Option 2: ML-based auto-moderation (scalable but may have false positives)
  - Option 3: Hybrid (auto-flag suspicious, manual review)
  - **Recommendation:** Start with hybrid approach, expand ML as community grows

**Monetization for Community:**
- [ ] Keep community premium-only or make partially free?
  - Option 1: Full community premium-only (strong paywall)
  - Option 2: Read-only community for free, posting requires premium (freemium)
  - Option 3: Limited posts for free (e.g., 3/month), unlimited for premium
  - **Recommendation:** Option 2 - encourages discovery, premium for engagement

**Privacy Considerations:**
- [ ] GDPR compliance for user data
- [ ] Right to be forgotten (delete all reviews/comments)
- [ ] Data portability (export user's community data)
- [ ] Clear consent for making data public
- [ ] Age restrictions (18+ for community features?)
- [ ] Location data handling in public reviews

**Moderation Challenges:**
- [ ] Fake reviews from competitors
- [ ] Review bombing (coordinated negative reviews)
- [ ] Offensive/inappropriate content
- [ ] Spam and promotional content
- [ ] User harassment and bullying
- [ ] Impersonation

**Technical Challenges:**
- [ ] Firestore query costs with large community
- [ ] Real-time listener performance at scale
- [ ] Search performance with fuzzy matching
- [ ] Duplicate shop consolidation
- [ ] Cache invalidation for aggregated data

**UX Challenges:**
- [ ] Discoverability of community features
- [ ] Encouraging first review publication
- [ ] Handling negative reviews gracefully
- [ ] Preventing review fatigue (too many prompts to review)
- [ ] Balancing personal tracking vs. community sharing

---

## Phase 5: Future Enhancements ✨ **IDEAS**

### Social Features Expansion
- [ ] Follow other users
- [ ] Direct messaging between users
- [ ] Friends list and friend recommendations
- [ ] Private groups for coffee enthusiasts
- [ ] Coffee club meetups (event planning)

### Advanced Features
- [ ] Discover nearby coffee shops (Yelp/Google Places API)
- [ ] Brew method tracking (espresso, pour over, cold brew)
- [ ] Time-based analytics (morning vs evening visits)
- [ ] Coffee journal/diary integration
- [ ] Rewards/badges for milestones (10 shops visited, etc.)
- [ ] Import data from other apps
- [ ] Export data to JSON/CSV

### Platform Expansion
- [ ] Home Screen Widget (stats at a glance)
- [ ] Lock Screen Widget
- [ ] Apple Watch companion app
- [ ] iPad optimization
- [ ] macOS app (Mac Catalyst)
- [ ] Shortcuts integration
- [ ] Siri integration

---

# 🤖 AI-Assisted Development Guide

## How to Use AI for This Project

Break the project into small, focused tasks. Each task should be self-contained and clearly defined. Ask AI to help with one component at a time.

### General Tips for AI-Assisted Development

1. **Start with Foundation First**
   - Do Tasks 1-5 first (setup, models, theme)
   - These are prerequisites for everything else

2. **Build One Feature at a Time**
   - Complete all tasks for one feature before moving to next
   - Example: Finish auth (Tasks 6-9) before starting location

3. **Test After Each Task**
   - Run the app after completing each task
   - Make sure it compiles and works before moving on

4. **Use AI for Specific Components**
   - Ask for one view, one view model, or one service at a time
   - Don't ask for entire features in one prompt

5. **Iterate and Refine**
   - AI might not get it perfect first time
   - Ask for modifications: "Make the colors darker", "Add error handling"

6. **Keep Context**
   - Reference previously created components
   - Example: "Use the CoffeeShopVisit model we created earlier"

7. **Ask for Explanations**
   - "Explain how this code works"
   - "Why did you use @State here?"

---

### Example Prompts for AI

**For Task 4 (Data Models):**
```
"Create a Swift struct called CoffeeShopVisit that conforms to Codable and Identifiable.
It should have these properties:
- id: String
- userId: String
- shopName: String
- address: String
- latitude: Double
- longitude: Double
- placeID: String?
- itemsOrdered: [String]
- rating: Double
- price: Double
- notes: String?
- dateVisited: Date

Also add convenience methods to convert to/from Firestore dictionary format."
```

**For Task 18 (Star Rating Picker):**
```
"Create a SwiftUI view called StarRatingPicker that displays 5 stars and allows
users to select a rating with 0.5 increments (half stars). The rating should be a
@Binding<Double> with a range of 0.5 to 5.0. Show filled stars, half-filled stars,
and empty stars as appropriate. Use SF Symbols for the stars."
```

**For Task 21 (Visit Card):**
```
"Create a SwiftUI view called VisitCardView that displays a CoffeeShopVisit in a
card format. Show:
- Shop name (bold)
- Date visited
- Star rating (display-only stars)
- Price formatted as currency
- First 2-3 items ordered

Use a coffee-themed color scheme with browns and creams. Make it look modern
and clean. Add a small coffee cup icon."
```

**For Task 55 (Community Home View):**
```
"Create a SwiftUI view called CommunityHomeView for the community tab landing page.
Include:
- Search bar at the top
- 'Nearby Coffee Shops' section with horizontal scrolling cards
- 'Trending This Week' section
- 'Top Rated' section
- 'Recent Reviews' feed
- Empty state when no content is available
- Pull to refresh functionality

Use the coffee theme colors and make it visually appealing."
```

---

### Task Dependencies

Some tasks depend on others - always complete dependencies first:

- Task 20 depends on Tasks 16, 17, 18, 19
- Task 22 depends on Task 21
- Task 26 depends on Task 25
- Task 33 depends on Tasks 31, 32
- Phase 4 tasks depend on Phase 1-3 being complete

---

### Estimated Time Per Task

- Setup tasks (1-5): 30-60 min each
- Service tasks (6-15): 45-90 min each
- UI component tasks (16-81): 30-120 min each

**Total development time: ~18-26 weeks** across all phases

---

## 📝 Notes & Reminders

**Last Updated:** December 30, 2025

**Key Decisions Made:**
- ✅ No photos/images anywhere in the app (simplified scope)
- ✅ Email/Password auth implemented (Apple Sign In when paid account available)
- ✅ Phases 1-2 complete, Phase 3 in progress
- ✅ Community features fully designed and ready for implementation

**Next Steps:**
1. Complete Phase 3 monetization (Tasks 36-41)
2. Test StoreKit integration thoroughly
3. Plan Phase 4 community features kickoff
4. Decide on community access model (premium-only vs freemium)

---

*End of TODO.md*
