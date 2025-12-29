//
//  LocationManager.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import CoreLocation
import Combine

/// Manager class to handle location services and permissions
class LocationManager: NSObject, ObservableObject {

    // MARK: - Published Properties
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    // MARK: - Private Properties
    private let locationManager = CLLocationManager()

    // MARK: - Initialization
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }

    // MARK: - Public Methods

    /// Request location permission from the user
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    /// Start updating location
    func startUpdatingLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            errorMessage = "Location permission not granted"
            return
        }

        isLoading = true
        locationManager.startUpdatingLocation()
    }

    /// Stop updating location
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        isLoading = false
    }

    /// Get current location once
    func getCurrentLocation() async throws -> CLLocation {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            throw LocationError.permissionDenied
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.isLoading = true

            // If we already have a recent location, return it
            if let location = currentLocation,
               location.timestamp.timeIntervalSinceNow > -60 {
                self.isLoading = false
                continuation.resume(returning: location)
                return
            }

            // Start getting location
            locationManager.requestLocation()

            // Wait for location update via delegate
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.isLoading = false
                if let location = self.currentLocation {
                    continuation.resume(returning: location)
                } else {
                    continuation.resume(throwing: LocationError.locationNotAvailable)
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted")
            errorMessage = nil
        case .denied, .restricted:
            print("❌ Location permission denied")
            errorMessage = "Location access denied. Please enable in Settings."
        case .notDetermined:
            print("⏳ Location permission not determined")
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        isLoading = false
        print("✅ Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
        print("❌ Location error: \(error.localizedDescription)")
    }
}

// MARK: - Location Errors
enum LocationError: LocalizedError {
    case permissionDenied
    case locationNotAvailable
    case geocodingFailed

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission is required to find nearby coffee shops."
        case .locationNotAvailable:
            return "Unable to determine your current location."
        case .geocodingFailed:
            return "Unable to get address for this location."
        }
    }
}
