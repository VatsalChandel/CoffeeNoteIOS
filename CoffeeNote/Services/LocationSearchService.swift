//
//  LocationSearchService.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import MapKit
import CoreLocation

/// Service to search for locations using MKLocalSearch
class LocationSearchService {

    // MARK: - Properties
    private var currentSearchTask: Task<Void, Never>?

    // MARK: - Search Methods

    /// Search for locations matching the query string
    /// - Parameters:
    ///   - query: Search query (e.g., "Blue Bottle Coffee")
    ///   - region: Optional region to limit search results
    /// - Returns: Array of MKMapItem results
    func searchLocations(query: String, region: MKCoordinateRegion? = nil) async throws -> [MKMapItem] {
        // Cancel any existing search
        currentSearchTask?.cancel()

        guard !query.isEmpty else {
            return []
        }

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query

        // If region is provided, use it to limit results
        if let region = region {
            searchRequest.region = region
        }

        // Perform the search
        let search = MKLocalSearch(request: searchRequest)

        return try await withCheckedThrowingContinuation { continuation in
            currentSearchTask = Task {
                do {
                    let response = try await search.start()
                    let items = response.mapItems
                    print("✅ Found \(items.count) results for: \(query)")
                    continuation.resume(returning: items)
                } catch {
                    if (error as NSError).code == NSUserCancelledError {
                        print("⏸️ Search cancelled")
                        continuation.resume(returning: [])
                    } else {
                        print("❌ Search error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    /// Search for coffee shops near a location
    /// - Parameter coordinate: Center coordinate for search
    /// - Returns: Array of coffee shop MKMapItems
    func searchCoffeeShopsNearby(coordinate: CLLocationCoordinate2D) async throws -> [MKMapItem] {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 5000, // 5km radius
            longitudinalMeters: 5000
        )

        return try await searchLocations(query: "coffee shop", region: region)
    }

    /// Get location details from coordinates
    /// - Parameter coordinate: Coordinate to look up
    /// - Returns: MKMapItem with location details
    func getLocationDetails(for coordinate: CLLocationCoordinate2D) async throws -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }

    /// Cancel any ongoing search
    func cancelSearch() {
        currentSearchTask?.cancel()
        currentSearchTask = nil
    }
}

// MARK: - MKMapItem Extension
extension MKMapItem {
    /// Get formatted address string
    var formattedAddress: String? {
        let placemark = self.placemark
        var components: [String] = []

        if let thoroughfare = placemark.thoroughfare {
            components.append(thoroughfare)
        }

        if let locality = placemark.locality {
            components.append(locality)
        }

        if let administrativeArea = placemark.administrativeArea {
            components.append(administrativeArea)
        }

        if let postalCode = placemark.postalCode {
            components.append(postalCode)
        }

        return components.isEmpty ? nil : components.joined(separator: ", ")
    }

    /// Get shop name or fallback to address
    var displayName: String {
        return name ?? formattedAddress ?? "Unknown Location"
    }
}
