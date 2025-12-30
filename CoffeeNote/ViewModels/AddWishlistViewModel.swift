//
//  AddWishlistViewModel.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import Combine
import MapKit

/// ViewModel for adding a location to the wishlist
@MainActor
class AddWishlistViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var selectedLocation: MKMapItem?
    @Published var shopName: String = ""
    @Published var address: String = ""
    @Published var notes: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private let wishlistService = WishlistService()

    // MARK: - Computed Properties

    /// Check if form is valid for submission
    var isValid: Bool {
        return !shopName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !address.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Methods

    /// Update form fields from selected location
    func updateFromLocation(_ location: MKMapItem) {
        shopName = location.name ?? ""
        address = location.formattedAddress ?? ""
    }

    /// Save the wishlist location to Firestore
    /// - Parameter userId: Current user's ID
    /// - Returns: True if successful
    func saveWishlistLocation(userId: String) async -> Bool {
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
            // Create wishlist location object
            let wishlistLocation = WantToGoLocation(
                userId: userId,
                shopName: shopName,
                address: address,
                latitude: location.placemark.coordinate.latitude,
                longitude: location.placemark.coordinate.longitude,
                notes: notes.isEmpty ? nil : notes
            )

            // Save to Firestore
            try await wishlistService.addToWishlist(location: wishlistLocation)

            isLoading = false
            print("✅ Wishlist location saved successfully")
            return true

        } catch {
            errorMessage = "Failed to save wishlist location: \(error.localizedDescription)"
            isLoading = false
            print("❌ Error saving wishlist location: \(error.localizedDescription)")
            return false
        }
    }

    /// Reset form to default values
    func reset() {
        selectedLocation = nil
        shopName = ""
        address = ""
        notes = ""
        errorMessage = nil
    }
}
