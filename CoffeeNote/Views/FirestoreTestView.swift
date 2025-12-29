//
//  FirestoreTestView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import FirebaseAuth

struct FirestoreTestView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var visits: [CoffeeShopVisit] = []
    @State private var wishlist: [WantToGoLocation] = []
    @State private var userProfile: UserProfile?
    @State private var statusMessage: String = ""
    @State private var isLoading: Bool = false

    private let visitService = VisitService()
    private let wishlistService = WishlistService()
    private let profileService = UserProfileService()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Status Message
                    if !statusMessage.isEmpty {
                        Text(statusMessage)
                            .coffeeCaption()
                            .foregroundColor(.coffeeGreen)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(10)
                    }

                    // MARK: - User Profile Section
                    VStack(spacing: 15) {
                        Text("User Profile")
                            .coffeeHeading()

                        if let profile = userProfile {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Email:")
                                        .font(.bodySecondary)
                                        .foregroundColor(.textSecondary)
                                    Text(profile.email)
                                        .font(.bodyText)
                                }

                                HStack {
                                    Text("Subscription:")
                                        .font(.bodySecondary)
                                        .foregroundColor(.textSecondary)
                                    Text(profile.subscriptionTier.rawValue.capitalized)
                                        .font(.bodyText)
                                        .foregroundColor(profile.isPremium ? .coffeeGold : .textPrimary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("No profile loaded")
                                .coffeeCaption()
                        }

                        HStack(spacing: 10) {
                            Button("Create/Load Profile") {
                                createOrLoadProfile()
                            }
                            .buttonStyle(SmallCoffeeButtonStyle())

                            if userProfile?.subscriptionTier == .free {
                                Button("Upgrade to Premium") {
                                    upgradeToPremium()
                                }
                                .buttonStyle(SmallCoffeeButtonStyle(color: .coffeeGold))
                            } else if userProfile?.subscriptionTier == .premium {
                                Button("Downgrade to Free") {
                                    downgradeToFree()
                                }
                                .buttonStyle(SmallCoffeeButtonStyle(color: .coffeeRed))
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)

                    // MARK: - Visits Section
                    VStack(spacing: 15) {
                        Text("Coffee Shop Visits")
                            .coffeeHeading()

                        Text("Total visits: \(visits.count)")
                            .coffeeSubtitle()

                        Button("Create Sample Visit") {
                            createSampleVisit()
                        }
                        .buttonStyle(CoffeeButtonStyle())

                        Button("Fetch All Visits") {
                            fetchVisits()
                        }
                        .buttonStyle(CoffeeButtonStyle())

                        // Display visits
                        if !visits.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Your Visits:")
                                    .font(.subtitle)
                                    .foregroundColor(.coffeeBrown)

                                ForEach(visits) { visit in
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(visit.shopName)
                                            .font(.cardTitle)

                                        HStack {
                                            Text("⭐ \(String(format: "%.1f", visit.rating))")
                                                .coffeeRating()
                                            Spacer()
                                            Text("$\(String(format: "%.2f", visit.price))")
                                                .coffeePrice()
                                        }

                                        Text(visit.itemsOrdered.joined(separator: ", "))
                                            .coffeeCaption()

                                        Button("Delete") {
                                            deleteVisit(visit)
                                        }
                                        .font(.caption)
                                        .foregroundColor(.coffeeRed)
                                    }
                                    .padding()
                                    .background(Color.appBackground)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)

                    // MARK: - Wishlist Section
                    VStack(spacing: 15) {
                        Text("Wishlist")
                            .coffeeHeading()

                        Text("Total wishlist items: \(wishlist.count)")
                            .coffeeSubtitle()

                        Button("Create Sample Wishlist Item") {
                            createSampleWishlistItem()
                        }
                        .buttonStyle(CoffeeButtonStyle())

                        Button("Fetch Wishlist") {
                            fetchWishlist()
                        }
                        .buttonStyle(CoffeeButtonStyle())

                        // Display wishlist
                        if !wishlist.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Your Wishlist:")
                                    .font(.subtitle)
                                    .foregroundColor(.coffeeBrown)

                                ForEach(wishlist) { location in
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(location.shopName)
                                            .font(.cardTitle)

                                        Text(location.address)
                                            .coffeeCaption()

                                        if let notes = location.notes {
                                            Text("Notes: \(notes)")
                                                .font(.bodySecondary)
                                                .italic()
                                        }

                                        Button("Delete") {
                                            deleteWishlistItem(location)
                                        }
                                        .font(.caption)
                                        .foregroundColor(.coffeeRed)
                                    }
                                    .padding()
                                    .background(Color.appBackground)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)

                    if isLoading {
                        ProgressView()
                            .tint(.coffeeBrown)
                    }
                }
                .padding()
            }
            .navigationTitle("Firestore Test")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.appBackground)
        }
        .onAppear {
            createOrLoadProfile()
        }
    }

    // MARK: - User Profile Actions
    private func createOrLoadProfile() {
        guard let user = authViewModel.currentUser else {
            statusMessage = "❌ No authenticated user"
            return
        }

        isLoading = true
        Task {
            do {
                let profile = try await profileService.getOrCreateUserProfile(
                    userId: user.uid,
                    email: user.email ?? "unknown@email.com"
                )
                await MainActor.run {
                    userProfile = profile
                    statusMessage = "✅ Profile loaded"
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    private func upgradeToPremium() {
        guard let userId = authViewModel.currentUser?.uid else { return }

        isLoading = true
        Task {
            do {
                try await profileService.upgradeToPremium(userId: userId)
                await MainActor.run {
                    userProfile?.subscriptionTier = .premium
                    statusMessage = "✅ Upgraded to Premium!"
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    private func downgradeToFree() {
        guard let userId = authViewModel.currentUser?.uid else { return }

        isLoading = true
        Task {
            do {
                try await profileService.downgradeToFree(userId: userId)
                await MainActor.run {
                    userProfile?.subscriptionTier = .free
                    statusMessage = "✅ Downgraded to Free"
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    // MARK: - Visit Actions
    private func createSampleVisit() {
        guard let userId = authViewModel.currentUser?.uid else {
            statusMessage = "❌ No authenticated user"
            return
        }

        let sampleVisit = CoffeeShopVisit(
            userId: userId,
            shopName: "Blue Bottle Coffee",
            address: "123 Main St, San Francisco, CA",
            latitude: 37.7749,
            longitude: -122.4194,
            itemsOrdered: ["Cappuccino", "Croissant"],
            rating: 4.5,
            price: 12.50,
            notes: "Great atmosphere!"
        )

        isLoading = true
        Task {
            do {
                try await visitService.createVisit(sampleVisit)
                await MainActor.run {
                    statusMessage = "✅ Visit created!"
                    isLoading = false
                }
                fetchVisits()
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    private func fetchVisits() {
        guard let userId = authViewModel.currentUser?.uid else {
            statusMessage = "❌ No authenticated user"
            return
        }

        isLoading = true
        Task {
            do {
                let fetchedVisits = try await visitService.fetchVisits(for: userId)
                await MainActor.run {
                    visits = fetchedVisits
                    statusMessage = "✅ Fetched \(fetchedVisits.count) visits"
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    private func deleteVisit(_ visit: CoffeeShopVisit) {
        isLoading = true
        Task {
            do {
                try await visitService.deleteVisit(visitId: visit.id, for: visit.userId)
                await MainActor.run {
                    statusMessage = "✅ Visit deleted"
                    isLoading = false
                }
                fetchVisits()
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    // MARK: - Wishlist Actions
    private func createSampleWishlistItem() {
        guard let userId = authViewModel.currentUser?.uid else {
            statusMessage = "❌ No authenticated user"
            return
        }

        let sampleLocation = WantToGoLocation(
            userId: userId,
            shopName: "Sightglass Coffee",
            address: "456 Oak St, San Francisco, CA",
            latitude: 37.7849,
            longitude: -122.4094,
            notes: "Heard they have amazing pour-over!"
        )

        isLoading = true
        Task {
            do {
                try await wishlistService.addToWishlist(sampleLocation)
                await MainActor.run {
                    statusMessage = "✅ Added to wishlist!"
                    isLoading = false
                }
                fetchWishlist()
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    private func fetchWishlist() {
        guard let userId = authViewModel.currentUser?.uid else {
            statusMessage = "❌ No authenticated user"
            return
        }

        isLoading = true
        Task {
            do {
                let fetchedWishlist = try await wishlistService.fetchWishlist(for: userId)
                await MainActor.run {
                    wishlist = fetchedWishlist
                    statusMessage = "✅ Fetched \(fetchedWishlist.count) wishlist items"
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }

    private func deleteWishlistItem(_ location: WantToGoLocation) {
        isLoading = true
        Task {
            do {
                try await wishlistService.deleteFromWishlist(locationId: location.id, for: location.userId)
                await MainActor.run {
                    statusMessage = "✅ Removed from wishlist"
                    isLoading = false
                }
                fetchWishlist()
            } catch {
                await MainActor.run {
                    statusMessage = "❌ Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Small Button Style
struct SmallCoffeeButtonStyle: ButtonStyle {
    var color: Color = .buttonPrimary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(configuration.isPressed ? color.opacity(0.7) : color)
            .cornerRadius(8)
    }
}

#Preview {
    FirestoreTestView()
        .environmentObject(AuthViewModel())
}
