//
//  PaywallView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import FirebaseAuth

struct PaywallView: View {

    let feature: String
    let icon: String
    let benefits: [String]

    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isUpgrading = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.coffeeBrown.opacity(0.1), Color.coffeeGold.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        Spacer(minLength: 40)

                        // Lock Icon
                        ZStack {
                            Circle()
                                .fill(Color.coffeeGold.opacity(0.2))
                                .frame(width: 120, height: 120)

                            Image(systemName: "lock.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.coffeeGold)
                        }

                        // Title
                        VStack(spacing: 8) {
                            Text("\(feature) is Premium")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.center)

                            Text("Upgrade to unlock this feature")
                                .font(.subtitle)
                                .foregroundColor(.textSecondary)
                        }

                        // Benefits List
                        VStack(spacing: 16) {
                            ForEach(benefits, id: \.self) { benefit in
                                BenefitRow(text: benefit)
                            }
                        }
                        .padding(.horizontal)

                        // Premium Features
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Premium Includes:")
                                .font(.headline)
                                .foregroundColor(.textPrimary)

                            FeatureRow(icon: "map.fill", title: "Interactive Map", description: "See all your coffee shops on a map")
                            FeatureRow(icon: "bookmark.fill", title: "Wishlist", description: "Track places you want to visit")
                            FeatureRow(icon: "infinity", title: "Unlimited Visits", description: "No 10 shop limit")
                            FeatureRow(icon: "photo.fill", title: "Photo Uploads", description: "Add photos to your visits (Coming Soon)")
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(15)
                        .padding(.horizontal)

                        // Pricing
                        VStack(spacing: 12) {
                            Text("Just $2.99/month")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.coffeeGold)

                            Text("or $9.99 one-time payment")
                                .font(.subtitle)
                                .foregroundColor(.textSecondary)
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

                        // Disclaimer
                        Text("Note: This is a demo app. Premium upgrade is for testing purposes only.")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle(feature)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Actions

    private func upgradeToPremium() {
        guard let userId = authViewModel.currentUser?.uid else { return }

        isUpgrading = true

        Task {
            do {
                let profileService = UserProfileService()
                try await profileService.upgradeToPremium(userId: userId)
                print("✅ Upgraded to premium")

                // Delay to show success, then the view will automatically update
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                isUpgrading = false
            } catch {
                print("❌ Error upgrading: \(error.localizedDescription)")
                isUpgrading = false
            }
        }
    }
}

// MARK: - Benefit Row
struct BenefitRow: View {
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
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.coffeeGold)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subtitle)
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
    }
}

#Preview {
    PaywallView(
        feature: "Map View",
        icon: "map.fill",
        benefits: [
            "See all your visits on a map",
            "View wishlist locations nearby",
            "Filter by visits and wishlist",
            "Zoom to fit all your pins"
        ]
    )
    .environmentObject(AuthViewModel())
}
