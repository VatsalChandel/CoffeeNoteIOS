//
//  ProfileViewModel.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import Combine
import FirebaseFirestore

/// ViewModel for managing profile and statistics
@MainActor
class ProfileViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var statistics: CoffeeStatistics?
    @Published var userProfile: UserProfile?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var visits: [CoffeeShopVisit] = []
    private var wishlistItems: [WantToGoLocation] = []
    private let visitService = VisitService()
    private let wishlistService = WishlistService()
    private let profileService = UserProfileService()
    nonisolated(unsafe) private var visitListener: ListenerRegistration?
    nonisolated(unsafe) private var wishlistListener: ListenerRegistration?

    // MARK: - Initialization
    deinit {
        stopListening()
    }

    // MARK: - Data Loading

    /// Start listening for real-time updates to visits and wishlist
    func startListening(for userId: String) {
        isLoading = true
        loadUserProfile(for: userId)

        // Listen to visits
        visitListener = visitService.listenToVisits(for: userId) { [weak self] visits in
            self?.visits = visits
            self?.updateStatistics()
            self?.isLoading = false
        }

        // Listen to wishlist
        wishlistListener = wishlistService.listenToWishlist(for: userId) { [weak self] wishlist in
            self?.wishlistItems = wishlist
            self?.updateStatistics()
        }
    }

    /// Stop listening for real-time updates
    nonisolated func stopListening() {
        visitListener?.remove()
        wishlistListener?.remove()
        visitListener = nil
        wishlistListener = nil
    }

    /// Manually refresh data
    func refreshData(for userId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            async let visitsResult = visitService.fetchVisits(for: userId)
            async let wishlistResult = wishlistService.fetchWishlist(for: userId)

            let (fetchedVisits, fetchedWishlist) = try await (visitsResult, wishlistResult)

            visits = fetchedVisits
            wishlistItems = fetchedWishlist
            updateStatistics()
            await loadUserProfile(for: userId)

            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("❌ Error refreshing profile data: \(error.localizedDescription)")
        }
    }

    // MARK: - Statistics

    /// Update statistics based on current visits and wishlist
    private func updateStatistics() {
        statistics = StatisticsCalculator.calculateStatistics(
            visits: visits,
            wishlistItems: wishlistItems
        )
    }

    // MARK: - User Profile

    /// Load user profile from Firestore
    private func loadUserProfile(for userId: String) {
        Task {
            do {
                userProfile = try await profileService.getUserProfile(userId: userId)
            } catch {
                print("❌ Error loading user profile: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Subscription Management

    /// Check if user has premium subscription
    var isPremiumUser: Bool {
        return userProfile?.subscriptionTier == .premium
    }

    /// Upgrade user to premium
    func upgradeToPremium(userId: String) async {
        do {
            try await profileService.upgradeToPremium(userId: userId)
            await loadUserProfile(for: userId)
            print("✅ Upgraded to premium")
        } catch {
            errorMessage = "Failed to upgrade: \(error.localizedDescription)"
            print("❌ Error upgrading to premium: \(error.localizedDescription)")
        }
    }

    // MARK: - Account Management

    /// Sign out the user
    func signOut() {
        stopListening()
        visits = []
        wishlistItems = []
        statistics = nil
        userProfile = nil
    }
}
