//
//  MainTabView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import FirebaseAuth

struct MainTabView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Visits List (Always Available)
            VisitsListView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Visits", systemImage: "cup.and.saucer.fill")
                }
                .tag(0)

            // Tab 2: Map View (Premium Only)
            mapViewTab
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(1)

            // Tab 3: Wishlist (Premium Only)
            wishlistViewTab
                .tabItem {
                    Label("Wishlist", systemImage: "bookmark.fill")
                }
                .tag(2)

            // Tab 4: Profile (Always Available)
            ProfileView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(.coffeeBrown)
        .onAppear {
            loadProfileData()
        }
    }

    // MARK: - Tab Views

    private var mapViewTab: some View {
        Group {
            if profileViewModel.isPremiumUser {
                CoffeeMapView()
                    .environmentObject(authViewModel)
            } else {
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
                .environmentObject(authViewModel)
            }
        }
    }

    private var wishlistViewTab: some View {
        Group {
            if profileViewModel.isPremiumUser {
                WishlistView()
                    .environmentObject(authViewModel)
            } else {
                PaywallView(
                    feature: "Wishlist",
                    icon: "bookmark.fill",
                    benefits: [
                        "Track coffee shops you want to visit",
                        "See distance from your location",
                        "Add notes about why you want to go",
                        "Easily convert to visits when you go"
                    ]
                )
                .environmentObject(authViewModel)
            }
        }
    }

    // MARK: - Actions

    private func loadProfileData() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        profileViewModel.startListening(for: userId)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
