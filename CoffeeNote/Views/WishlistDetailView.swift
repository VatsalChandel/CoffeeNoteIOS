//
//  WishlistDetailView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct WishlistDetailView: View {

    let location: WantToGoLocation
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var notes: String
    @State private var isEditingNotes = false
    @State private var showingDeleteConfirmation = false
    @State private var showingMarkAsVisited = false
    @State private var isDeleting = false
    @State private var region: MKCoordinateRegion

    // Services
    private let wishlistService = WishlistService()

    init(location: WantToGoLocation) {
        self.location = location
        _notes = State(initialValue: location.notes ?? "")
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Header Icon
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.coffeeGold)
                        .padding(.top)

                    // Shop Name
                    Text(location.shopName)
                        .font(.sectionHeader)
                        .foregroundColor(.coffeeBrown)
                        .multilineTextAlignment(.center)

                    // Address
                    Label(location.address, systemImage: "location.fill")
                        .coffeeSubtitle()
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Mini Map
                    Map(coordinateRegion: .constant(region), annotationItems: [location]) { item in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(
                            latitude: item.latitude,
                            longitude: item.longitude
                        )) {
                            VStack {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(.coffeeGold)
                                    .font(.title)
                                    .shadow(radius: 3)
                            }
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(15)
                    .disabled(true)
                    .padding(.horizontal)

                    // Notes Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Notes", systemImage: "note.text")
                                .font(.subtitle)
                                .foregroundColor(.coffeeBrown)

                            Spacer()

                            if !isEditingNotes {
                                Button("Edit") {
                                    isEditingNotes = true
                                }
                                .foregroundColor(.coffeeBrown)
                                .font(.caption)
                            }
                        }

                        if isEditingNotes {
                            VStack(spacing: 8) {
                                TextEditor(text: $notes)
                                    .frame(height: 100)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                                    .background(Color.cardBackground)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                                    )

                                HStack {
                                    Button("Cancel") {
                                        notes = location.notes ?? ""
                                        isEditingNotes = false
                                    }
                                    .foregroundColor(.textSecondary)

                                    Spacer()

                                    Button("Save") {
                                        saveNotes()
                                    }
                                    .foregroundColor(.coffeeBrown)
                                    .fontWeight(.semibold)
                                }
                            }
                        } else {
                            if notes.isEmpty {
                                Text("No notes yet. Tap Edit to add why you want to visit!")
                                    .coffeeCaption()
                                    .foregroundColor(.textSecondary)
                                    .italic()
                            } else {
                                Text(notes)
                                    .font(.bodyText)
                                    .foregroundColor(.textPrimary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .padding(.horizontal)

                    // Date Added
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.textSecondary)

                        Text("Added on \(location.dateAdded.formatted(date: .long, time: .omitted))")
                            .coffeeCaption()
                            .foregroundColor(.textSecondary)
                    }

                    // Mark as Visited Button
                    Button(action: { showingMarkAsVisited = true }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark as Visited")
                        }
                        .font(.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.coffeeEspresso)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Delete Button
                    Button(action: { showingDeleteConfirmation = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete from Wishlist")
                        }
                        .font(.button)
                        .foregroundColor(.coffeeRed)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.coffeeRed.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.bottom)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.coffeeBrown)
                }
            }
            .alert("Delete from Wishlist?", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteLocation()
                }
            } message: {
                Text("Are you sure you want to remove \(location.shopName) from your wishlist?")
            }
            .sheet(isPresented: $showingMarkAsVisited) {
                MarkAsVisitedView(
                    wishlistLocation: location,
                    onCompleted: {
                        // Dismiss the detail view after marking as visited
                        dismiss()
                    }
                )
                .environmentObject(authViewModel)
            }
        }
    }

    // MARK: - Actions

    private func saveNotes() {
        Task {
            do {
                var updatedLocation = location
                updatedLocation.notes = notes.isEmpty ? nil : notes

                try await wishlistService.updateWishlistLocation(location: updatedLocation)
                isEditingNotes = false
                print("✅ Notes updated successfully")
            } catch {
                print("❌ Error updating notes: \(error.localizedDescription)")
            }
        }
    }

    private func deleteLocation() {
        Task {
            isDeleting = true
            do {
                try await wishlistService.deleteFromWishlist(locationId: location.id, for: location.userId)
                print("✅ Wishlist location deleted: \(location.shopName)")
                dismiss()
            } catch {
                print("❌ Error deleting wishlist location: \(error.localizedDescription)")
                isDeleting = false
            }
        }
    }
}

// MARK: - Mark as Visited View
/// Wrapper view that shows AddVisitView with pre-filled data and handles wishlist deletion
struct MarkAsVisitedView: View {

    let wishlistLocation: WantToGoLocation
    let onCompleted: () -> Void

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var addVisitViewModel = AddVisitViewModel()

    var body: some View {
        AddVisitView(viewModel: addVisitViewModel, onVisitSaved: {
            // After visit is saved, delete from wishlist
            deleteFromWishlist()
        })
        .environmentObject(authViewModel)
        .onAppear {
            // Pre-fill the form with wishlist data
            addVisitViewModel.shopName = wishlistLocation.shopName
            addVisitViewModel.address = wishlistLocation.address

            // Create MKMapItem from wishlist location coordinates
            let coordinate = CLLocationCoordinate2D(
                latitude: wishlistLocation.latitude,
                longitude: wishlistLocation.longitude
            )
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = wishlistLocation.shopName

            addVisitViewModel.selectedLocation = mapItem
        }
    }

    private func deleteFromWishlist() {
        Task {
            do {
                let wishlistService = WishlistService()
                // Use the full method with locationId and userId
                try await wishlistService.deleteFromWishlist(locationId: wishlistLocation.id, for: wishlistLocation.userId)
                print("✅ Removed from wishlist after marking as visited: \(wishlistLocation.shopName)")

                // Call completion handler to dismiss the detail view
                await MainActor.run {
                    onCompleted()
                }
            } catch {
                print("❌ Error removing from wishlist: \(error.localizedDescription)")
                // Show error to user
                await MainActor.run {
                    // Still call onCompleted even if deletion fails so user isn't stuck
                    onCompleted()
                }
            }
        }
    }
}

#Preview {
    WishlistDetailView(location: WantToGoLocation(
        userId: "preview",
        shopName: "Blue Bottle Coffee",
        address: "123 Main St, San Francisco, CA",
        latitude: 37.7749,
        longitude: -122.4194,
        notes: "Heard they have amazing pour over coffee!"
    ))
    .environmentObject(AuthViewModel())
}
