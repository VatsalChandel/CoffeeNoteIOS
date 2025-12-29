//
//  UserProfileService.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import FirebaseFirestore

/// Service to handle user profile operations
class UserProfileService {

    // MARK: - Properties
    private let db = FirebaseManager.shared.firestore

    // MARK: - Collection Path
    private var profilesCollection: CollectionReference {
        return db.collection("users")
    }

    // MARK: - Create

    /// Create a new user profile
    /// - Parameters:
    ///   - userId: Firebase user ID
    ///   - email: User's email
    ///   - name: Optional display name
    /// - Returns: Created UserProfile
    func createUserProfile(userId: String, email: String, name: String? = nil) async throws -> UserProfile {
        let profile = UserProfile(
            id: userId,
            email: email,
            name: name,
            subscriptionTier: .free
        )

        let data = profile.toDictionary()
        try await profilesCollection.document(userId).setData(data)

        print("✅ User profile created: \(email)")
        return profile
    }

    // MARK: - Read

    /// Get user profile by ID
    /// - Parameter userId: User ID to fetch
    /// - Returns: UserProfile if found
    func getUserProfile(userId: String) async throws -> UserProfile? {
        let document = try await profilesCollection.document(userId).getDocument()

        guard let data = document.data() else {
            print("❌ User profile not found: \(userId)")
            return nil
        }

        return UserProfile.fromDictionary(data)
    }

    /// Get or create user profile (creates if doesn't exist)
    /// - Parameters:
    ///   - userId: User ID
    ///   - email: User's email (used if creating)
    ///   - name: Optional name (used if creating)
    /// - Returns: UserProfile
    func getOrCreateUserProfile(userId: String, email: String, name: String? = nil) async throws -> UserProfile {
        // Try to fetch existing profile
        if let existingProfile = try await getUserProfile(userId: userId) {
            return existingProfile
        }

        // Create new profile if doesn't exist
        return try await createUserProfile(userId: userId, email: email, name: name)
    }

    /// Listen for real-time updates to user profile
    /// - Parameters:
    ///   - userId: User ID to listen for
    ///   - completion: Callback with updated profile
    /// - Returns: Listener registration (call .remove() to stop listening)
    func listenToUserProfile(userId: String, completion: @escaping (UserProfile?) -> Void) -> ListenerRegistration {
        return profilesCollection.document(userId).addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Error listening to user profile: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }

            let profile = UserProfile.fromDictionary(data)
            print("✅ Real-time update: User profile")
            completion(profile)
        }
    }

    // MARK: - Update

    /// Update user profile
    /// - Parameter profile: UserProfile with updated data
    func updateUserProfile(_ profile: UserProfile) async throws {
        let data = profile.toDictionary()
        try await profilesCollection.document(profile.id).setData(data)
        print("✅ User profile updated: \(profile.email)")
    }

    /// Update user's display name
    /// - Parameters:
    ///   - userId: User ID
    ///   - name: New display name
    func updateDisplayName(userId: String, name: String) async throws {
        try await profilesCollection.document(userId).updateData([
            "name": name
        ])
        print("✅ Display name updated: \(name)")
    }

    /// Update subscription tier
    /// - Parameters:
    ///   - userId: User ID
    ///   - tier: New subscription tier
    func updateSubscriptionTier(userId: String, tier: SubscriptionTier) async throws {
        try await profilesCollection.document(userId).updateData([
            "subscriptionTier": tier.rawValue
        ])
        print("✅ Subscription tier updated: \(tier.rawValue)")
    }

    // MARK: - Delete

    /// Delete user profile
    /// - Parameter userId: User ID to delete
    func deleteUserProfile(userId: String) async throws {
        try await profilesCollection.document(userId).delete()
        print("✅ User profile deleted: \(userId)")
    }

    // MARK: - Subscription Helpers

    /// Check if user has premium subscription
    /// - Parameter userId: User ID to check
    /// - Returns: True if user is premium
    func isPremiumUser(userId: String) async throws -> Bool {
        guard let profile = try await getUserProfile(userId: userId) else {
            return false
        }
        return profile.isPremium
    }

    /// Upgrade user to premium
    /// - Parameter userId: User ID to upgrade
    func upgradeToPremium(userId: String) async throws {
        try await updateSubscriptionTier(userId: userId, tier: .premium)
    }

    /// Downgrade user to free
    /// - Parameter userId: User ID to downgrade
    func downgradeToFree(userId: String) async throws {
        try await updateSubscriptionTier(userId: userId, tier: .free)
    }
}
