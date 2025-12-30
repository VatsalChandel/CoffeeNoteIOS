//
//  LocationSearchView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI
import MapKit

/// Reusable component for searching locations with autocomplete
struct LocationSearchView: View {

    @Binding var selectedLocation: MKMapItem?
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false
    @State private var showResults: Bool = false

    private let searchService = LocationSearchService()
    private let locationManager = LocationManager()

    var onLocationSelected: ((MKMapItem) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Search Text Field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)

                TextField("Search for coffee shop...", text: $searchQuery)
                    .textInputAutocapitalization(.words)
                    .onChange(of: searchQuery) { oldValue, newValue in
                        if !newValue.isEmpty {
                            searchForLocations()
                        } else {
                            searchResults = []
                            showResults = false
                        }
                    }

                if isSearching {
                    ProgressView()
                        .tint(.coffeeBrown)
                }

                if !searchQuery.isEmpty {
                    Button(action: {
                        searchQuery = ""
                        searchResults = []
                        showResults = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(10)

            // "Use Current Location" Button
            Button(action: useCurrentLocation) {
                HStack {
                    Image(systemName: "location.fill")
                    Text("Use Current Location")
                }
                .font(.bodySecondary)
                .foregroundColor(.coffeeBrown)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(10)
            }

            // Search Results
            if showResults && !searchResults.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(searchResults.prefix(5), id: \.self) { item in
                        Button(action: {
                            selectLocation(item)
                        }) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.name ?? "Unknown")
                                    .font(.cardTitle)
                                    .foregroundColor(.textPrimary)

                                if let address = item.formattedAddress {
                                    Text(address)
                                        .coffeeCaption()
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }

                        if item != searchResults.prefix(5).last {
                            Divider()
                        }
                    }
                }
                .background(Color.cardBackground)
                .cornerRadius(10)
            }

            // Selected Location Display
            if let location = selectedLocation {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.coffeeGreen)

                        Text("Selected Location:")
                            .font(.caption)
                            .foregroundColor(.textSecondary)

                        Spacer()

                        Button("Change") {
                            selectedLocation = nil
                            searchQuery = ""
                            showResults = false
                        }
                        .font(.caption)
                        .foregroundColor(.coffeeBrown)
                    }

                    Text(location.name ?? "Unknown")
                        .font(.cardTitle)

                    if let address = location.formattedAddress {
                        Text(address)
                            .coffeeCaption()
                    }
                }
                .padding()
                .background(Color.coffeeGreen.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }

    // MARK: - Actions

    private func searchForLocations() {
        isSearching = true
        showResults = true

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
                    searchResults = []
                    isSearching = false
                }
            }
        }
    }

    private func selectLocation(_ item: MKMapItem) {
        selectedLocation = item
        searchQuery = item.name ?? ""
        showResults = false
        onLocationSelected?(item)
    }

    private func useCurrentLocation() {
        Task {
            do {
                let location = try await locationManager.getCurrentLocation()
                let geocodingService = GeocodingService()
                let placemark = try await geocodingService.getPlacemark(for: location)

                let mkPlacemark = MKPlacemark(placemark: placemark)
                let mapItem = MKMapItem(placemark: mkPlacemark)

                await MainActor.run {
                    selectedLocation = mapItem
                    searchQuery = mapItem.formattedAddress ?? "Current Location"
                    onLocationSelected?(mapItem)
                }
            } catch {
                print("Error getting current location: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    LocationSearchView(selectedLocation: .constant(nil))
        .padding()
}
