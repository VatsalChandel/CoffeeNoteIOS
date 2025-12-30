//
//  ProfileView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {

    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingSignOutConfirmation = false
    @State private var showingDeleteAccountConfirmation = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {

                    // User Info Header
                    userInfoHeader

                    // Subscription Status
                    subscriptionSection

                    // Statistics Section
                    if let stats = viewModel.statistics {
                        statisticsSection(stats: stats)
                    }

                    // Settings Section
                    settingsSection

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                loadProfile()
            }
            .onDisappear {
                viewModel.stopListening()
            }
            .refreshable {
                await refreshProfile()
            }
            .alert("Sign Out?", isPresented: $showingSignOutConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .alert("Delete Account?", isPresented: $showingDeleteAccountConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    // TODO: Implement account deletion
                }
            } message: {
                Text("This action cannot be undone. All your data will be permanently deleted.")
            }
        }
    }

    // MARK: - Subviews

    private var userInfoHeader: some View {
        VStack(spacing: 12) {
            // Profile Icon
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.coffeeBrown)

            // User Email
            if let email = authViewModel.currentUser?.email {
                Text(email)
                    .font(.sectionHeader)
                    .foregroundColor(.textPrimary)
            }

            // Member Since
            if let stats = viewModel.statistics, let firstVisit = stats.firstVisitDate {
                Text("Tracking coffee since \(firstVisit.formatted(date: .abbreviated, time: .omitted))")
                    .coffeeCaption()
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
    }

    private var subscriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: viewModel.isPremiumUser ? "crown.fill" : "lock.fill")
                    .foregroundColor(viewModel.isPremiumUser ? .coffeeGold : .textSecondary)

                Text(viewModel.isPremiumUser ? "Premium Member" : "Free Tier")
                    .font(.subtitle)
                    .foregroundColor(.textPrimary)

                Spacer()

                if !viewModel.isPremiumUser {
                    Button("Upgrade") {
                        // TODO: Show paywall
                        upgradeToPremium()
                    }
                    .font(.caption)
                    .foregroundColor(.coffeeGold)
                }
            }

            if !viewModel.isPremiumUser {
                Text("Upgrade to unlock Map View, Wishlist, and unlimited visits!")
                    .coffeeCaption()
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(15)
    }

    private func statisticsSection(stats: CoffeeStatistics) -> some View {
        VStack(spacing: 15) {
            Text("Your Coffee Journey")
                .font(.sectionHeader)
                .foregroundColor(.coffeeBrown)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Main Stats Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                StatCard(
                    title: "Total Visits",
                    value: "\(stats.totalVisits)",
                    icon: "cup.and.saucer.fill",
                    color: .coffeeEspresso
                )

                StatCard(
                    title: "Wishlist",
                    value: "\(stats.totalWishlistItems)",
                    icon: "bookmark.fill",
                    color: .coffeeGold
                )

                StatCard(
                    title: "Total Spent",
                    value: "$\(String(format: "%.0f", stats.totalSpent))",
                    icon: "dollarsign.circle.fill",
                    color: .coffeeGreen
                )

                StatCard(
                    title: "Avg Rating",
                    value: String(format: "%.1f", stats.averageRating),
                    icon: "star.fill",
                    color: .coffeeGold
                )
            }

            // Additional Stats
            VStack(spacing: 12) {
                if let favoriteItem = stats.favoriteItem {
                    StatRow(
                        icon: "heart.fill",
                        title: "Favorite Item",
                        value: favoriteItem,
                        color: .coffeeRed
                    )
                }

                if let mostVisited = stats.mostVisitedShop {
                    StatRow(
                        icon: "building.2.fill",
                        title: "Most Visited",
                        value: mostVisited,
                        color: .coffeeBrown
                    )
                }

                if let highestRated = stats.highestRatedShop {
                    StatRow(
                        icon: "star.circle.fill",
                        title: "Highest Rated",
                        value: highestRated,
                        color: .coffeeGold
                    )
                }

                if let mostExpensive = stats.mostExpensiveVisit {
                    StatRow(
                        icon: "banknote.fill",
                        title: "Most Expensive",
                        value: "\(mostExpensive.shopName) • $\(String(format: "%.2f", mostExpensive.price))",
                        color: .coffeeGreen
                    )
                }

                if stats.averagePrice > 0 {
                    StatRow(
                        icon: "chart.bar.fill",
                        title: "Avg Price",
                        value: "$\(String(format: "%.2f", stats.averagePrice))",
                        color: .coffeeGreen
                    )
                }
            }
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(15)
        }
    }

    private var settingsSection: some View {
        VStack(spacing: 0) {
            Text("Settings")
                .font(.sectionHeader)
                .foregroundColor(.coffeeBrown)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                // Location Usage
                SettingsRow(
                    icon: "location.fill",
                    title: "Location Usage",
                    subtitle: "We use your location to help you track and find coffee shops",
                    color: .blue
                )

                Divider()

                // Privacy Policy
                SettingsRow(
                    icon: "hand.raised.fill",
                    title: "Privacy Policy",
                    subtitle: "Learn how we protect your data",
                    color: .purple
                ) {
                    // TODO: Open privacy policy
                }

                Divider()

                // Terms of Service
                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Terms of Service",
                    subtitle: "Read our terms and conditions",
                    color: .orange
                ) {
                    // TODO: Open terms
                }

                Divider()

                // Sign Out
                SettingsRow(
                    icon: "rectangle.portrait.and.arrow.right",
                    title: "Sign Out",
                    subtitle: nil,
                    color: .coffeeRed
                ) {
                    showingSignOutConfirmation = true
                }

                Divider()

                // Delete Account
                SettingsRow(
                    icon: "trash.fill",
                    title: "Delete Account",
                    subtitle: "Permanently delete your account and data",
                    color: .red
                ) {
                    showingDeleteAccountConfirmation = true
                }
            }
            .background(Color.cardBackground)
            .cornerRadius(15)
        }
    }

    // MARK: - Actions

    private func loadProfile() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        viewModel.startListening(for: userId)
    }

    private func refreshProfile() async {
        guard let userId = authViewModel.currentUser?.uid else { return }
        await viewModel.refreshData(for: userId)
    }

    private func signOut() {
        viewModel.signOut()
        authViewModel.signOut()
    }

    private func upgradeToPremium() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        Task {
            await viewModel.upgradeToPremium(userId: userId)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(15)
    }
}

// MARK: - Stat Row
struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.textSecondary)

                Text(value)
                    .font(.bodyText)
                    .foregroundColor(.textPrimary)
            }

            Spacer()
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let color: Color
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.bodyText)
                        .foregroundColor(.textPrimary)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }

                Spacer()

                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding()
        }
        .disabled(action == nil)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
