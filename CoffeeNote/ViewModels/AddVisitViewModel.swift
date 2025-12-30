//
//  AddVisitViewModel.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import Combine
import MapKit

/// ViewModel for adding a new coffee shop visit
@MainActor
class AddVisitViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var selectedLocation: MKMapItem?
    @Published var shopName: String = ""
    @Published var address: String = ""
    @Published var itemsOrdered: [String] = []
    @Published var rating: Double = 4.0
    @Published var price: Double = 0.0
    @Published var notes: String = ""
    @Published var dateVisited: Date = Date()

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private let visitService = VisitService()
    private let profileService = UserProfileService()

    // MARK: - Computed Properties

    /// Check if form is valid for submission
    var isValid: Bool {
        return !shopName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !address.trimmingCharacters(in: .whitespaces).isEmpty &&
               !itemsOrdered.isEmpty &&
               rating >= 0.5 &&
               rating <= 5.0 &&
               price >= 0 &&
               !isDateInFuture
    }

    /// Check if selected date is in the future
    var isDateInFuture: Bool {
        return dateVisited > Date()
    }

    // MARK: - Methods

    /// Update form fields from selected location
    func updateFromLocation(_ location: MKMapItem) {
        shopName = location.name ?? ""
        address = location.formattedAddress ?? ""
    }

    /// Save the visit to Firestore
    /// - Parameter userId: Current user's ID
    /// - Returns: True if successful
    func saveVisit(userId: String) async -> Bool {
        // Check for future date first
        if isDateInFuture {
            errorMessage = "You can't log a visit in the future!"
            return false
        }

        // Validate
        guard isValid else {
            errorMessage = "Please fill in all required fields"
            return false
        }

        // Get coordinates from selected location
        guard let location = selectedLocation else {
            errorMessage = "Please select a location"
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            // Check subscription status and visit limit for free users
            let userProfile = try await profileService.getUserProfile(userId: userId)

            if userProfile?.subscriptionTier == .free {
                // Count existing visits
                let existingVisits = try await visitService.fetchVisits(for: userId)

                // Free tier limit: 10 shops
                if existingVisits.count >= 10 {
                    errorMessage = "You've reached the 10 shop limit for free users. Upgrade to Premium for unlimited visits!"
                    isLoading = false
                    return false
                }
            }

            // Create visit object
            let visit = CoffeeShopVisit(
                userId: userId,
                shopName: shopName,
                address: address,
                latitude: location.placemark.coordinate.latitude,
                longitude: location.placemark.coordinate.longitude,
                placeID: nil, // MKMapItem doesn't provide a placeID easily
                itemsOrdered: itemsOrdered,
                rating: rating,
                price: price,
                notes: notes.isEmpty ? nil : notes,
                dateVisited: dateVisited
            )

            // Save to Firestore
            try await visitService.createVisit(visit)

            isLoading = false
            print("✅ Visit saved successfully")
            return true

        } catch {
            errorMessage = "Failed to save visit: \(error.localizedDescription)"
            isLoading = false
            print("❌ Error saving visit: \(error.localizedDescription)")
            return false
        }
    }

    /// Reset form to default values
    func reset() {
        selectedLocation = nil
        shopName = ""
        address = ""
        itemsOrdered = []
        rating = 4.0
        price = 0.0
        notes = ""
        dateVisited = Date()
        errorMessage = nil
    }
}
