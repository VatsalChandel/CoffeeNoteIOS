//
//  AddVisitView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct AddVisitView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddVisitViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var onVisitSaved: (() -> Void)? = nil

    init(viewModel: AddVisitViewModel? = nil, onVisitSaved: (() -> Void)? = nil) {
        self.viewModel = viewModel ?? AddVisitViewModel()
        self.onVisitSaved = onVisitSaved
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {

                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.coffeeEspresso)

                        Text("Log Your Visit")
                            .font(.sectionHeader)
                            .foregroundColor(.coffeeBrown)

                        Text("Track your coffee adventure")
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

                    // Items Ordered
                    ItemsListEditor(
                        items: $viewModel.itemsOrdered,
                        placeholder: "Add item (e.g., Cappuccino)",
                        title: "Items Ordered"
                    )

                    // Rating
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Rating", systemImage: "star.fill")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        StarRatingPicker(rating: $viewModel.rating)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(10)
                    }

                    // Price
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Price (USD)", systemImage: "dollarsign.circle.fill")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        HStack {
                            Text("$")
                                .font(.title3)
                                .foregroundColor(.textSecondary)

                            TextField("0.00", value: $viewModel.price, format: .number.precision(.fractionLength(2)))
                                .keyboardType(.decimalPad)
                                .font(.title3)
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(10)
                    }

                    // Date Visited
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Date Visited", systemImage: "calendar")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        DatePicker(
                            "",
                            selection: $viewModel.dateVisited,
                            in: ...Date(),
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(10)
                    }

                    // Notes (Optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Notes (Optional)", systemImage: "note.text")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        TextEditor(text: $viewModel.notes)
                            .frame(height: 100)
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
                        Button(action: saveVisit) {
                            Text("Save Visit")
                                .font(.button)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.isValid ? Color.buttonPrimary : Color.textSecondary)
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

    private func saveVisit() {
        guard let userId = authViewModel.currentUser?.uid else {
            viewModel.errorMessage = "No authenticated user"
            return
        }

        Task {
            let success = await viewModel.saveVisit(userId: userId)
            if success {
                onVisitSaved?()  // Call callback if provided
                dismiss()
            }
        }
    }
}

#Preview {
    AddVisitView()
        .environmentObject(AuthViewModel())
}
