//
//  WantToGoLocation.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import FirebaseFirestore

/// Model representing a coffee shop the user wants to visit (wishlist)
struct WantToGoLocation: Identifiable, Codable {

    // MARK: - Properties
    var id: String
    var userId: String
    var shopName: String
    var address: String
    var latitude: Double
    var longitude: Double
    var notes: String?
    var dateAdded: Date

    // MARK: - Initialization
    init(
        id: String = UUID().uuidString,
        userId: String,
        shopName: String,
        address: String,
        latitude: Double,
        longitude: Double,
        notes: String? = nil,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.shopName = shopName
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.notes = notes
        self.dateAdded = dateAdded
    }

    // MARK: - Firestore Conversion
    /// Convert to Firestore dictionary
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "userId": userId,
            "shopName": shopName,
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "dateAdded": Timestamp(date: dateAdded)
        ]

        if let notes = notes {
            dict["notes"] = notes
        }

        return dict
    }

    /// Create from Firestore document
    static func fromDictionary(_ dict: [String: Any]) -> WantToGoLocation? {
        guard
            let id = dict["id"] as? String,
            let userId = dict["userId"] as? String,
            let shopName = dict["shopName"] as? String,
            let address = dict["address"] as? String,
            let latitude = dict["latitude"] as? Double,
            let longitude = dict["longitude"] as? Double,
            let timestamp = dict["dateAdded"] as? Timestamp
        else {
            return nil
        }

        return WantToGoLocation(
            id: id,
            userId: userId,
            shopName: shopName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            notes: dict["notes"] as? String,
            dateAdded: timestamp.dateValue()
        )
    }
}

// MARK: - Sample Data (for previews and testing)
extension WantToGoLocation {
    static let sample = WantToGoLocation(
        userId: "test-user",
        shopName: "Sightglass Coffee",
        address: "456 Oak St, San Francisco, CA",
        latitude: 37.7849,
        longitude: -122.4094,
        notes: "Heard they have amazing pour-over coffee"
    )
}
