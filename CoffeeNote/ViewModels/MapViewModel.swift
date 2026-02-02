//
//  MapViewModel.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import Combine
import MapKit
import FirebaseFirestore

/// ViewModel to manage map view state and annotations
@MainActor
class MapViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var annotations: [MapPin] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco default
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    @Published var selectedAnnotation: MapPin?
    @Published var showVisits: Bool = true
    @Published var showWishlist: Bool = true
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var visits: [CoffeeShopVisit] = []
    private var wishlistLocations: [WantToGoLocation] = []
    private let visitService = VisitService()
    private let wishlistService = WishlistService()
    private let locationManager = LocationManager()
    private var cachedUserLocation: CLLocation?
    nonisolated(unsafe) private var visitListener: ListenerRegistration?
    nonisolated(unsafe) private var wishlistListener: ListenerRegistration?

    // MARK: - Initialization
    init() {
        // Preload user location for faster "Center on Me" functionality
        Task {
            do {
                cachedUserLocation = try await locationManager.getCurrentLocation()
            } catch {
                print("⚠️ Could not preload user location: \(error.localizedDescription)")
            }
        }
    }

    deinit {
        stopListening()
    }

    // MARK: - Fetch Data

    /// Start listening for real-time updates
    func startListening(for userId: String) {
        isLoading = true

        // Listen to visits
        visitListener = visitService.listenToVisits(for: userId) { [weak self] visits in
            self?.visits = visits
            self?.updateAnnotations()
            self?.isLoading = false
        }

        // Listen to wishlist
        wishlistListener = wishlistService.listenToWishlist(for: userId) { [weak self] wishlist in
            self?.wishlistLocations = wishlist
            self?.updateAnnotations()
        }
    }

    /// Stop listening for real-time updates
    nonisolated func stopListening() {
        visitListener?.remove()
        wishlistListener?.remove()
        visitListener = nil
        wishlistListener = nil
    }

    /// Manually refresh data
    func refreshData(for userId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            async let visitsResult = visitService.fetchVisits(for: userId)
            async let wishlistResult = wishlistService.fetchWishlist(for: userId)

            let (fetchedVisits, fetchedWishlist) = try await (visitsResult, wishlistResult)

            visits = fetchedVisits
            wishlistLocations = fetchedWishlist
            updateAnnotations()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("❌ Error fetching map data: \(error.localizedDescription)")
        }
    }

    // MARK: - Update Annotations

    private func updateAnnotations() {
        var newAnnotations: [MapPin] = []

        // Add visit annotations if enabled - group by location
        if showVisits {
            let groupedVisits = groupVisitsByLocation(visits)
            let visitAnnotations = groupedVisits.map { MapPin(visits: $0) }
            newAnnotations.append(contentsOf: visitAnnotations)
        }

        // Add wishlist annotations if enabled
        if showWishlist {
            let wishlistAnnotations = wishlistLocations.map { MapPin(wishlistLocation: $0) }
            newAnnotations.append(contentsOf: wishlistAnnotations)
        }

        annotations = newAnnotations

        // Update region to fit all pins if there are annotations
        if !annotations.isEmpty {
            zoomToFitAllPins()
        }
    }
    
    /// Group visits by location (same coffee shop)
    /// Uses placeID if available, otherwise groups by coordinates (within ~50 meters)
    private func groupVisitsByLocation(_ visits: [CoffeeShopVisit]) -> [[CoffeeShopVisit]] {
        var grouped: [String: [CoffeeShopVisit]] = [:]
        
        for visit in visits {
            // Use placeID if available for accurate grouping
            if let placeID = visit.placeID, !placeID.isEmpty {
                grouped[placeID, default: []].append(visit)
            } else {
                // Fallback: group by rounded coordinates (to ~50 meter precision)
                // This helps group visits to the same shop even without placeID
                let roundedLat = round(visit.latitude * 1000) / 1000  // ~111 meters
                let roundedLon = round(visit.longitude * 1000) / 1000
                let locationKey = "\(roundedLat)_\(roundedLon)_\(visit.shopName)"
                grouped[locationKey, default: []].append(visit)
            }
        }
        
        return Array(grouped.values)
    }

    // MARK: - Filter Toggles

    /// Toggle showing visits
    func toggleVisits() {
        showVisits.toggle()
        updateAnnotations()
    }

    /// Toggle showing wishlist
    func toggleWishlist() {
        showWishlist.toggle()
        updateAnnotations()
    }

    /// Show both visits and wishlist
    func showAll() {
        showVisits = true
        showWishlist = true
        updateAnnotations()
    }

    // MARK: - Map Actions

    /// Zoom map to fit all pins
    func zoomToFitAllPins() {
        guard !annotations.isEmpty else { return }

        var minLat = annotations.first!.coordinate.latitude
        var maxLat = annotations.first!.coordinate.latitude
        var minLon = annotations.first!.coordinate.longitude
        var maxLon = annotations.first!.coordinate.longitude

        for annotation in annotations {
            minLat = min(minLat, annotation.coordinate.latitude)
            maxLat = max(maxLat, annotation.coordinate.latitude)
            minLon = min(minLon, annotation.coordinate.longitude)
            maxLon = max(maxLon, annotation.coordinate.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.3, // Add 30% padding
            longitudeDelta: (maxLon - minLon) * 1.3
        )

        region = MKCoordinateRegion(center: center, span: span)
    }

    /// Center map on user's location
    func centerOnUserLocation() {
        Task {
            do {
                // Use cached location if it's recent (within 5 minutes)
                let location: CLLocation
                if let cached = cachedUserLocation,
                   abs(cached.timestamp.timeIntervalSinceNow) < 300 {
                    // Use cached location for instant centering
                    location = cached
                } else {
                    // Get fresh location and cache it
                    location = try await locationManager.getCurrentLocation()
                    cachedUserLocation = location
                }

                // Center map on location
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            } catch {
                print("❌ Error getting user location: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Statistics

    /// Total number of visible annotations
    var totalAnnotations: Int {
        return annotations.count
    }

    /// Number of visit annotations
    var visitCount: Int {
        return visits.count
    }

    /// Number of wishlist annotations
    var wishlistCount: Int {
        return wishlistLocations.count
    }
}
