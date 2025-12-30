//
//  VisitsListView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import FirebaseAuth

struct VisitsListView: View {

    @StateObject private var viewModel = VisitsListViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedVisit: CoffeeShopVisit?
    @State private var showAddVisit = false
    @State private var showSortOptions = false
    @State private var showLimitReachedAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                if viewModel.isLoading && viewModel.visits.isEmpty {
                    // Initial loading
                    ProgressView()
                        .tint(.coffeeBrown)
                } else if viewModel.visits.isEmpty {
                    // Empty state
                    emptyStateView
                } else {
                    // List of visits
                    visitsList
                }
            }
            .navigationTitle("My Visits")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    sortButton
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .searchable(text: $viewModel.searchQuery, prompt: "Search visits...")
            .sheet(isPresented: $showAddVisit) {
                if canAddMoreVisits {
                    AddVisitView()
                        .environmentObject(authViewModel)
                } else {
                    VisitLimitPaywallView()
                        .environmentObject(authViewModel)
                }
            }
            .sheet(item: $selectedVisit) { visit in
                VisitDetailView(visit: visit)
                    .environmentObject(authViewModel)
            }
            .confirmationDialog("Sort By", isPresented: $showSortOptions) {
                ForEach(VisitsListViewModel.SortOption.allCases, id: \.self) { option in
                    Button(option.rawValue) {
                        viewModel.sortOption = option
                    }
                }
            }
            .onAppear {
                loadVisits()
                loadProfile()
            }
            .onDisappear {
                viewModel.stopListening()
                profileViewModel.stopListening()
            }
        }
    }

    // MARK: - Computed Properties

    private var canAddMoreVisits: Bool {
        // Premium users can always add more
        if profileViewModel.isPremiumUser {
            return true
        }

        // Free users: check if under limit (10 shops)
        return viewModel.totalVisits < 10
    }

    // MARK: - Subviews

    private var visitsList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                // Stats Header
                statsHeader

                // Free Tier Limit Indicator
                if !profileViewModel.isPremiumUser {
                    freeTierLimitIndicator
                }

                // Visits
                ForEach(viewModel.filteredVisits) { visit in
                    Button(action: {
                        selectedVisit = visit
                    }) {
                        VisitCardView(visit: visit)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(role: .destructive) {
                            deleteVisit(visit)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await refreshVisits()
        }
    }

    private var statsHeader: some View {
        HStack(spacing: 20) {
            StatBubble(
                title: "Total",
                value: "\(viewModel.totalVisits)",
                icon: "cup.and.saucer.fill"
            )

            StatBubble(
                title: "Spent",
                value: "$\(String(format: "%.0f", viewModel.totalSpent))",
                icon: "dollarsign.circle.fill"
            )

            StatBubble(
                title: "Avg Rating",
                value: String(format: "%.1f", viewModel.averageRating),
                icon: "star.fill"
            )
        }
        .padding(.bottom, 5)
    }

    private var freeTierLimitIndicator: some View {
        // Free tier limit: 10 shops
        let remaining = max(0, 10 - viewModel.totalVisits)
        let isNearLimit = remaining <= 2
        let atLimit = remaining == 0

        return HStack(spacing: 12) {
            Image(systemName: atLimit ? "exclamationmark.triangle.fill" : "info.circle.fill")
                .foregroundColor(atLimit ? .coffeeRed : (isNearLimit ? .orange : .blue))

            VStack(alignment: .leading, spacing: 4) {
                Text(atLimit ? "Visit Limit Reached" : "Free Tier: \(remaining) visits remaining")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)

                if atLimit {
                    Text("Upgrade to Premium for unlimited visits")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                } else {
                    Text("Upgrade to Premium to track unlimited coffee shops")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }

            Spacer()

            if atLimit || isNearLimit {
                Button("Upgrade") {
                    // Navigate to Profile tab to upgrade
                }
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.coffeeGold)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            atLimit ? Color.coffeeRed.opacity(0.1) :
            (isNearLimit ? Color.orange.opacity(0.1) : Color.blue.opacity(0.1))
        )
        .cornerRadius(12)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cup.and.saucer")
                .font(.system(size: 80))
                .foregroundColor(.textSecondary.opacity(0.5))

            Text("No Visits Yet")
                .font(.sectionHeader)
                .foregroundColor(.textPrimary)

            Text("Start tracking your coffee adventures!")
                .coffeeSubtitle()

            Button(action: {
                showAddVisit = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Your First Visit")
                }
                .font(.button)
                .foregroundColor(.white)
                .padding()
                .background(Color.buttonPrimary)
                .cornerRadius(10)
            }
        }
        .padding()
    }

    private var sortButton: some View {
        Button(action: {
            showSortOptions = true
        }) {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundColor(.coffeeBrown)
        }
    }

    private var addButton: some View {
        Button(action: {
            showAddVisit = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(.coffeeBrown)
        }
    }

    // MARK: - Actions

    private func loadVisits() {
        guard let userId = authViewModel.currentUser?.uid else { return }

        // Start real-time listening
        viewModel.startListening(for: userId)
    }

    private func loadProfile() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        profileViewModel.startListening(for: userId)
    }

    private func refreshVisits() async {
        guard let userId = authViewModel.currentUser?.uid else { return }
        await viewModel.fetchVisits(for: userId)
    }

    private func deleteVisit(_ visit: CoffeeShopVisit) {
        Task {
            await viewModel.deleteVisit(visit)
        }
    }
}

