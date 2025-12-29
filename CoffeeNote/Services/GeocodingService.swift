//
//  GeocodingService.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import CoreLocation

/// Service to handle geocoding (address ↔ coordinates conversion)
class GeocodingService {

    // MARK: - Properties
    private let geocoder = CLGeocoder()

    // MARK: - Forward Geocoding (Address → Coordinates)

    /// Convert an address string to coordinates
    /// - Parameter address: Address string to geocode
    /// - Returns: CLLocation with coordinates
    func geocodeAddress(_ address: String) async throws -> CLLocation {
        guard !address.isEmpty else {
            throw LocationError.geocodingFailed
        }

        return try await withCheckedThrowingContinuation { continuation in
            geocoder.geocodeAddressString(address) { placemarks, error in
                if let error = error {
                    print("❌ Forward geocoding error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }

                guard let location = placemarks?.first?.location else {
                    print("❌ No location found for address: \(address)")
                    continuation.resume(throwing: LocationError.geocodingFailed)
                    return
                }

                print("✅ Geocoded address to: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                continuation.resume(returning: location)
            }
        }
    }

    // MARK: - Reverse Geocoding (Coordinates → Address)

    /// Convert coordinates to an address
    /// - Parameter location: CLLocation with coordinates
    /// - Returns: Formatted address string
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("❌ Reverse geocoding error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }

                guard let placemark = placemarks?.first else {
                    print("❌ No placemark found for location")
                    continuation.resume(throwing: LocationError.geocodingFailed)
                    return
                }

                let address = self.formatAddress(from: placemark)
                print("✅ Reverse geocoded to: \(address)")
                continuation.resume(returning: address)
            }
        }
    }

    /// Get detailed placemark information from coordinates
    /// - Parameter location: CLLocation with coordinates
    /// - Returns: CLPlacemark with detailed location info
    func getPlacemark(for location: CLLocation) async throws -> CLPlacemark {
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("❌ Reverse geocoding error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }

                guard let placemark = placemarks?.first else {
                    print("❌ No placemark found")
                    continuation.resume(throwing: LocationError.geocodingFailed)
                    return
                }

                continuation.resume(returning: placemark)
            }
        }
    }

    // MARK: - Helper Methods

    /// Format a placemark into a readable address string
    /// - Parameter placemark: CLPlacemark to format
    /// - Returns: Formatted address string
    private func formatAddress(from placemark: CLPlacemark) -> String {
        var components: [String] = []

        // Street number and name
        if let subThoroughfare = placemark.subThoroughfare {
            components.append(subThoroughfare)
        }

        if let thoroughfare = placemark.thoroughfare {
            components.append(thoroughfare)
        }

        // City
        if let locality = placemark.locality {
            components.append(locality)
        }

        // State
        if let administrativeArea = placemark.administrativeArea {
            components.append(administrativeArea)
        }

        // ZIP code
        if let postalCode = placemark.postalCode {
            components.append(postalCode)
        }

        // Country (optional, usually not needed for local addresses)
        // if let country = placemark.country {
        //     components.append(country)
        // }

        return components.isEmpty ? "Unknown Address" : components.joined(separator: ", ")
    }

    /// Cancel any ongoing geocoding operations
    func cancelGeocoding() {
        geocoder.cancelGeocode()
        print("⏸️ Geocoding cancelled")
    }
}

// MARK: - CLPlacemark Extension
extension CLPlacemark {
    /// Get a short address (street and city only)
    var shortAddress: String? {
        var components: [String] = []

        if let thoroughfare = thoroughfare {
            components.append(thoroughfare)
        }

        if let locality = locality {
            components.append(locality)
        }

        return components.isEmpty ? nil : components.joined(separator: ", ")
    }

    /// Get city and state only
    var cityState: String? {
        var components: [String] = []

        if let locality = locality {
            components.append(locality)
        }

        if let administrativeArea = administrativeArea {
            components.append(administrativeArea)
        }

        return components.isEmpty ? nil : components.joined(separator: ", ")
    }
}
