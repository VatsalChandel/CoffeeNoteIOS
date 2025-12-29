//
//  WishlistService.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import FirebaseFirestore

/// Service to handle CRUD operations for wishlist (want to go) locations
class WishlistService {

    // MARK: - Properties
    private let db = FirebaseManager.shared.firestore

    // MARK: - Collection Path
    private func wishlistCollection(for userId: String) -> CollectionReference {
        return db.collection("users").document(userId).collection("wishlist")
    }

    // MARK: - Create

    /// Add a location to the wishlist
    /// - Parameter location: WantToGoLocation to add
    func addToWishlist(_ location: WantToGoLocation) async throws {
        let collection = wishlistCollection(for: location.userId)
        let data = location.toDictionary()

        try await collection.document(location.id).setData(data)
        print("✅ Added to wishlist: \(location.shopName)")
    }

    // MARK: - Read

    /// Fetch all wishlist items for a user
    /// - Parameter userId: User ID to fetch wishlist for
    /// - Returns: Array of WantToGoLocation
    func fetchWishlist(for userId: String) async throws -> [WantToGoLocation] {
        let collection = wishlistCollection(for: userId)
        let snapshot = try await collection.getDocuments()

        let wishlist = snapshot.documents.compactMap { document -> WantToGoLocation? in
            return WantToGoLocation.fromDictionary(document.data())
        }

        print("✅ Fetched \(wishlist.count) wishlist items for user: \(userId)")
        return wishlist
    }

    /// Fetch a single wishlist item by ID
    /// - Parameters:
    ///   - locationId: Location ID to fetch
    ///   - userId: User ID who owns the wishlist item
    /// - Returns: WantToGoLocation if found
    func fetchWishlistItem(locationId: String, for userId: String) async throws -> WantToGoLocation? {
        let collection = wishlistCollection(for: userId)
        let document = try await collection.document(locationId).getDocument()

        guard let data = document.data() else {
            print("❌ Wishlist item not found: \(locationId)")
            return nil
        }

        return WantToGoLocation.fromDictionary(data)
    }

    /// Listen for real-time updates to wishlist
    /// - Parameters:
    ///   - userId: User ID to listen for
    ///   - completion: Callback with updated wishlist array
    /// - Returns: Listener registration (call .remove() to stop listening)
    func listenToWishlist(for userId: String, completion: @escaping ([WantToGoLocation]) -> Void) -> ListenerRegistration {
        let collection = wishlistCollection(for: userId)

        return collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Error listening to wishlist: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                completion([])
                return
            }

            let wishlist = documents.compactMap { document -> WantToGoLocation? in
                return WantToGoLocation.fromDictionary(document.data())
            }

            print("✅ Real-time update: \(wishlist.count) wishlist items")
            completion(wishlist)
        }
    }

    // MARK: - Update

    /// Update an existing wishlist item
    /// - Parameter location: WantToGoLocation with updated data
    func updateWishlistItem(_ location: WantToGoLocation) async throws {
        let collection = wishlistCollection(for: location.userId)
        let data = location.toDictionary()

        try await collection.document(location.id).setData(data)
        print("✅ Wishlist item updated: \(location.shopName)")
    }

    // MARK: - Delete

    /// Delete a wishlist item
    /// - Parameters:
    ///   - locationId: Location ID to delete
    ///   - userId: User ID who owns the wishlist item
    func deleteFromWishlist(locationId: String, for userId: String) async throws {
        let collection = wishlistCollection(for: userId)
        try await collection.document(locationId).delete()
        print("✅ Wishlist item deleted: \(locationId)")
    }

    // MARK: - Query Methods

    /// Fetch wishlist sorted by date added (newest first)
    /// - Parameter userId: User ID
    /// - Returns: Sorted array of wishlist items
    func fetchWishlistSortedByDate(for userId: String) async throws -> [WantToGoLocation] {
        let collection = wishlistCollection(for: userId)
        let snapshot = try await collection.order(by: "dateAdded", descending: true).getDocuments()

        let wishlist = snapshot.documents.compactMap { document -> WantToGoLocation? in
            return WantToGoLocation.fromDictionary(document.data())
        }

        return wishlist
    }

    /// Count total wishlist items for a user
    /// - Parameter userId: User ID
    /// - Returns: Total number of wishlist items
    func countWishlist(for userId: String) async throws -> Int {
        let wishlist = try await fetchWishlist(for: userId)
        return wishlist.count
    }
}
