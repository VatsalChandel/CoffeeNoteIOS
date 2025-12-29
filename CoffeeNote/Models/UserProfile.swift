//
//  UserProfile.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import FirebaseFirestore

/// Subscription tier for the user
enum SubscriptionTier: String, Codable {
    case free = "free"
    case premium = "premium"
}

/// Model representing a user's profile information
struct UserProfile: Identifiable, Codable {

    // MARK: - Properties
    var id: String // Firebase user ID
    var email: String
    var name: String?
    var subscriptionTier: SubscriptionTier
    var dateCreated: Date

    // MARK: - Initialization
    init(
        id: String,
        email: String,
        name: String? = nil,
        subscriptionTier: SubscriptionTier = .free,
        dateCreated: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.subscriptionTier = subscriptionTier
        self.dateCreated = dateCreated
    }

    // MARK: - Computed Properties
    var isPremium: Bool {
        return subscriptionTier == .premium
    }

    var displayName: String {
        return name ?? email
    }

    // MARK: - Firestore Conversion
    /// Convert to Firestore dictionary
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "email": email,
            "subscriptionTier": subscriptionTier.rawValue,
            "dateCreated": Timestamp(date: dateCreated)
        ]

        if let name = name {
            dict["name"] = name
        }

        return dict
    }

    /// Create from Firestore document
    static func fromDictionary(_ dict: [String: Any]) -> UserProfile? {
        guard
            let id = dict["id"] as? String,
            let email = dict["email"] as? String,
            let subscriptionTierString = dict["subscriptionTier"] as? String,
            let subscriptionTier = SubscriptionTier(rawValue: subscriptionTierString),
            let timestamp = dict["dateCreated"] as? Timestamp
        else {
            return nil
        }

        return UserProfile(
            id: id,
            email: email,
            name: dict["name"] as? String,
            subscriptionTier: subscriptionTier,
            dateCreated: timestamp.dateValue()
        )
    }
}

// MARK: - Sample Data (for previews and testing)
extension UserProfile {
    static let sample = UserProfile(
        id: "test-user-123",
        email: "coffee.lover@example.com",
        name: "Coffee Lover",
        subscriptionTier: .free
    )

    static let premiumSample = UserProfile(
        id: "premium-user-456",
        email: "premium@example.com",
        name: "Premium User",
        subscriptionTier: .premium
    )
}
