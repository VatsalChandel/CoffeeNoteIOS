# Map View Enhancement - Multiple Visits Per Shop

## Summary
Updated the Coffee Map to intelligently group multiple visits to the same coffee shop location. When a user visits the same shop multiple times, the map now shows:
- A single pin with a badge indicating the number of visits
- Aggregated statistics (average rating, average price) in the subtitle
- A detailed view listing all visits chronologically

## Changes Made

### 1. MapAnnotation.swift
**Key Changes:**
- Changed `visit: CoffeeShopVisit?` to `visits: [CoffeeShopVisit]` (array of visits)
- Added computed properties:
  - `visitCount`: Number of visits to this location
  - `averageRating`: Average rating across all visits
  - `averagePrice`: Average price across all visits
  - `mostRecentVisit`: Most recent visit to the location
- Updated initializer to group visits by location using `placeID` or coordinates
- Modified subtitle to show visit count and averages when there are multiple visits

### 2. MapViewModel.swift
**Key Changes:**
- Added `groupVisitsByLocation()` method that:
  - Groups visits by `placeID` if available (most accurate)
  - Falls back to grouping by rounded coordinates + shop name (~50 meter precision)
- Updated `updateAnnotations()` to use grouped visits instead of individual visits

### 3. CoffeeMapView.swift
**Key Changes:**
- Changed `@State private var selectedVisit` to `selectedMapPin`
- Updated sheet presentation to show `ShopVisitsDetailView` instead of `VisitDetailView`
- Enhanced `AnnotationView` to show a red badge with visit count when > 1 visit
- Updated `handleAnnotationTap()` to pass the entire MapPin object

### 4. ShopVisitsDetailView.swift (NEW FILE)
**Features:**
- Shows coffee shop header with name, address, and total visit count
- Displays aggregate statistics (average rating, average price) when multiple visits exist
- Lists all visits in chronological order (most recent first) with:
  - Date badge (Month, Day, Year)
  - Items ordered
  - Individual rating and price
  - Notes preview
- Tapping any visit row opens the full `VisitDetailView` for that specific visit

## User Experience

### Single Visit
When a shop has only 1 visit:
```
[Coffee Shop Pin]
Shop Name
⭐ 4.5 • $12.50
```
Tapping shows the visit details directly.

### Multiple Visits
When a shop has multiple visits:
```
[Coffee Shop Pin with "3" badge]
Shop Name
3 visits • ⭐ 4.3 • $11.25
```
Tapping shows:
1. Shop header with total visits
2. Average statistics cards
3. List of all visits sorted by date
4. Each visit is tappable for full details

## Benefits
✅ Cleaner map with less pin clutter
✅ Easy to see frequently visited shops
✅ Quick overview of overall experience at each shop
✅ Still maintains access to individual visit details
✅ Intelligent grouping handles shops with/without placeID

## Technical Notes
- Grouping by `placeID` when available ensures accuracy
- Fallback coordinate-based grouping uses ~50 meter precision (0.001° ≈ 111m)
- Visits are sorted chronologically (most recent first)
- All existing visit detail functionality is preserved
