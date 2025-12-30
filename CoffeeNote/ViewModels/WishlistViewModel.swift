//
//  WishlistViewModel.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import Combine
import CoreLocation
import FirebaseFirestore

/// ViewModel for managing wishlist locations
@MainActor
class WishlistViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var wishlistLocations: [WantToGoLocation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentLocation: CLLocation?

    // MARK: - Private Properties
    private let wishlistService = WishlistService()
    private let locationManager = LocationManager()
    nonisolated(unsafe) private var wishlistListener: ListenerRegistration?

    // MARK: - Initialization
    init() {
        getCurrentLocation()
    }

    deinit {
        stopListening()
    }

    // MARK: - Fetch Data

    /// Start listening for real-time wishlist updates
    func startListening(for userId: String) {
        isLoading = true

        wishlistListener = wishlistService.listenToWishlist(for: userId) { [weak self] wishlist in
            self?.wishlistLocations = wishlist
            self?.isLoading = false
        }
    }

    /// Stop listening for real-time updates
    nonisolated func stopListening() {
        wishlistListener?.remove()
        wishlistListener = nil
    }

    /// Manually refresh wishlist
    func refreshWishlist(for userId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            wishlistLocations = try await wishlistService.fetchWishlist(for: userId)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("❌ Error fetching wishlist: \(error.localizedDescription)")
        }
    }

    /// Delete wishlist location
    func deleteWishlistLocation(_ location: WantToGoLocation) async {
        do {
            try await wishlistService.deleteFromWishlist(locationId: location.id, for: location.userId)
            print("✅ Wishlist location deleted successfully: \(location.shopName)")
        } catch {
            errorMessage = "Failed to delete: \(error.localizedDescription)"
            print("❌ Error deleting wishlist location: \(error.localizedDescription)")
        }
    }

    // MARK: - Location Services

    /// Get current location for distance calculations
    private func getCurrentLocation() {
        Task {
            do {
                currentLocation = try await locationManager.getCurrentLocation()
            } catch {
                print("⚠️ Could not get current location: \(error.localizedDescription)")
            }
        }
    }

    /// Calculate distance from current location to wishlist item
    /// - Parameter location: Wishlist location
    /// - Returns: Distance string (e.g., "2.5 mi away") or nil if location unavailable
    func distanceString(to location: WantToGoLocation) -> String? {
        guard let currentLocation = currentLocation else {
            return nil
        }

        let shopLocation = CLLocation(
            latitude: location.latitude,
            longitude: location.longitude
        )

        let distanceInMeters = currentLocation.distance(from: shopLocation)
        let distanceInMiles = distanceInMeters / 1609.34

        if distanceInMiles < 0.1 {
            return "Nearby"
        } else if distanceInMiles < 1.0 {
            return String(format: "%.1f mi away", distanceInMiles)
        } else {
            return String(format: "%.0f mi away", distanceInMiles)
        }
    }

    // MARK: - Statistics

    /// Total number of wishlist locations
    var totalWishlistItems: Int {
        return wishlistLocations.count
    }
}
