//
//  CoffeeShopVisit.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import FirebaseFirestore

/// Model representing a single visit to a coffee shop
struct CoffeeShopVisit: Identifiable, Codable {

    // MARK: - Properties
    var id: String
    var userId: String
    var shopName: String
    var address: String
    var latitude: Double
    var longitude: Double
    var placeID: String?
    var itemsOrdered: [String]
    var rating: Double // 0.5 to 5.0 in 0.5 increments
    var price: Double // USD
    var notes: String?
    var dateVisited: Date
    var photoURL: String? // For premium feature

    // MARK: - Initialization
    init(
        id: String = UUID().uuidString,
        userId: String,
        shopName: String,
        address: String,
        latitude: Double,
        longitude: Double,
        placeID: String? = nil,
        itemsOrdered: [String],
        rating: Double,
        price: Double,
        notes: String? = nil,
        dateVisited: Date = Date(),
        photoURL: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.shopName = shopName
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.placeID = placeID
        self.itemsOrdered = itemsOrdered
        self.rating = rating
        self.price = price
        self.notes = notes
        self.dateVisited = dateVisited
        self.photoURL = photoURL
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
            "itemsOrdered": itemsOrdered,
            "rating": rating,
            "price": price,
            "dateVisited": Timestamp(date: dateVisited)
        ]

        if let placeID = placeID {
            dict["placeID"] = placeID
        }

        if let notes = notes {
            dict["notes"] = notes
        }

        if let photoURL = photoURL {
            dict["photoURL"] = photoURL
        }

        return dict
    }

    /// Create from Firestore document
    static func fromDictionary(_ dict: [String: Any]) -> CoffeeShopVisit? {
        guard
            let id = dict["id"] as? String,
            let userId = dict["userId"] as? String,
            let shopName = dict["shopName"] as? String,
            let address = dict["address"] as? String,
            let latitude = dict["latitude"] as? Double,
            let longitude = dict["longitude"] as? Double,
            let itemsOrdered = dict["itemsOrdered"] as? [String],
            let rating = dict["rating"] as? Double,
            let price = dict["price"] as? Double,
            let timestamp = dict["dateVisited"] as? Timestamp
        else {
            return nil
        }

        return CoffeeShopVisit(
            id: id,
            userId: userId,
            shopName: shopName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            placeID: dict["placeID"] as? String,
            itemsOrdered: itemsOrdered,
            rating: rating,
            price: price,
            notes: dict["notes"] as? String,
            dateVisited: timestamp.dateValue(),
            photoURL: dict["photoURL"] as? String
        )
    }
}

// MARK: - Sample Data (for previews and testing)
extension CoffeeShopVisit {
    static let sample = CoffeeShopVisit(
        userId: "test-user",
        shopName: "Blue Bottle Coffee",
        address: "123 Main St, San Francisco, CA",
        latitude: 37.7749,
        longitude: -122.4194,
        itemsOrdered: ["Cappuccino", "Croissant"],
        rating: 4.5,
        price: 12.50,
        notes: "Great atmosphere, friendly baristas"
    )
}
