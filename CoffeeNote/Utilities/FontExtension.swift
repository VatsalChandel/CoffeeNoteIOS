//
//  FontExtension.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI

/// Reusable typography styles for consistent design
extension Font {

    // MARK: - Headings

    /// Large display title (e.g., "CoffeeNote" on splash)
    static let appTitle = Font.system(size: 36, weight: .bold, design: .rounded)

    /// Section headers
    static let sectionHeader = Font.system(size: 24, weight: .semibold, design: .default)

    /// Card titles (e.g., coffee shop name)
    static let cardTitle = Font.system(size: 18, weight: .semibold, design: .default)

    /// Subtitle text
    static let subtitle = Font.system(size: 16, weight: .medium, design: .default)

    // MARK: - Body Text

    /// Primary body text
    static let bodyText = Font.system(size: 16, weight: .regular, design: .default)

    /// Secondary body text
    static let bodySecondary = Font.system(size: 14, weight: .regular, design: .default)

    // MARK: - Supporting Text

    /// Captions and labels
    static let caption = Font.system(size: 12, weight: .regular, design: .default)

    /// Small caption for metadata
    static let captionSmall = Font.system(size: 10, weight: .regular, design: .default)

    // MARK: - Special Purpose

    /// Button text
    static let button = Font.system(size: 16, weight: .semibold, design: .default)

    /// Price display
    static let price = Font.system(size: 20, weight: .bold, design: .rounded)

    /// Rating numbers
    static let rating = Font.system(size: 18, weight: .semibold, design: .default)

    /// Tab bar items
    static let tabBar = Font.system(size: 10, weight: .medium, design: .default)
}

// MARK: - Text Style Modifiers
extension View {

    /// Apply coffee app primary heading style
    func coffeeHeading() -> some View {
        self
            .font(.sectionHeader)
            .foregroundColor(.textPrimary)
    }

    /// Apply coffee app subtitle style
    func coffeeSubtitle() -> some View {
        self
            .font(.subtitle)
            .foregroundColor(.textSecondary)
    }

    /// Apply coffee app caption style
    func coffeeCaption() -> some View {
        self
            .font(.caption)
            .foregroundColor(.textSecondary)
    }

    /// Apply coffee app price style
    func coffeePrice() -> some View {
        self
            .font(.price)
            .foregroundColor(.coffeeBrown)
    }

    /// Apply coffee app rating style
    func coffeeRating() -> some View {
        self
            .font(.rating)
            .foregroundColor(.ratingStars)
    }
}
