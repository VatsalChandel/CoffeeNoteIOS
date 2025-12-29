# CoffeNote - Todo & Ideas

## App Overview
CoffeNote is an app for coffee enthusiasts to track the coffee shops they've visited, rate their experiences, and discover new places to explore.

---

## 📋 Project Setup & Foundation

### Initial Setup
- [ ] Create new iOS project in Xcode
- [ ] Set up Git repository
- [ ] Configure app bundle ID and signing
- [ ] Set minimum iOS version (recommend iOS 17+)
- [ ] Add required Info.plist entries (location permissions, etc.)

### Firebase Setup
- [ ] Create Firebase project
- [ ] Add iOS app to Firebase project
- [ ] Download and add GoogleService-Info.plist
- [ ] Install Firebase SDK via SPM
- [ ] Enable Firestore Database
- [ ] Enable Firebase Authentication
- [ ] Configure Apple Sign In in Firebase Console
- [ ] Set up Firestore security rules

### Xcode Capabilities
- [ ] Add "Sign in with Apple" capability
- [ ] Add location permissions to Info.plist
  - [ ] NSLocationWhenInUseUsageDescription (e.g., "CoffeNote uses your location to help you log and map the coffee shops you visit.")
- [ ] Add MapKit framework

---

## 🔐 Authentication

- [ ] Create authentication view model
- [ ] Design sign-in screen UI
- [ ] Implement Apple Sign In flow
  - [ ] Request authorization
  - [ ] Handle callback
  - [ ] Link to Firebase
- [ ] Create authenticated/unauthenticated state management
- [ ] Add sign-out functionality
- [ ] Handle authentication errors
- [ ] Create user profile on first sign-in

---

## 💾 Data Models & Structure

### Data Models
- [ ] Create CoffeeShopVisit model
  - [ ] id: String (unique identifier)
  - [ ] userId: String (Firebase user ID)
  - [ ] shopName: String
  - [ ] address: String
  - [ ] latitude: Double
  - [ ] longitude: Double
  - [ ] placeID: String? (optional, from MKMapItem)
  - [ ] itemsOrdered: [String] (array of items)
  - [ ] rating: Double (0.5 increments, range 0.5-5.0)
  - [ ] price: Double (USD)
  - [ ] notes: String?
  - [ ] dateVisited: Date
  - [ ] photoURL: String? (for premium feature)

- [ ] Create WantToGoLocation model
  - [ ] id: String
  - [ ] userId: String
  - [ ] shopName: String
  - [ ] address: String
  - [ ] latitude: Double
  - [ ] longitude: Double
  - [ ] notes: String?
  - [ ] dateAdded: Date

### Firebase/Firestore Structure
- [ ] Design Firestore collection structure:
  - `/users/{userId}/visits/{visitId}` - visited shops
  - `/users/{userId}/wishlist/{locationId}` - want to go
  - `/users/{userId}/profile` - user profile data
- [ ] Create Firestore manager/service class
- [ ] Implement CRUD operations for visits
- [ ] Implement CRUD operations for wishlist
- [ ] Add real-time listeners for data sync

**Decision Point:** Multiple visits to same shop
- Each visit = separate document with full location info
- Easier to query and aggregate
- Allows tracking changes over time (prices, ratings, items)

---

## 🏗️ Core Features

### 1. Coffee Shop Logging System

#### Location Services
- [ ] Create LocationManager class
- [ ] Request location permissions
- [ ] Implement MKLocalSearch for autocomplete
  - [ ] Create search view with text field
  - [ ] Display search results in list
  - [ ] Handle result selection
- [ ] Implement "Use Current Location" feature
  - [ ] Get current coordinates
  - [ ] Reverse geocode to address
  - [ ] Pre-fill form fields
- [ ] Implement CLGeocoder for manual address entry
- [ ] Handle location errors gracefully

#### Add Visit Form
- [ ] Create add visit view
- [ ] Shop name field (auto-filled from location search)
- [ ] Location picker UI with three methods:
  - [ ] MKLocalSearch autocomplete (primary)
  - [ ] "Use Current Location" button (secondary)
  - [ ] Manual address text field (fallback)
