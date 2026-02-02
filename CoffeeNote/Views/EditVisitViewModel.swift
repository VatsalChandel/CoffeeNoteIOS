//
//  EditVisitViewModel.swift
//  CoffeeNote
//
//  Created by Claude on 2/2/26.
//

import Foundation
import Combine
import MapKit

/// ViewModel for editing an existing coffee shop visit
@MainActor
class EditVisitViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var selectedLocation: MKMapItem?
    @Published var shopName: String = ""
    @Published var address: String = ""
    @Published var itemsOrdered: [String] = []
    @Published var rating: Double = 4.0
    @Published var price: Double = 0.0
    @Published var notes: String = ""
    @Published var dateVisited: Date = Date()

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private let visitService = VisitService()
    private let visit: CoffeeShopVisit

    // MARK: - Computed Properties

    /// Check if form is valid for submission
    var isValid: Bool {
        return !shopName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !address.trimmingCharacters(in: .whitespaces).isEmpty &&
               !itemsOrdered.isEmpty &&
               rating >= 0.5 &&
               rating <= 5.0 &&
               price >= 0 &&
               !isDateInFuture
    }

    /// Check if selected date is in the future
    var isDateInFuture: Bool {
        return dateVisited > Date()
    }

    // MARK: - Initialization
    
    init(visit: CoffeeShopVisit) {
        self.visit = visit
        
        // Pre-populate fields with existing data
        self.shopName = visit.shopName
        self.address = visit.address
        self.itemsOrdered = visit.itemsOrdered
        self.rating = visit.rating
        self.price = visit.price
        self.notes = visit.notes ?? ""
        self.dateVisited = visit.dateVisited
        
        // Create a MKMapItem for the location with name and address
        let coordinate = CLLocationCoordinate2D(latitude: visit.latitude, longitude: visit.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = visit.shopName
        self.selectedLocation = mapItem
    }

    // MARK: - Methods

    /// Update form fields from selected location
    func updateFromLocation(_ location: MKMapItem) {
        shopName = location.name ?? ""
        address = location.formattedAddress ?? ""
    }

    /// Update the visit in Firestore
    /// - Returns: True if successful
    func updateVisit() async -> Bool {
        // Check for future date first
        if isDateInFuture {
            errorMessage = "You can't log a visit in the future!"
            return false
        }

        // Validate
        guard isValid else {
            errorMessage = "Please fill in all required fields"
            return false
        }

        // Get coordinates from selected location
        guard let location = selectedLocation else {
            errorMessage = "Please select a location"
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            // Create updated visit object with same ID
            let updatedVisit = CoffeeShopVisit(
                id: visit.id, // Keep the same ID
                userId: visit.userId, // Keep the same userId
                shopName: shopName,
                address: address,
                latitude: location.placemark.coordinate.latitude,
                longitude: location.placemark.coordinate.longitude,
                placeID: visit.placeID, // Keep existing placeID
                itemsOrdered: itemsOrdered,
                rating: rating,
                price: price,
                notes: notes.isEmpty ? nil : notes,
                dateVisited: dateVisited,
                photoURL: visit.photoURL // Keep existing photoURL
            )

            // Update in Firestore
            try await visitService.updateVisit(updatedVisit)

            isLoading = false
            print("✅ Visit updated successfully")
            return true

        } catch {
            errorMessage = "Failed to update visit: \(error.localizedDescription)"
            isLoading = false
            print("❌ Error updating visit: \(error.localizedDescription)")
            return false
        }
    }
}
