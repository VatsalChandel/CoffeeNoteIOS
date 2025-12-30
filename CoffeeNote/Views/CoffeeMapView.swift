//
//  CoffeeMapView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct CoffeeMapView: View {

    @StateObject private var viewModel = MapViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedVisit: CoffeeShopVisit?
    @State private var selectedWishlistLocation: WantToGoLocation?

    var body: some View {
        NavigationView {
            ZStack {
                // Map
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        AnnotationView(annotation: annotation) {
                            handleAnnotationTap(annotation)
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)

                // Empty State
                if !viewModel.isLoading && viewModel.annotations.isEmpty {
                    emptyStateView
                }

                // Filter Controls & Location Button
                VStack {
                    Spacer()

                    // Center on Me Button (Floating)
                    HStack {
                        Spacer()

                        Button(action: viewModel.centerOnUserLocation) {
                            Image(systemName: "location.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(14)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .padding(.trailing)
                    }
                    .padding(.bottom, 8)

                    filterControls
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            .navigationTitle("Coffee Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.zoomToFitAllPins) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .foregroundColor(.coffeeBrown)
                    }
                }
            }
            .sheet(item: $selectedVisit) { visit in
                VisitDetailView(visit: visit)
                    .environmentObject(authViewModel)
            }
            .sheet(item: $selectedWishlistLocation) { location in
                WishlistDetailView(location: location)
                    .environmentObject(authViewModel)
            }
            .onAppear {
                loadMapData()
            }
            .onDisappear {
                viewModel.stopListening()
            }
        }
    }

    // MARK: - Subviews

    private var filterControls: some View {
        HStack(spacing: 12) {
            // Visits Filter
            FilterButton(
                title: "Visits",
                count: viewModel.visitCount,
                isActive: viewModel.showVisits,
                color: .coffeeEspresso
            ) {
                viewModel.toggleVisits()
            }

            // Wishlist Filter
            FilterButton(
                title: "Wishlist",
                count: viewModel.wishlistCount,
                isActive: viewModel.showWishlist,
                color: .coffeeGold
            ) {
                viewModel.toggleWishlist()
            }

            // Show All
            Button(action: viewModel.showAll) {
                Image(systemName: "square.grid.2x2")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.coffeeBrown)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.cardBackground.opacity(0.95))
        .cornerRadius(25)
        .shadow(radius: 5)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "map")
                .font(.system(size: 80))
                .foregroundColor(.textSecondary.opacity(0.5))

            Text("No Locations Yet")
                .font(.sectionHeader)
                .foregroundColor(.textPrimary)

            Text("Start adding coffee shop visits to see them on the map!")
                .coffeeSubtitle()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.appBackground.opacity(0.9))
        .cornerRadius(15)
        .padding()
    }

    // MARK: - Actions

    private func loadMapData() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        viewModel.startListening(for: userId)
    }

    private func handleAnnotationTap(_ annotation: MapPin) {
        viewModel.selectedAnnotation = annotation

        switch annotation.type {
        case .visit:
            if let visit = annotation.visit {
                selectedVisit = visit
            }
        case .wishlist:
            if let location = annotation.wishlistLocation {
                selectedWishlistLocation = location
            }
        }
    }
}

// MARK: - Annotation View
struct AnnotationView: View {
    let annotation: MapPin
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: pinIcon)
                .font(.title)
                .foregroundColor(pinColor)
                .shadow(radius: 3)

            Text(annotation.title)
                .font(.caption2)
                .foregroundColor(.textPrimary)
                .padding(4)
                .background(Color.cardBackground)
                .cornerRadius(4)
                .shadow(radius: 2)
        }
        .onTapGesture {
            onTap()
        }
    }

    private var pinIcon: String {
        switch annotation.type {
        case .visit:
            return "cup.and.saucer.fill"
        case .wishlist:
            return "bookmark.fill"
        }
    }

    private var pinColor: Color {
        switch annotation.type {
        case .visit:
            return .visitedPin
        case .wishlist:
            return .wishlistPin
        }
    }
}

// MARK: - Filter Button
struct FilterButton: View {
    let title: String
    let count: Int
    let isActive: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)

                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)

                Text("\(count)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isActive ? color.opacity(0.2) : Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color, lineWidth: isActive ? 2 : 1)
            )
        }
        .opacity(isActive ? 1.0 : 0.5)
    }
}

#Preview {
    CoffeeMapView()
        .environmentObject(AuthViewModel())
}