- [ ] Items ordered field (allow adding multiple items)
  - [ ] Add item button
  - [ ] List of added items
  - [ ] Remove item capability
- [ ] Rating picker (1-5 stars with 0.5 increments)
- [ ] Price field (USD currency with $ symbol and proper formatting)
- [ ] Date picker (default to today)
- [ ] Notes text area (optional)
- [ ] Save button with validation
- [ ] Cancel button

#### List & Detail Views
- [ ] Create list view for all visits
  - [ ] Sort options (date, rating, name, price)
  - [ ] Search/filter functionality
  - [ ] Pull to refresh
  - [ ] Swipe actions (delete, edit)
- [ ] Create detail view for single visit
  - [ ] Display all visit information
  - [ ] Show mini map with location pin
  - [ ] Edit button
  - [ ] Delete button with confirmation
- [ ] Implement edit functionality
  - [ ] Reuse add visit form
  - [ ] Pre-populate with existing data
  - [ ] Update in Firestore
- [ ] Implement delete functionality
  - [ ] Confirmation alert
  - [ ] Delete from Firestore
  - [ ] Update local state

### 2. Want to Go List (Wishlist)

- [ ] Create add wishlist location form
  - [ ] Shop name field
  - [ ] Location picker (same as visit form)
  - [ ] Notes field (why they want to visit)
  - [ ] Save button
- [ ] Create wishlist view
  - [ ] List all "Want to Go" locations
  - [ ] Show distance from current location
  - [ ] Sort options
  - [ ] Swipe to delete
- [ ] Implement "Mark as Visited" functionality
  - [ ] Convert wishlist item to visit
  - [ ] Open pre-filled add visit form
  - [ ] Remove from wishlist after saving
- [ ] Detail view for wishlist items
  - [ ] Show location on map
  - [ ] Edit notes
  - [ ] Delete option
  - [ ] "Mark as Visited" button

### 3. Map View

- [ ] Create MapView with MapKit
- [ ] Create custom pin annotations
  - [ ] Different colors for visited vs wishlist
  - [ ] Custom annotation view design
- [ ] Display all visited shops as pins
- [ ] Display all wishlist locations as pins (different color)
- [ ] Implement filter toggles
  - [ ] Show visited only
  - [ ] Show wishlist only
  - [ ] Show both
- [ ] Tap on pin to show callout
  - [ ] Shop name
  - [ ] Rating (for visited)
  - [ ] Tap callout to see full details
- [ ] Center map on user's location
- [ ] Implement annotation clustering for performance
- [ ] Add "Zoom to fit all pins" button
- [ ] Handle empty state (no pins yet)

### 4. User Profile & Statistics

- [ ] Create profile view layout
- [ ] Implement statistics calculations:
  - [ ] Total shops visited
  - [ ] Total wishlist items
  - [ ] Average rating given
  - [ ] Total amount spent
  - [ ] Favorite item (most frequently ordered)
  - [ ] Most visited shop
  - [ ] Highest rated shop
  - [ ] Most expensive visit
  - [ ] First shop visited (date)
- [ ] Create view model for profile stats
- [ ] Add real-time updates when data changes
- [ ] Display user info (name, email from Apple Sign In)
- [ ] Add settings section
  - [ ] Sign out button
  - [ ] Delete account option
  - [ ] Show subscription status (Free or Premium)
  - [ ] Upgrade to Premium button (for free users)
  - [ ] Manage subscription (for premium users)
  - [ ] Privacy policy link
  - [ ] Terms of service link
  - [ ] Location usage explanation
- [ ] Design stats cards/widgets for visual display

---

## 🎨 Design & UI

### App Navigation
- [ ] Design and implement tab bar with 4 tabs:
  - Tab 1: Visits List (always available)
  - Tab 2: Map View (premium only - show paywall for free users)
  - Tab 3: Wishlist (premium only - show paywall for free users)
  - Tab 4: Profile (always available)
- [ ] Choose tab bar icons (SF Symbols)
- [ ] Implement navigation between views
- [ ] Add premium badge/lock icon on Map and Wishlist tabs for free users

