//
//  WishlistView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import FirebaseAuth

struct WishlistView: View {

    @StateObject private var viewModel = WishlistViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingAddWishlist = false
    @State private var selectedLocation: WantToGoLocation?

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading && viewModel.wishlistLocations.isEmpty {
                    ProgressView()
                        .tint(.coffeeBrown)
                } else if viewModel.wishlistLocations.isEmpty {
                    emptyStateView
                } else {
                    wishlistList
                }
            }
            .navigationTitle("Wishlist")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWishlist = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.coffeeGold)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddWishlist) {
                AddToWishlistView()
                    .environmentObject(authViewModel)
            }
            .sheet(item: $selectedLocation) { location in
                WishlistDetailView(location: location)
                    .environmentObject(authViewModel)
            }
            .onAppear {
                loadWishlist()
            }
            .onDisappear {
                viewModel.stopListening()
            }
            .refreshable {
                await refreshWishlist()
            }
        }
    }

    // MARK: - Subviews

    private var wishlistList: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Stats Header
                statsHeader

                // Wishlist Items
                ForEach(viewModel.wishlistLocations) { location in
                    WishlistCardView(
                        location: location,
                        distanceString: viewModel.distanceString(to: location)
                    )
                    .onTapGesture {
                        selectedLocation = location
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            deleteLocation(location)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.appBackground)
    }

    private var statsHeader: some View {
        VStack(spacing: 0) {
            StatBubble(
                title: "Want to Visit",
                value: "\(viewModel.totalWishlistItems)",
                icon: "bookmark.fill"
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 5)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bookmark.fill")
                .font(.system(size: 80))
                .foregroundColor(.coffeeGold.opacity(0.5))

            Text("No Wishlist Items Yet")
                .font(.sectionHeader)
                .foregroundColor(.textPrimary)

            Text("Start adding coffee shops you want to visit!")
                .coffeeSubtitle()
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { showingAddWishlist = true }) {
                Text("Add Your First Shop")
                    .font(.button)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.coffeeGold)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    // MARK: - Actions

    private func loadWishlist() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        viewModel.startListening(for: userId)
    }

    private func refreshWishlist() async {
        guard let userId = authViewModel.currentUser?.uid else { return }
        await viewModel.refreshWishlist(for: userId)
    }

    private func deleteLocation(_ location: WantToGoLocation) {
        Task {
            await viewModel.deleteWishlistLocation(location)
        }
    }
}

// MARK: - Wishlist Card View
struct WishlistCardView: View {
    let location: WantToGoLocation
    let distanceString: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Row
            HStack {
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.coffeeGold)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 4) {
                    Text(location.shopName)
                        .font(.cardTitle)
                        .foregroundColor(.textPrimary)

                    Text(location.address)
                        .coffeeCaption()
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                }

                Spacer()
            }

            // Distance
            if let distance = distanceString {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(.coffeeGold)

                    Text(distance)
                        .coffeeCaption()
                        .foregroundColor(.textSecondary)
                }
            }

            // Notes Preview
            if let notes = location.notes, !notes.isEmpty {
                Text(notes)
                    .font(.bodyText)
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                    .padding(.top, 4)
            }

            // Date Added
            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundColor(.textSecondary)

                Text("Added \(location.dateAdded.formatted(date: .abbreviated, time: .omitted))")
                    .coffeeCaption()
                    .foregroundColor(.textSecondary)

                Spacer()
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    WishlistView()
        .environmentObject(AuthViewModel())
}
