//
//  StatisticsCalculator.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation

/// Statistics data structure
struct CoffeeStatistics {
    let totalVisits: Int
    let totalWishlistItems: Int
    let averageRating: Double
    let totalSpent: Double
    let favoriteItem: String?
    let mostVisitedShop: String?
    let highestRatedShop: String?
    let mostExpensiveVisit: CoffeeShopVisit?
    let firstVisitDate: Date?
    let averagePrice: Double
}

/// Calculator for coffee-related statistics
class StatisticsCalculator {

    /// Calculate all statistics from visits and wishlist
    /// - Parameters:
    ///   - visits: Array of coffee shop visits
    ///   - wishlistItems: Array of wishlist locations
    /// - Returns: CoffeeStatistics struct with all computed stats
    static func calculateStatistics(
        visits: [CoffeeShopVisit],
        wishlistItems: [WantToGoLocation]
    ) -> CoffeeStatistics {

        // Total visits
        let totalVisits = visits.count
        let totalWishlistItems = wishlistItems.count

        // Average rating
        let averageRating: Double
        if !visits.isEmpty {
            let totalRating = visits.reduce(0.0) { $0 + $1.rating }
            averageRating = totalRating / Double(visits.count)
        } else {
            averageRating = 0.0
        }

        // Total spent
        let totalSpent = visits.reduce(0.0) { $0 + $1.price }

        // Average price
        let averagePrice: Double
        if !visits.isEmpty {
            averagePrice = totalSpent / Double(visits.count)
        } else {
            averagePrice = 0.0
        }

        // Favorite item (most frequently ordered)
        let favoriteItem = calculateFavoriteItem(from: visits)

        // Most visited shop
        let mostVisitedShop = calculateMostVisitedShop(from: visits)

        // Highest rated shop
        let highestRatedShop = calculateHighestRatedShop(from: visits)

        // Most expensive visit
        let mostExpensiveVisit = visits.max(by: { $0.price < $1.price })

        // First visit date
        let firstVisitDate = visits.min(by: { $0.dateVisited < $1.dateVisited })?.dateVisited

        return CoffeeStatistics(
            totalVisits: totalVisits,
            totalWishlistItems: totalWishlistItems,
            averageRating: averageRating,
            totalSpent: totalSpent,
            favoriteItem: favoriteItem,
            mostVisitedShop: mostVisitedShop,
            highestRatedShop: highestRatedShop,
            mostExpensiveVisit: mostExpensiveVisit,
            firstVisitDate: firstVisitDate,
            averagePrice: averagePrice
        )
    }

    // MARK: - Private Helpers

    /// Calculate the most frequently ordered item
    private static func calculateFavoriteItem(from visits: [CoffeeShopVisit]) -> String? {
        var itemCounts: [String: Int] = [:]

        // Count all items
        for visit in visits {
            for item in visit.itemsOrdered {
                let normalizedItem = item.lowercased().trimmingCharacters(in: .whitespaces)
                itemCounts[normalizedItem, default: 0] += 1
            }
        }

        // Find most common item
        guard let mostCommon = itemCounts.max(by: { $0.value < $1.value }) else {
            return nil
        }

        return mostCommon.key.capitalized
    }

    /// Calculate the most visited shop
    private static func calculateMostVisitedShop(from visits: [CoffeeShopVisit]) -> String? {
        var shopCounts: [String: Int] = [:]

        // Count visits per shop
        for visit in visits {
            shopCounts[visit.shopName, default: 0] += 1
        }

        // Find most visited shop
        guard let mostVisited = shopCounts.max(by: { $0.value < $1.value }) else {
            return nil
        }

        // Only return if visited more than once
        return mostVisited.value > 1 ? mostVisited.key : nil
    }

    /// Calculate the highest rated shop (must have rating of 4.5 or higher)
    private static func calculateHighestRatedShop(from visits: [CoffeeShopVisit]) -> String? {
        // Filter for high ratings
        let highRatedVisits = visits.filter { $0.rating >= 4.5 }

        // Find the highest rated
        guard let highestRated = highRatedVisits.max(by: { $0.rating < $1.rating }) else {
            return nil
        }

        return highestRated.shopName
    }
}