### Visual Design
- [ ] Design app icon
- [ ] Choose color scheme (coffee-themed browns, creams, warm tones?)
- [ ] Create reusable SwiftUI components:
  - [ ] Custom star rating view
  - [ ] Location search component
  - [ ] Coffee shop card view
  - [ ] Stat card view
- [ ] Design empty states
  - [ ] No visits logged yet
  - [ ] No wishlist items
  - [ ] No map pins
- [ ] Add loading indicators for async operations
- [ ] Implement error state views
- [ ] Add animations and transitions
- [ ] Test and optimize for different screen sizes
- [ ] Support dark mode

---

## 🔧 Technical Implementation

### Architecture & Code Quality
- [ ] Set up MVVM architecture
- [ ] Create view models for each main feature
- [ ] Implement proper error handling
  - [ ] Network errors (show user-friendly messages)
  - [ ] Location errors
  - [ ] Firebase errors
  - [ ] Validation errors
- [ ] Add input validation
  - [ ] Required fields
  - [ ] Price format validation
  - [ ] Rating range validation
- [ ] Implement proper async/await patterns
- [ ] Add loading states for all async operations
- [ ] Create reusable networking layer
- [ ] Add logging for debugging

### Performance & Optimization
- [ ] Optimize map performance with many pins
  - [ ] Implement clustering
  - [ ] Lazy load pin data
- [ ] Implement efficient Firestore queries
  - [ ] Add indexes as needed
  - [ ] Paginate large lists
- [ ] Cache images (for premium photo feature)
- [ ] Optimize app launch time
- [ ] Profile app with Instruments

### Testing
- [ ] Write unit tests for view models
- [ ] Write unit tests for data models
- [ ] Test Firebase integration
- [ ] Test location services
- [ ] Test edge cases (no location permission, invalid data, etc.)
- [ ] Beta test with TestFlight

---

## 💰 Monetization (Phase 2 - Future)

### StoreKit Integration
- [ ] Set up StoreKit configuration file
- [ ] Create in-app purchase products in App Store Connect
- [ ] Implement StoreKit 2 for purchases
- [ ] Create paywall UI
- [ ] Implement purchase restoration
- [ ] Handle subscription status

### Premium Features
- [ ] Photo uploads for each visit
  - [ ] Firebase Storage integration
  - [ ] Image picker
  - [ ] Image compression
  - [ ] Photo gallery view
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
- [ ] Export data to CSV/PDF
- [ ] Advanced statistics dashboard
- [ ] Custom themes

### Monetization Strategy (To Decide)
- [ ] Freemium with in-app purchase
- [ ] Monthly subscription ($2.99/month?)
- [ ] One-time premium unlock ($9.99?)

---

## 🚀 Future Enhancements (Phase 3+)

### Social Features (Optional - Later)
- [ ] Share favorite shops with friends
- [ ] See friends' recommendations
- [ ] Public/private profiles
- [ ] Comments on shops

### Advanced Features
- [ ] Discover nearby coffee shops (Yelp/Google Places API)
- [ ] Tags/categories for shops (specialty, chain, local, etc.)
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

## 🤔 Important Questions & Decisions

### ✅ Decided
- **Rating scale:** 1-5 stars with 0.5 increments
- **Multiple visits:** Yes - each visit is a separate entry
- **Photo uploads:** Premium feature only
- **Authentication:** Apple Sign In
- **Social features:** Not in initial release
- **Monetization timing:** Phase 2, after core features
- **Location input:** MKLocalSearch (primary) + Current Location (secondary) + Manual (fallback)
- **Items field:** List of items (users can add multiple items per visit)
- **Currency:** USD only for now (can expand later)
- **Free tier limit:** 25 shops maximum
- **Free tier restrictions:** 
  - Map page blocked (premium only)
  - "Want to Go" wishlist page blocked (premium only)
  - Visits list always available
- **Data export:** Not implementing initially (family & friends release)
- **App name:** TBD - can decide later before App Store submission
- **Privacy:** Clear disclosure about location usage for shop tracking