// MARK: - Visit Limit Paywall
struct VisitLimitPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isUpgrading = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.coffeeRed.opacity(0.1), Color.coffeeGold.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    // Warning Icon
                    ZStack {
                        Circle()
                            .fill(Color.coffeeRed.opacity(0.2))
                            .frame(width: 120, height: 120)

                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.coffeeRed)
                    }

                    // Title
                    VStack(spacing: 8) {
                        Text("Visit Limit Reached")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)

                        Text("You've tracked 10 coffee shops")
                            .font(.subtitle)
                            .foregroundColor(.textSecondary)
                    }

                    // Message
                    Text("Free users can track up to 10 coffee shops. Upgrade to Premium to track unlimited visits and unlock all features!")
                        .font(.bodyText)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    // Premium Features
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureCheckmark(text: "Unlimited coffee shop visits")
                        FeatureCheckmark(text: "Interactive map view")
                        FeatureCheckmark(text: "Wishlist to track places you want to visit")
                        FeatureCheckmark(text: "Photo uploads (Coming Soon)")
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .padding(.horizontal)

                    // Upgrade Button
                    if isUpgrading {
                        ProgressView()
                            .tint(.white)
                            .padding()
                    } else {
                        Button(action: upgradeToPremium) {
                            HStack {
                                Image(systemName: "crown.fill")
                                Text("Upgrade to Premium")
                            }
                            .font(.button)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.coffeeGold, Color.coffeeGold.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: Color.coffeeGold.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
            }
            .navigationTitle("Upgrade Required")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.coffeeBrown)
                }
            }
        }
    }

    private func upgradeToPremium() {
        guard let userId = authViewModel.currentUser?.uid else { return }

        isUpgrading = true

        Task {
            do {
                let profileService = UserProfileService()
                try await profileService.upgradeToPremium(userId: userId)
                print("✅ Upgraded to premium")

                try await Task.sleep(nanoseconds: 500_000_000)
                isUpgrading = false
                dismiss()
            } catch {
                print("❌ Error upgrading: \(error.localizedDescription)")
                isUpgrading = false
            }
        }
    }
}

// MARK: - Feature Checkmark
struct FeatureCheckmark: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.coffeeGreen)
                .font(.title3)

            Text(text)
                .font(.bodyText)
                .foregroundColor(.textPrimary)

            Spacer()
        }
    }
}

// MARK: - Stat Bubble Component
struct StatBubble: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.coffeeBrown)

            Text(value)
                .font(.cardTitle)
                .foregroundColor(.textPrimary)

            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    VisitsListView()
        .environmentObject(AuthViewModel())
}
