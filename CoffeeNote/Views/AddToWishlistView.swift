//
//  AddToWishlistView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct AddToWishlistView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddWishlistViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {

                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.coffeeGold)

                        Text("Add to Wishlist")
                            .font(.sectionHeader)
                            .foregroundColor(.coffeeBrown)

                        Text("Save a coffee shop you want to visit")
                            .coffeeSubtitle()
                    }
                    .padding(.top)

                    // Location Search
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Location", systemImage: "location.fill")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        LocationSearchView(
                            selectedLocation: $viewModel.selectedLocation,
                            onLocationSelected: { location in
                                viewModel.updateFromLocation(location)
                            }
                        )
                    }

                    // Shop Name (manual override)
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Shop Name", systemImage: "storefront.fill")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        TextField("Coffee shop name", text: $viewModel.shopName)
                            .textInputAutocapitalization(.words)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(10)
                    }

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Notes (Optional)", systemImage: "note.text")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        Text("Why do you want to visit this place?")
                            .coffeeCaption()
                            .foregroundColor(.textSecondary)

                        TextEditor(text: $viewModel.notes)
                            .frame(height: 120)
                            .padding(8)
                            .background(Color.cardBackground)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                            )
                    }

                    // Error Message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .coffeeCaption()
                            .foregroundColor(.coffeeRed)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.coffeeRed.opacity(0.1))
                            .cornerRadius(10)
                    }

                    // Save Button
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.coffeeBrown)
                    } else {
                        Button(action: saveWishlistLocation) {
                            Text("Add to Wishlist")
                                .font(.button)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.isValid ? Color.coffeeGold : Color.textSecondary)
                                .cornerRadius(10)
                        }
                        .disabled(!viewModel.isValid)
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.coffeeBrown)
                }
            }
        }
    }

    // MARK: - Actions

    private func saveWishlistLocation() {
        guard let userId = authViewModel.currentUser?.uid else {
            viewModel.errorMessage = "No authenticated user"
            return
        }

        Task {
            let success = await viewModel.saveWishlistLocation(userId: userId)
            if success {
                dismiss()
            }
        }
    }
}

#Preview {
    AddToWishlistView()
        .environmentObject(AuthViewModel())
}
