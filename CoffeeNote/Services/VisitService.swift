//
//  VisitService.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import FirebaseFirestore

/// Service to handle CRUD operations for coffee shop visits
class VisitService {

    // MARK: - Properties
    private let db = FirebaseManager.shared.firestore

    // MARK: - Collection Path
    private func visitsCollection(for userId: String) -> CollectionReference {
        return db.collection("users").document(userId).collection("visits")
    }

    // MARK: - Create

    /// Create a new visit in Firestore
    /// - Parameter visit: CoffeeShopVisit to create
    func createVisit(_ visit: CoffeeShopVisit) async throws {
        let collection = visitsCollection(for: visit.userId)
        let data = visit.toDictionary()

        try await collection.document(visit.id).setData(data)
        print("✅ Visit created: \(visit.shopName)")
    }

    // MARK: - Read

    /// Fetch all visits for a user
    /// - Parameter userId: User ID to fetch visits for
    /// - Returns: Array of CoffeeShopVisit
    func fetchVisits(for userId: String) async throws -> [CoffeeShopVisit] {
        let collection = visitsCollection(for: userId)
        let snapshot = try await collection.getDocuments()

        let visits = snapshot.documents.compactMap { document -> CoffeeShopVisit? in
            return CoffeeShopVisit.fromDictionary(document.data())
        }

        print("✅ Fetched \(visits.count) visits for user: \(userId)")
        return visits
    }

    /// Fetch a single visit by ID
    /// - Parameters:
    ///   - visitId: Visit ID to fetch
    ///   - userId: User ID who owns the visit
    /// - Returns: CoffeeShopVisit if found
    func fetchVisit(visitId: String, for userId: String) async throws -> CoffeeShopVisit? {
        let collection = visitsCollection(for: userId)
        let document = try await collection.document(visitId).getDocument()

        guard let data = document.data() else {
            print("❌ Visit not found: \(visitId)")
            return nil
        }

        return CoffeeShopVisit.fromDictionary(data)
    }

    /// Listen for real-time updates to visits
    /// - Parameters:
    ///   - userId: User ID to listen for
    ///   - completion: Callback with updated visits array
    /// - Returns: Listener registration (call .remove() to stop listening)
    func listenToVisits(for userId: String, completion: @escaping ([CoffeeShopVisit]) -> Void) -> ListenerRegistration {
        let collection = visitsCollection(for: userId)

        return collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Error listening to visits: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                completion([])
                return
            }

            let visits = documents.compactMap { document -> CoffeeShopVisit? in
                return CoffeeShopVisit.fromDictionary(document.data())
            }

            print("✅ Real-time update: \(visits.count) visits")
            completion(visits)
        }
    }

    // MARK: - Update

    /// Update an existing visit
    /// - Parameter visit: CoffeeShopVisit with updated data
    func updateVisit(_ visit: CoffeeShopVisit) async throws {
        let collection = visitsCollection(for: visit.userId)
        let data = visit.toDictionary()

        try await collection.document(visit.id).setData(data)
        print("✅ Visit updated: \(visit.shopName)")
    }

    // MARK: - Delete

    /// Delete a visit
    /// - Parameters:
    ///   - visitId: Visit ID to delete
    ///   - userId: User ID who owns the visit
    func deleteVisit(visitId: String, for userId: String) async throws {
        let collection = visitsCollection(for: userId)
        try await collection.document(visitId).delete()
        print("✅ Visit deleted: \(visitId)")
    }

    // MARK: - Query Methods

    /// Fetch visits sorted by date (newest first)
    /// - Parameter userId: User ID
    /// - Returns: Sorted array of visits
    func fetchVisitsSortedByDate(for userId: String) async throws -> [CoffeeShopVisit] {
        let collection = visitsCollection(for: userId)
        let snapshot = try await collection.order(by: "dateVisited", descending: true).getDocuments()

        let visits = snapshot.documents.compactMap { document -> CoffeeShopVisit? in
            return CoffeeShopVisit.fromDictionary(document.data())
        }

        return visits
    }

    /// Fetch visits sorted by rating (highest first)
    /// - Parameter userId: User ID
    /// - Returns: Sorted array of visits
    func fetchVisitsSortedByRating(for userId: String) async throws -> [CoffeeShopVisit] {
        let collection = visitsCollection(for: userId)
        let snapshot = try await collection.order(by: "rating", descending: true).getDocuments()

        let visits = snapshot.documents.compactMap { document -> CoffeeShopVisit? in
            return CoffeeShopVisit.fromDictionary(document.data())
        }

        return visits
    }

    /// Count total visits for a user
    /// - Parameter userId: User ID
    /// - Returns: Total number of visits
    func countVisits(for userId: String) async throws -> Int {
        let visits = try await fetchVisits(for: userId)
        return visits.count
    }
}
