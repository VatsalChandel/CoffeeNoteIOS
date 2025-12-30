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

/// Identifiable pin for map display
struct MapPin: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
    let type: MapAnnotationType

    // Optional data for detail view
    var visit: CoffeeShopVisit?
    var wishlistLocation: WantToGoLocation?

    // MARK: - Initializers

    /// Create annotation from a visit
    init(visit: CoffeeShopVisit) {
        self.id = visit.id
        self.coordinate = CLLocationCoordinate2D(
            latitude: visit.latitude,
            longitude: visit.longitude
        )
        self.title = visit.shopName
        self.subtitle = "⭐ \(String(format: "%.1f", visit.rating)) • $\(String(format: "%.2f", visit.price))"
        self.type = .visit
        self.visit = visit
        self.wishlistLocation = nil
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
        self.visit = nil
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