### ⚠️ To Decide Later
- [ ] **App name:** Need to check App Store availability before submission
- [ ] **Data export:** Consider adding in future if user base grows
- [ ] **International expansion:** Multiple currencies if going global

---

## 📝 Development Phases

### Phase 1: MVP (Minimum Viable Product)
**Goal:** Core functionality working, ready for personal use
1. Authentication (Apple Sign In)
2. Add/Edit/Delete coffee shop visits
3. Basic list view of visits
4. Simple map view with pins
5. Basic profile with key stats

### Phase 2: Polish & Features
**Goal:** App Store ready
1. Wishlist functionality
2. Advanced filtering and sorting
3. Improved UI/UX and animations
4. Empty states and error handling
5. Map clustering and filters
6. All profile statistics
### Phase 3: Monetization
**Goal:** Revenue generation
1. Implement premium features
2. Photo uploads
3. Advanced analytics
4. Export functionality
5. StoreKit integration

### Phase 4: Growth
**Goal:** User acquisition and retention
1. Widgets
2. Shortcuts/Siri
3. Marketing materials
4. App Store optimization
5. User feedback implementation

---

## 📚 Technical Resources Needed

### Apple Frameworks
- SwiftUI
- MapKit (MKLocalSearch, MKMapView)
- CoreLocation (CLLocationManager, CLGeocoder)
- AuthenticationServices (Apple Sign In)
- StoreKit 2 (for monetization)

### Third-Party
- Firebase SDK
  - Firebase Auth
  - Firestore
  - Firebase Storage (for photos - Phase 3)

### Documentation to Review
- [ ] MapKit MKLocalSearch documentation
- [ ] Firebase Apple Sign In integration guide
- [ ] Firestore data modeling best practices
- [ ] StoreKit 2 subscription documentation

---

## 🎯 Success Metrics

### MVP Success Criteria
- User can sign in with Apple
- User can add a visit with location
- User can view all visits in a list
- User can see visits on a map
- User can view basic profile stats
- Data persists in Firebase

### Launch Readiness
- No critical bugs
- Tested on multiple devices
- Privacy policy and terms created
- App Store listing ready
- TestFlight beta completed
- Performance is acceptable

---

## 🔍 Potential Issues to Watch For

### Technical Challenges
- **Map performance:** With hundreds of pins, clustering is essential
- **Location accuracy:** GPS can be inaccurate indoors
- **Data aggregation:** Calculating stats efficiently across many visits
- **Image storage costs:** Photos in premium tier could get expensive
- **Network connectivity:** Require internet connection - show friendly message if offline

### Design Challenges
- **Form UX:** Adding a visit shouldn't feel tedious
- **Empty states:** First-time user experience is critical
- **Navigation:** 4 tabs - make sure it's not confusing
- **Search results:** Need good UX for location autocomplete

### Business Challenges
- **User retention:** How to keep users coming back?
- **Monetization timing:** When to introduce premium?
- **Competition:** Are there similar apps? What's unique?
- **Privacy:** Users are sensitive about location data

---

## 📅 Estimated Timeline

**Phase 1 (MVP):** 4-6 weeks
- Week 1: Setup, authentication, data models
- Week 2: Add visit form and location services
- Week 3: List view, detail view, edit/delete
- Week 4: Map view integration
- Week 5: Profile and statistics
- Week 6: Bug fixes and polish

**Phase 2 (Polish):** 2-3 weeks
- Wishlist feature
- UI/UX improvements
- Advanced map features
- Testing

**Phase 3 (Monetization):** 2-3 weeks
- Premium features
- StoreKit integration
- Photo uploads
- Testing

**Total to App Store:** ~8-12 weeks of development

---

## 🤖 AI-Assisted Development Tasks
### How to Use AI for This Project
Break the project into small, focused tasks. Each task should be self-contained and clearly defined. Ask AI to help with one component at a time.

### Task Breakdown (35 Discrete Tasks)

#### **Setup & Foundation (Tasks 1-5)** ✅ **COMPLETED**

