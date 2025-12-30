//
//  ColorExtension.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI

/// Coffee-themed color palette for the app
extension Color {

    // MARK: - Primary Colors (Adaptive for Dark Mode)

    /// Rich espresso brown - primary brand color
    /// Light mode: Dark brown, Dark mode: Lighter warm brown
    static let coffeeEspresso = Color.adaptive(
        light: Color(red: 0.29, green: 0.20, blue: 0.15), // #4A3325
        dark: Color(red: 0.82, green: 0.67, blue: 0.55)   // #D1AB8C - Light warm brown
    )

    /// Medium coffee brown
    /// Light mode: Medium brown, Dark mode: Lighter tan
    static let coffeeBrown = Color.adaptive(
        light: Color(red: 0.45, green: 0.31, blue: 0.22), // #734F38
        dark: Color(red: 0.88, green: 0.73, blue: 0.61)   // #E0BAA0 - Light tan
    )

    /// Light latte brown
    /// Light mode: Light brown, Dark mode: Creamy beige
    static let coffeeLatte = Color.adaptive(
        light: Color(red: 0.76, green: 0.61, blue: 0.49), // #C29B7D
        dark: Color(red: 0.92, green: 0.82, blue: 0.72)   // #EBD1B8 - Creamy beige
    )

    /// Cream color for highlights
    static let coffeeCream = Color(red: 0.95, green: 0.91, blue: 0.84) // #F2E8D6

    /// Warm beige for backgrounds
    static let coffeeBeige = Color(red: 0.98, green: 0.96, blue: 0.92) // #FAF5EB

    // MARK: - Accent Colors (Adaptive for Dark Mode)

    /// Gold accent for premium features
    /// Light mode: Rich gold, Dark mode: Brighter gold
    static let coffeeGold = Color.adaptive(
        light: Color(red: 0.85, green: 0.65, blue: 0.29), // #D9A64A
        dark: Color(red: 0.95, green: 0.78, blue: 0.42)   // #F2C76B - Brighter gold
    )

    /// Green for success states (like a good brew)
    /// Light mode: Forest green, Dark mode: Brighter green
    static let coffeeGreen = Color.adaptive(
        light: Color(red: 0.34, green: 0.55, blue: 0.34), // #578C57
        dark: Color(red: 0.48, green: 0.78, blue: 0.48)   // #7AC77A - Brighter green
    )

    /// Red for warnings/errors
    /// Light mode: Deep red, Dark mode: Brighter red
    static let coffeeRed = Color.adaptive(
        light: Color(red: 0.76, green: 0.29, blue: 0.29), // #C24A4A
        dark: Color(red: 0.95, green: 0.48, blue: 0.48)   // #F27A7A - Brighter red
    )

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

    /// Visited location pin color (coffee cup icon)
    static let visitedPin = coffeeEspresso

    /// Wishlist location pin color (bookmark icon)
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
