//
//  VisitDetailView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct VisitDetailView: View {

    let visit: CoffeeShopVisit
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showDeleteConfirmation = false
    @State private var region: MKCoordinateRegion

    private let visitService = VisitService()

    init(visit: CoffeeShopVisit) {
        self.visit = visit
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: visit.latitude,
                longitude: visit.longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {

                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.coffeeEspresso)

                        Text(visit.shopName)
                            .font(.sectionHeader)
                            .foregroundColor(.coffeeBrown)
                            .multilineTextAlignment(.center)

                        Text(visit.dateVisited, style: .date)
                            .coffeeSubtitle()
                    }
                    .padding(.top)

                    // Mini Map
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Location", systemImage: "mappin.circle.fill")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        Map(coordinateRegion: $region, annotationItems: [visit]) { visit in
                            MapMarker(
                                coordinate: CLLocationCoordinate2D(
                                    latitude: visit.latitude,
                                    longitude: visit.longitude
                                ),
                                tint: .coffeeEspresso
                            )
                        }
                        .frame(height: 200)
                        .cornerRadius(12)
                        .disabled(true)

                        Text(visit.address)
                            .font(.bodySecondary)
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)

                    // Rating and Price
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Label("Rating", systemImage: "star.fill")
                                .font(.subtitle)
                                .foregroundColor(.coffeeBrown)

                            StarRatingDisplay(rating: visit.rating, size: 24)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(12)

                        VStack(spacing: 8) {
                            Label("Price", systemImage: "dollarsign.circle.fill")
                                .font(.subtitle)
                                .foregroundColor(.coffeeBrown)

                            Text("$\(String(format: "%.2f", visit.price))")
                                .coffeePrice()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                    }

                    // Items Ordered
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Items Ordered", systemImage: "cup.and.saucer")
                            .font(.subtitle)
                            .foregroundColor(.coffeeBrown)

                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(visit.itemsOrdered, id: \.self) { item in
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .foregroundColor(.coffeeBrown)

                                    Text(item)
                                        .font(.bodyText)
                                        .foregroundColor(.textPrimary)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)

                    // Notes (if exists)
                    if let notes = visit.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Notes", systemImage: "note.text")
                                .font(.subtitle)
                                .foregroundColor(.coffeeBrown)

                            Text(notes)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(15)
                    }

                    // Delete Button
                    Button(role: .destructive, action: {
                        showDeleteConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Visit")
                        }
                        .font(.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.coffeeRed)
                        .cornerRadius(10)
                    }
                }
                .padding()
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
            .alert("Delete Visit?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteVisit()
                }
            } message: {
                Text("Are you sure you want to delete this visit? This action cannot be undone.")
            }
        }
    }

    // MARK: - Actions

    private func deleteVisit() {
        Task {
            do {
                try await visitService.deleteVisit(visitId: visit.id, for: visit.userId)
                dismiss()
            } catch {
                print("❌ Error deleting visit: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    VisitDetailView(visit: .sample)
        .environmentObject(AuthViewModel())
}
