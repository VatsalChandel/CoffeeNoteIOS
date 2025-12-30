//
//  VisitCardView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI

/// Reusable card component to display a coffee shop visit summary
struct VisitCardView: View {

    let visit: CoffeeShopVisit

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header: Shop Name and Date
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(visit.shopName)
                        .font(.cardTitle)
                        .foregroundColor(.textPrimary)

                    Text(visit.dateVisited, style: .date)
                        .coffeeCaption()
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                Image(systemName: "cup.and.saucer.fill")
                    .font(.title2)
                    .foregroundColor(.coffeeEspresso.opacity(0.3))
            }

            // Rating and Price
            HStack {
                StarRatingDisplay(rating: visit.rating)

                Spacer()

                Text("$\(String(format: "%.2f", visit.price))")
                    .coffeePrice()
            }

            // Items Ordered
            if !visit.itemsOrdered.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "cup.and.saucer")
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    Text(visit.itemsOrdered.prefix(3).joined(separator: ", "))
                        .font(.bodySecondary)
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)

                    if visit.itemsOrdered.count > 3 {
                        Text("+\(visit.itemsOrdered.count - 3)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }

            // Address
            HStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                    .font(.caption)
                    .foregroundColor(.textSecondary)

                Text(visit.address)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }

            // Notes Preview (if exists)
            if let notes = visit.notes, !notes.isEmpty {
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "note.text")
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        VisitCardView(visit: .sample)

        VisitCardView(visit: CoffeeShopVisit(
            userId: "test",
            shopName: "Stumptown Coffee",
            address: "789 Pine St, Portland, OR",
            latitude: 45.5231,
            longitude: -122.6765,
            itemsOrdered: ["Espresso", "Pastry", "Cold Brew", "Latte"],
            rating: 5.0,
            price: 18.75,
            notes: "Amazing single-origin beans! The barista was super knowledgeable."
        ))
    }
    .padding()
    .background(Color.appBackground)
}
