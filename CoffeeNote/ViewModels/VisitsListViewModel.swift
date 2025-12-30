//
//  VisitsListViewModel.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import Combine
import FirebaseFirestore

/// ViewModel to manage the list of coffee shop visits
@MainActor
class VisitsListViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var visits: [CoffeeShopVisit] = []
    @Published var filteredVisits: [CoffeeShopVisit] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    @Published var sortOption: SortOption = .dateDescending

    // MARK: - Private Properties
    private let visitService = VisitService()
    private var listenerRegistration: ListenerRegistration?

    // MARK: - Sort Options
    enum SortOption: String, CaseIterable {
        case dateDescending = "Newest First"
        case dateAscending = "Oldest First"
        case ratingDescending = "Highest Rated"
        case ratingAscending = "Lowest Rated"
        case nameAscending = "Name A-Z"
        case nameDescending = "Name Z-A"
        case priceDescending = "Most Expensive"
        case priceAscending = "Least Expensive"
    }

    // MARK: - Initialization
    init() {
        setupObservers()
    }

    deinit {
        listenerRegistration?.remove()
    }

    // MARK: - Setup

    private func setupObservers() {
        // Observe search query and sort option changes
        Publishers.CombineLatest($visits, $searchQuery)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .combineLatest($sortOption)
            .map { (visitsAndQuery, sortOption) -> [CoffeeShopVisit] in
                let (visits, query) = visitsAndQuery
                return self.filterAndSort(visits: visits, query: query, sortOption: sortOption)
            }
            .assign(to: &$filteredVisits)
    }

    // MARK: - Fetch Methods

    /// Fetch all visits for a user
    func fetchVisits(for userId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedVisits = try await visitService.fetchVisits(for: userId)
            visits = fetchedVisits
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("❌ Error fetching visits: \(error.localizedDescription)")
        }
    }

    /// Start listening for real-time updates
    func startListening(for userId: String) {
        listenerRegistration?.remove()

        listenerRegistration = visitService.listenToVisits(for: userId) { [weak self] visits in
            self?.visits = visits
        }
    }

    /// Stop listening for real-time updates
    func stopListening() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }

    // MARK: - Delete

    /// Delete a visit
    func deleteVisit(_ visit: CoffeeShopVisit) async {
        do {
            try await visitService.deleteVisit(visitId: visit.id, for: visit.userId)
            // The real-time listener will update the list automatically
        } catch {
            errorMessage = "Failed to delete visit: \(error.localizedDescription)"
            print("❌ Error deleting visit: \(error.localizedDescription)")
        }
    }

    // MARK: - Filter and Sort

    private func filterAndSort(visits: [CoffeeShopVisit], query: String, sortOption: SortOption) -> [CoffeeShopVisit] {
        var result = visits

        // Filter by search query
        if !query.isEmpty {
            result = result.filter { visit in
                visit.shopName.localizedCaseInsensitiveContains(query) ||
                visit.address.localizedCaseInsensitiveContains(query) ||
                visit.itemsOrdered.contains { $0.localizedCaseInsensitiveContains(query) } ||
                (visit.notes?.localizedCaseInsensitiveContains(query) ?? false)
            }
        }

        // Sort
        switch sortOption {
        case .dateDescending:
            result.sort { $0.dateVisited > $1.dateVisited }
        case .dateAscending:
            result.sort { $0.dateVisited < $1.dateVisited }
        case .ratingDescending:
            result.sort { $0.rating > $1.rating }
        case .ratingAscending:
            result.sort { $0.rating < $1.rating }
        case .nameAscending:
            result.sort { $0.shopName.localizedCompare($1.shopName) == .orderedAscending }
        case .nameDescending:
            result.sort { $0.shopName.localizedCompare($1.shopName) == .orderedDescending }
        case .priceDescending:
            result.sort { $0.price > $1.price }
        case .priceAscending:
            result.sort { $0.price < $1.price }
        }

        return result
    }

    // MARK: - Statistics

    /// Get total number of visits
    var totalVisits: Int {
        return visits.count
    }

    /// Get total amount spent
    var totalSpent: Double {
        return visits.reduce(0) { $0 + $1.price }
    }

    /// Get average rating
    var averageRating: Double {
        guard !visits.isEmpty else { return 0 }
        let total = visits.reduce(0.0) { $0 + $1.rating }
        return total / Double(visits.count)
    }
}