**Task 1: Project Setup** ✅ **COMPLETED**
- ✅ Create new SwiftUI iOS project
- ✅ Set minimum deployment target to iOS 17
- ✅ Configure bundle ID and team signing
- ✅ Add Firebase SDK via SPM (FirebaseAuth, FirebaseFirestore)
- ✅ Create basic folder structure (Models, Views, ViewModels, Services, Utilities)

**Task 2: Firebase Configuration** ✅ **COMPLETED**
- ✅ Add GoogleService-Info.plist to project
- ✅ Create FirebaseManager singleton class
- ✅ Initialize Firebase in App file
- ✅ Test Firebase connection

**Task 3: Info.plist Configuration** ✅ **COMPLETED**
- ✅ Add location permission descriptions
- ⏸️ Add Sign in with Apple capability (requires paid Apple Developer account - skipped for now)
- ✅ Configure any required background modes

**Task 4: Data Models** ✅ **COMPLETED**
- ✅ Create `CoffeeShopVisit` struct (Codable, Identifiable)
- ✅ Create `WantToGoLocation` struct (Codable, Identifiable)
- ✅ Create `UserProfile` struct for storing user data
- ✅ Add convenience methods for Firestore conversion

**Task 5: Color Scheme & Theme** ✅ **COMPLETED**
- ✅ Define app color palette (coffee theme)
- ✅ Create Color extension with custom colors
- ✅ Create reusable typography styles
- ✅ Set up dark mode support

---

#### **Authentication (Tasks 6-9)** ⚠️ **IMPLEMENTED WITH EMAIL/PASSWORD (NOT APPLE SIGN IN)**

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

#### **Location Services (Tasks 10-12)** ✅ **COMPLETED**

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

#### **Firestore Service (Tasks 13-15)** ✅ **COMPLETED**

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

#### **Add Visit Feature (Tasks 16-20)**

**Task 16: Location Search Component**
- Create `LocationSearchView` (reusable component)
- Text field with real-time search
- Display search results in a List
- Handle result selection (return MKMapItem)
- Add "Use Current Location" button
- Show loading state while searching

**Task 17: Items List Component**
- Create `ItemsListEditor` view (reusable)
- Text field to add new items
- Display added items in a List
- Swipe to delete items
- Return array of strings

**Task 18: Rating Picker Component**
- Create `StarRatingPicker` view (reusable)
- Display 5 stars
- Allow selection of 0.5 increments (half stars)
- Return Double (0.5 - 5.0)
- Visual feedback on selection

**Task 19: Add Visit View**
- Create `AddVisitView`
- Integrate LocationSearchView
- Shop name field (pre-filled from location)
- ItemsListEditor for items
- StarRatingPicker for rating
- Price TextField with $ formatting
- DatePicker (default: today)
- Notes TextEditor (optional)
- Save and Cancel buttons

**Task 20: Add Visit ViewModel**
- Create `AddVisitViewModel`
- Properties for all form fields
- Validation logic (required fields)
- Method: saveVisit() async
- Call VisitService to save to Firestore
- Handle success/error states
- Clear form after successful save

---

#### **Visits List Feature (Tasks 21-24)**

**Task 21: Visit Card Component**
- Create `VisitCardView` (reusable)
- Display: shop name, date, rating (stars), price
- Display: first 2-3 items ordered
- Coffee-themed design
- Tappable to navigate to detail

**Task 22: Visits List View**
- Create `VisitsListView`
- Fetch and display all visits
- Use VisitCardView for each item
- Pull to refresh
- Swipe actions: Edit, Delete
- Empty state (no visits yet)
- Add "+" button to add new visit

**Task 23: Visits List ViewModel**
- Create `VisitsListViewModel`
- Fetch visits from VisitService
- Properties: visits array, isLoading, error
- Methods: loadVisits(), deleteVisit(id:), refreshVisits()
- Sort options (date, rating, name)
- Search/filter functionality

**Task 24: Visit Detail View**
- Create `VisitDetailView`
- Display all visit information (full details)
- Show mini map with location pin
- Display all items ordered
- Edit button (navigate to AddVisitView with data)
- Delete button (with confirmation alert)

