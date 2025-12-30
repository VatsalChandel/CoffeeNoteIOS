//
//  StarRatingPicker.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI

/// Reusable star rating picker with 0.5 increments (0.5 - 5.0)
struct StarRatingPicker: View {

    @Binding var rating: Double

    var maximumRating: Int = 5
    var color: Color = .ratingStars
    var size: CGFloat = 30

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...maximumRating, id: \.self) { index in
                starView(for: index)
                    .onTapGesture {
                        handleTap(at: index)
                    }
            }

            // Display rating value
            Text(String(format: "%.1f", rating))
                .font(.rating)
                .foregroundColor(.coffeeBrown)
                .frame(minWidth: 40, alignment: .leading)
        }
    }

    // MARK: - Star View

    @ViewBuilder
    private func starView(for position: Int) -> some View {
        let fillAmount = starFillAmount(for: position)

        ZStack {
            // Background (empty star)
            Image(systemName: "star")
                .font(.system(size: size))
                .foregroundColor(color.opacity(0.3))

            // Foreground (filled star)
            Image(systemName: starIcon(for: fillAmount))
                .font(.system(size: size))
                .foregroundColor(color)
        }
    }

    // MARK: - Helpers

    private func starFillAmount(for position: Int) -> Double {
        let difference = rating - Double(position - 1)

        if difference >= 1.0 {
            return 1.0 // Fully filled
        } else if difference > 0 {
            return difference // Partially filled
        } else {
            return 0.0 // Empty
        }
    }

    private func starIcon(for fillAmount: Double) -> String {
        if fillAmount >= 1.0 {
            return "star.fill"
        } else if fillAmount >= 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }

    private func handleTap(at position: Int) {
        let newRating = Double(position)

        // If tapping the same star, toggle between full and half
        if rating == newRating {
            rating = newRating - 0.5
        } else if rating == newRating - 0.5 {
            rating = newRating
        } else {
            rating = newRating
        }

        // Ensure rating stays within bounds (0.5 - 5.0)
        if rating < 0.5 {
            rating = 0.5
        }
    }
}

// MARK: - Display-Only Star Rating
struct StarRatingDisplay: View {

    var rating: Double
    var maximumRating: Int = 5
    var color: Color = .ratingStars
    var size: CGFloat = 16

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maximumRating, id: \.self) { index in
                starView(for: index)
            }

            Text(String(format: "%.1f", rating))
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }

    @ViewBuilder
    private func starView(for position: Int) -> some View {
        let fillAmount = starFillAmount(for: position)

        Image(systemName: starIcon(for: fillAmount))
            .font(.system(size: size))
            .foregroundColor(color)
    }

    private func starFillAmount(for position: Int) -> Double {
        let difference = rating - Double(position - 1)

        if difference >= 1.0 {
            return 1.0
        } else if difference > 0 {
            return difference
        } else {
            return 0.0
        }
    }

    private func starIcon(for fillAmount: Double) -> String {
        if fillAmount >= 1.0 {
            return "star.fill"
        } else if fillAmount >= 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        Text("Star Rating Picker")
            .font(.headline)

        StarRatingPicker(rating: .constant(4.5))

        StarRatingPicker(rating: .constant(3.0))

        StarRatingPicker(rating: .constant(2.5))

        Divider()

        Text("Display Only")
            .font(.headline)

        StarRatingDisplay(rating: 4.5)

        StarRatingDisplay(rating: 3.0, size: 20)
    }
    .padding()
}
