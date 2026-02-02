//
//  MapAnnotation.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import MapKit

/// Type of location annotation
enum MapAnnotationType {
    case visit
    case wishlist
}

/// Identifiable pin for map display - can represent multiple visits to the same shop
struct MapPin: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
    let type: MapAnnotationType

    // Optional data for detail view
    var visits: [CoffeeShopVisit] = [] // Changed from single visit to array
    var wishlistLocation: WantToGoLocation?

    // MARK: - Computed Properties
    
    /// Number of visits to this location
    var visitCount: Int {
        visits.count
    }
    
    /// Average rating across all visits
    var averageRating: Double {
        guard !visits.isEmpty else { return 0 }
        let sum = visits.reduce(0.0) { $0 + $1.rating }
        return sum / Double(visits.count)
    }
    
    /// Average price across all visits
    var averagePrice: Double {
        guard !visits.isEmpty else { return 0 }
        let sum = visits.reduce(0.0) { $0 + $1.price }
        return sum / Double(visits.count)
    }
    
    /// Most recent visit
    var mostRecentVisit: CoffeeShopVisit? {
        visits.max(by: { $0.dateVisited < $1.dateVisited })
    }

    // MARK: - Initializers

    /// Create annotation from multiple visits to the same shop
    init(visits: [CoffeeShopVisit]) {
        guard let firstVisit = visits.first else {
            fatalError("Cannot create MapPin with empty visits array")
        }
        
        // Use a consistent ID based on location (group by shop)
        let locationKey = "\(firstVisit.latitude)_\(firstVisit.longitude)"
        self.id = firstVisit.placeID ?? locationKey
        
        self.coordinate = CLLocationCoordinate2D(
            latitude: firstVisit.latitude,
            longitude: firstVisit.longitude
        )
        self.title = firstVisit.shopName
        
        // Subtitle changes based on number of visits
        if visits.count > 1 {
            let avgRating = visits.reduce(0.0) { $0 + $1.rating } / Double(visits.count)
            let avgPrice = visits.reduce(0.0) { $0 + $1.price } / Double(visits.count)
            self.subtitle = "\(visits.count) visits • ⭐ \(String(format: "%.1f", avgRating)) • $\(String(format: "%.2f", avgPrice))"
        } else {
            self.subtitle = "⭐ \(String(format: "%.1f", firstVisit.rating)) • $\(String(format: "%.2f", firstVisit.price))"
        }
        
        self.type = .visit
        self.visits = visits.sorted(by: { $0.dateVisited > $1.dateVisited }) // Sort by most recent first
        self.wishlistLocation = nil
    }
    
    /// Create annotation from a single visit (convenience)
    init(visit: CoffeeShopVisit) {
        self.init(visits: [visit])
    }

    /// Create annotation from a wishlist location
    init(wishlistLocation: WantToGoLocation) {
        self.id = wishlistLocation.id
        self.coordinate = CLLocationCoordinate2D(
            latitude: wishlistLocation.latitude,
            longitude: wishlistLocation.longitude
        )
        self.title = wishlistLocation.shopName
        self.subtitle = "Want to visit"
        self.type = .wishlist
        self.visits = []
        self.wishlistLocation = wishlistLocation
    }
}

// MARK: - Hashable Conformance
extension MapPin: Hashable {
    static func == (lhs: MapPin, rhs: MapPin) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
