//
//  ColorExtension.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI

/// Coffee-themed color palette for the app
extension Color {

    // MARK: - Primary Colors

    /// Rich espresso brown - primary brand color
    static let coffeeEspresso = Color(red: 0.29, green: 0.20, blue: 0.15) // #4A3325

    /// Medium coffee brown
    static let coffeeBrown = Color(red: 0.45, green: 0.31, blue: 0.22) // #734F38

    /// Light latte brown
    static let coffeeLatte = Color(red: 0.76, green: 0.61, blue: 0.49) // #C29B7D

    /// Cream color for highlights
    static let coffeeCream = Color(red: 0.95, green: 0.91, blue: 0.84) // #F2E8D6

    /// Warm beige for backgrounds
    static let coffeeBeige = Color(red: 0.98, green: 0.96, blue: 0.92) // #FAF5EB

    // MARK: - Accent Colors

    /// Gold accent for premium features
    static let coffeeGold = Color(red: 0.85, green: 0.65, blue: 0.29) // #D9A64A

    /// Green for success states (like a good brew)
    static let coffeeGreen = Color(red: 0.34, green: 0.55, blue: 0.34) // #578C57

    /// Red for warnings/errors
    static let coffeeRed = Color(red: 0.76, green: 0.29, blue: 0.29) // #C24A4A

    // MARK: - Adaptive Colors (Auto Dark Mode Support)

    /// Primary text color - adapts to dark mode
    static let textPrimary = Color.primary

    /// Secondary text color - adapts to dark mode
    static let textSecondary = Color.secondary

    /// Background color - adapts to dark mode
    static let appBackground = Color(uiColor: .systemBackground)

    /// Card/surface background - adapts to dark mode
    static let cardBackground = Color(uiColor: .secondarySystemBackground)

    // MARK: - Semantic Colors

    /// Primary button background
    static let buttonPrimary = coffeeBrown

    /// Premium feature indicator
    static let premiumAccent = coffeeGold

    /// Visited location pin color
    static let visitedPin = coffeeEspresso

    /// Wishlist location pin color
    static let wishlistPin = coffeeGold

    /// Rating stars color
    static let ratingStars = coffeeGold
}

// MARK: - Color Scheme Helper
extension Color {
    /// Creates a color that adapts to light/dark mode
    /// - Parameters:
    ///   - light: Color for light mode
    ///   - dark: Color for dark mode
    /// - Returns: Adaptive color
    static func adaptive(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
                UIColor(dark) : UIColor(light)
        })
    }
}
