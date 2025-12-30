# CoffeeNote ☕

A beautiful iOS app for coffee enthusiasts to track their coffee shop visits, discover new cafes, and maintain a wishlist of places to explore.

## Overview

CoffeeNote is a SwiftUI-based iOS application that helps coffee lovers:
- **Track visits** to coffee shops with ratings, prices, and notes
- **Explore locations** on an interactive map view
- **Save wishlist items** for cafes they want to visit
- **View statistics** about their coffee journey
- **Upgrade to Premium** for unlimited tracking and advanced features

## Features

### 🏪 Visit Tracking
- Log coffee shop visits with detailed information
- Rate your experience (1-5 stars)
- Track items ordered and prices paid
- Add photos and notes (photos coming soon)
- Search and sort your visit history
- View comprehensive statistics

### 🗺️ Interactive Map (Premium)
- See all visited coffee shops on a map
- View wishlist locations nearby
- Toggle between visits and wishlist pins
- "Center on Me" for quick location finding
- Custom pin styles for different location types

### 🔖 Wishlist (Premium)
- Save coffee shops you want to visit
- Add notes about why you want to visit
- View distance to each location
- Mark wishlist items as visited (auto-creates visit entry)
- Track when locations were added

### 📊 Statistics & Profile
- Total visits and spending
- Average ratings across all visits
- Favorite items ordered
- Most visited shops
- Subscription status and management

### 💎 Freemium Model
- **Free Tier**: Track up to 10 coffee shops
- **Premium**: Unlimited visits, map view, wishlist, and more
- Visual indicators for free tier limits
- Seamless upgrade flow

## Tech Stack

### Core Technologies
- **SwiftUI**: Modern declarative UI framework
- **Firebase Authentication**: Email/password authentication
- **Firebase Firestore**: Real-time NoSQL database
- **MapKit**: Location search and map visualization
- **CoreLocation**: User location services

### Architecture
- **MVVM Pattern**: Clean separation of concerns
- **@MainActor**: UI updates on main thread
- **Combine**: Reactive data flow
- **Async/await**: Modern concurrency

### Key Features
- Real-time listeners for live data updates
- Location caching for performance
- Pre-loaded view models for instant forms
- Adaptive colors for dark mode support
- Search and filtering capabilities

## Project Structure

```
CoffeeNote/
├── Models/              # Data models
│   ├── CoffeeShopVisit.swift
│   ├── WantToGoLocation.swift
│   ├── UserProfile.swift
│   └── MapPin.swift
├── Views/               # SwiftUI views
│   ├── VisitsListView.swift
│   ├── AddVisitView.swift
│   ├── VisitDetailView.swift
│   ├── CoffeeMapView.swift
│   ├── WishlistView.swift
│   ├── AddToWishlistView.swift
│   ├── WishlistDetailView.swift
│   ├── ProfileView.swift
│   ├── PaywallView.swift
│   ├── MainTabView.swift
│   └── Components/      # Reusable UI components
├── ViewModels/          # Business logic
│   ├── VisitsListViewModel.swift
│   ├── AddVisitViewModel.swift
│   ├── MapViewModel.swift
│   ├── WishlistViewModel.swift
│   ├── AddWishlistViewModel.swift
│   ├── ProfileViewModel.swift
│   └── AuthViewModel.swift
├── Services/            # Backend integration
│   ├── VisitService.swift
│   ├── WishlistService.swift
│   ├── UserProfileService.swift
│   └── LocationManager.swift
└── Utilities/           # Helpers and extensions
    ├── ColorExtension.swift
    ├── FontExtension.swift
    └── StatisticsCalculator.swift
```

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 18.0 or later
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd CoffeeNote
   ```

2. **Install Firebase**
   - Create a new Firebase project at [firebase.google.com](https://firebase.google.com)
   - Enable Authentication (Email/Password)
   - Create a Firestore database
   - Download `GoogleService-Info.plist`
   - Add it to the project root

3. **Configure Info.plist**
   Add the following keys:
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>We need your location to show nearby coffee shops and calculate distances.</string>
   ```

4. **Install Dependencies**
   - Open `CoffeeNote.xcodeproj` in Xcode
   - Firebase packages should auto-resolve via Swift Package Manager
   - Required packages:
     - FirebaseAuth
     - FirebaseFirestore

5. **Build and Run**
   - Select a simulator or device
   - Press Cmd+R to build and run

## Firestore Structure

### Collections

**users/{userId}**
```json
{
  "email": "user@example.com",
  "subscriptionTier": "free" | "premium",
  "createdAt": "2024-12-28T10:00:00Z"
}
```

**users/{userId}/visits/{visitId}**
```json
{
  "shopName": "Blue Bottle Coffee",
  "address": "123 Main St, San Francisco, CA",
  "latitude": 37.7749,
  "longitude": -122.4194,
  "itemsOrdered": ["Cappuccino", "Croissant"],
  "rating": 5,
  "price": 12.50,
  "dateVisited": "2024-12-28T10:00:00Z",
  "notes": "Amazing latte art!",
  "createdAt": "2024-12-28T10:00:00Z"
}
```

**users/{userId}/wishlist/{locationId}**
```json
{
  "shopName": "Sightglass Coffee",
  "address": "456 Valencia St, San Francisco, CA",
  "latitude": 37.7599,
  "longitude": -122.4148,
  "notes": "Want to try their single origin pour over",
  "dateAdded": "2024-12-28T10:00:00Z"
}
```

## Performance Optimizations

- **Pre-loaded View Models**: Forms open instantly by initializing view models in the background
- **Location Caching**: User location cached for 5 minutes to reduce GPS queries
- **Real-time Listeners**: Efficient Firestore listeners with proper cleanup
- **Lazy Loading**: LazyVStack for efficient list rendering
- **Optimized TextEditors**: `.scrollContentBackground(.hidden)` for better performance

## Premium Features

Free users can track up to **10 coffee shops**. Premium unlocks:
- ✅ Unlimited coffee shop visits
- ✅ Interactive map view
- ✅ Wishlist functionality
- ✅ Photo uploads (coming soon)

**Pricing**: $2.99/month or $9.99 one-time payment

## Future Enhancements

- [ ] Photo uploads for visits
- [ ] Social sharing features
- [ ] Coffee brewing timer
- [ ] Tasting notes templates
- [ ] Export data to CSV
- [ ] Widget support
- [ ] Apple Sign In integration

## License

This project is a demo application for educational purposes.

## Contact

For questions or feedback, please open an issue on GitHub.

---

**Made with ☕ and SwiftUI**
