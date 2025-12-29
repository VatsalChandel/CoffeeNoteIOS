//
//  LocationTestView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import MapKit

struct LocationTestView: View {

    @StateObject private var locationManager = LocationManager()
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var currentAddress: String = ""
    @State private var isSearching: Bool = false

    private let searchService = LocationSearchService()
    private let geocodingService = GeocodingService()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {

                    // MARK: - Location Permission Section
                    VStack(spacing: 15) {
                        Text("Location Permission")
                            .coffeeHeading()

                        Text(permissionStatusText)
                            .coffeeSubtitle()
                            .multilineTextAlignment(.center)

                        if locationManager.authorizationStatus == .notDetermined {
                            Button("Request Location Permission") {
                                locationManager.requestPermission()
                            }
                            .buttonStyle(CoffeeButtonStyle())
                        }

                        if let error = locationManager.errorMessage {
                            Text(error)
                                .coffeeCaption()
                                .foregroundColor(.coffeeRed)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)

                    // MARK: - Current Location Section
                    VStack(spacing: 15) {
                        Text("Current Location")
                            .coffeeHeading()

                        if let location = locationManager.currentLocation {
                            VStack(spacing: 5) {
                                Text("📍 \(location.coordinate.latitude), \(location.coordinate.longitude)")
                                    .font(.bodySecondary)

                                if !currentAddress.isEmpty {
                                    Text(currentAddress)
                                        .coffeeCaption()
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        } else {
                            Text("No location available")
                                .coffeeCaption()
                        }

                        Button("Get Current Location") {
                            getCurrentLocation()
                        }
                        .buttonStyle(CoffeeButtonStyle())
                        .disabled(locationManager.authorizationStatus != .authorizedWhenInUse &&
                                 locationManager.authorizationStatus != .authorizedAlways)

                        if locationManager.isLoading {
                            ProgressView()
                                .tint(.coffeeBrown)
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)

                    // MARK: - Location Search Section
                    VStack(spacing: 15) {
                        Text("Search Locations")
                            .coffeeHeading()

                        TextField("Search for coffee shops...", text: $searchQuery)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                searchForLocations()
                            }

                        Button("Search") {
                            searchForLocations()
                        }
                        .buttonStyle(CoffeeButtonStyle())
                        .disabled(searchQuery.isEmpty)

                        if isSearching {
                            ProgressView()
                                .tint(.coffeeBrown)
                        }

                        // Search Results
                        if !searchResults.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Results:")
                                    .font(.subtitle)
                                    .foregroundColor(.coffeeBrown)

                                ForEach(searchResults.prefix(5), id: \.self) { item in
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(item.name ?? "Unknown")
                                            .font(.cardTitle)
                                        if let address = item.formattedAddress {
                                            Text(address)
                                                .coffeeCaption()
                                        }
                                    }
                                    .padding(.vertical, 5)
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("Location Test")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.appBackground)
        }
    }

    // MARK: - Helper Properties
    private var permissionStatusText: String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "Not Requested"
        case .authorizedWhenInUse, .authorizedAlways:
            return "✅ Authorized"
        case .denied:
            return "❌ Denied"
        case .restricted:
            return "❌ Restricted"
        @unknown default:
            return "Unknown"
        }
    }

    // MARK: - Actions
    private func getCurrentLocation() {
        Task {
            do {
                let location = try await locationManager.getCurrentLocation()
                // Reverse geocode to get address
                let address = try await geocodingService.reverseGeocodeLocation(location)
                await MainActor.run {
                    currentAddress = address
                }
            } catch {
                print("Error getting location: \(error.localizedDescription)")
            }
        }
    }

    private func searchForLocations() {
        isSearching = true
        Task {
            do {
                let results = try await searchService.searchLocations(query: searchQuery)
                await MainActor.run {
                    searchResults = results
                    isSearching = false
                }
            } catch {
                print("Search error: \(error.localizedDescription)")
                await MainActor.run {
                    isSearching = false
                }
            }
        }
    }
}

// MARK: - Coffee Button Style
struct CoffeeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.button)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(configuration.isPressed ? Color.coffeeLatte : Color.buttonPrimary)
            .cornerRadius(10)
    }
}

#Preview {
    LocationTestView()
}