---

#### **Map View Feature (Tasks 25-27)**

**Task 25: Custom Map Annotations**
- Create `CoffeeShopAnnotation` class (NSObject, MKAnnotation)
- Properties: coordinate, title, subtitle
- Store visit/wishlist data
- Different identifiers for visited vs wishlist

**Task 26: Map View**
- Create `MapView` using Map from SwiftUI
- Display all visits as pins (one color)
- Display all wishlist items as pins (different color)
- Center on user location
- Tap pin to show callout with shop name and rating
- Tap callout to navigate to detail view

**Task 27: Map View ViewModel & Clustering**
- Create `MapViewModel`
- Fetch visits and wishlist items
- Convert to map annotations
- Implement annotation clustering for performance
- Filter toggles: show visited, show wishlist, show both
- "Zoom to fit all pins" method
- Handle empty state

---

#### **Wishlist Feature (Tasks 28-30)**

**Task 28: Add to Wishlist View**
- Create `AddToWishlistView`
- Reuse LocationSearchView
- Shop name field
- Notes TextEditor
- Save button
- Call WishlistService

**Task 29: Wishlist List View**
- Create `WishlistView`
- Display all wishlist items in List
- Show distance from current location
- Swipe to delete
- Tap to see detail
- Empty state

**Task 30: Wishlist Detail & "Mark as Visited"**
- Create `WishlistDetailView`
- Display location on small map
- Edit notes
- Delete button
- "Mark as Visited" button
  - Opens AddVisitView with location pre-filled
  - Deletes from wishlist after save

---

#### **Profile & Statistics (Tasks 31-33)**

**Task 31: Statistics Calculator**
- Create `StatisticsCalculator` class
- Calculate: total visits, average rating, total spent
- Calculate: favorite item (most frequent)
- Calculate: most visited shop, highest rated shop
- Calculate: most expensive visit, first visit date
- Return as struct with all stats

**Task 32: Profile Statistics ViewModel**
- Create `ProfileViewModel`
- Fetch all visits
- Use StatisticsCalculator to compute stats
- Properties: stats, isLoading
- Real-time updates when data changes

**Task 33: Profile View**
- Create `ProfileView`
- Display user info (name from Apple Sign In)
- Display statistics in cards/grid
- Settings section:
  - Sign out button
  - Subscription status (Free/Premium)
  - Delete account (with confirmation)
  - Privacy policy link
  - Terms link
  - Location usage explanation

---

#### **UI/UX Polish (Tasks 34-35)**

**Task 34: Tab Bar Navigation**
- Create main `TabView` with 4 tabs
- Tab 1: VisitsListView (SF Symbol: "cup.and.saucer.fill")
- Tab 2: MapView (SF Symbol: "map.fill") - add lock icon for free users
- Tab 3: WishlistView (SF Symbol: "star.fill") - add lock icon for free users
- Tab 4: ProfileView (SF Symbol: "person.fill")
- Style tab bar

**Task 35: Premium Paywalls**
- Create `PaywallView` (reusable)
- Show benefits of premium
- "Upgrade" button
- Use on Map tab for free users
- Use on Wishlist tab for free users
- Check subscription status before showing

---

### How to Ask AI for Help

#### Example Prompts:

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
- photoURL: String?

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

**For Task 25 (Map Annotations):**
```
"Create a custom MKAnnotation class for coffee shop locations. It should store 
the visit data and have properties for coordinate, title, and subtitle. Also create 
custom annotation views with different colored pins for visited shops (brown) vs 
wishlist shops (gold)."
```

---

### Tips for AI-Assisted Development

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

### Task Dependencies

Some tasks depend on others:
- Task 20 depends on Tasks 16, 17, 18, 19
- Task 22 depends on Task 21
- Task 26 depends on Task 25
- Task 33 depends on Task 31, 32

Always complete dependencies first!

---

### Estimated Time Per Task
- Setup tasks (1-5): 30-60 min each
- Service tasks (6-15): 45-90 min each  
- UI component tasks (16-35): 30-120 min each

**Total development time: ~40-60 hours** across all 35 tasks



