//
//  ShopVisitsDetailView.swift
//  CoffeeNote
//
//  Created by Claude on 2/2/26.
//

import SwiftUI

/// Detail view showing all visits to a specific coffee shop
struct ShopVisitsDetailView: View {
    let mapPin: MapPin
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedVisit: CoffeeShopVisit?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header - Shop Info
                    shopHeader
                    
                    // Statistics (if multiple visits)
                    if mapPin.visitCount > 1 {
                        statisticsSection
                    }
                    
                    // Visits List
                    visitsSection
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle(mapPin.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.coffeeBrown)
                }
            }
            .sheet(item: $selectedVisit) { visit in
                VisitDetailView(visit: visit)
                    .environmentObject(authViewModel)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var shopHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.title)
                    .foregroundColor(.coffeeBrown)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mapPin.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    if let firstVisit = mapPin.visits.first {
                        Text(firstVisit.address)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
            
            if mapPin.visitCount > 1 {
                Text("\(mapPin.visitCount) visits")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.coffeeBrown)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(15)
    }
    
    private var statisticsSection: some View {
        VStack(spacing: 15) {
            Text("Overall Statistics")
                .font(.sectionHeader)
                .foregroundColor(.coffeeBrown)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                // Average Rating
                StatisticCard(
                    icon: "star.fill",
                    title: "Avg Rating",
                    value: String(format: "%.1f", mapPin.averageRating),
                    color: .coffeeGold
                )
                
                // Average Price
                StatisticCard(
                    icon: "dollarsign.circle.fill",
                    title: "Avg Price",
                    value: "$\(String(format: "%.2f", mapPin.averagePrice))",
                    color: .coffeeGreen
                )
            }
        }
    }
    
    private var visitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(mapPin.visitCount > 1 ? "All Visits" : "Visit Details")
                .font(.sectionHeader)
                .foregroundColor(.coffeeBrown)
            
            VStack(spacing: 12) {
                ForEach(mapPin.visits) { visit in
                    VisitRow(visit: visit) {
                        selectedVisit = visit
                    }
                }
            }
        }
    }
}

// MARK: - Statistic Card
struct StatisticCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(15)
    }
}

// MARK: - Visit Row
struct VisitRow: View {
    let visit: CoffeeShopVisit
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Date Badge
                VStack(spacing: 2) {
                    Text(visit.dateVisited.formatted(.dateTime.month(.abbreviated)))
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                    
                    Text(visit.dateVisited.formatted(.dateTime.day()))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.coffeeBrown)
                    
                    Text(visit.dateVisited.formatted(.dateTime.year()))
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                }
                .frame(width: 50)
                .padding(.vertical, 8)
                .background(Color.appBackground)
                .cornerRadius(10)
                
                // Visit Details
                VStack(alignment: .leading, spacing: 6) {
                    // Items Ordered
                    if !visit.itemsOrdered.isEmpty {
                        Text(visit.itemsOrdered.joined(separator: ", "))
                            .font(.bodyText)
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                    }
                    
                    // Rating & Price
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.coffeeGold)
                            Text(String(format: "%.1f", visit.rating))
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.caption)
                                .foregroundColor(.coffeeGreen)
                            Text(String(format: "%.2f", visit.price))
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    // Notes Preview
                    if let notes = visit.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleVisits = [
        CoffeeShopVisit(
            userId: "test",
            shopName: "Blue Bottle Coffee",
            address: "123 Main St",
            latitude: 37.7749,
            longitude: -122.4194,
            itemsOrdered: ["Cappuccino", "Croissant"],
            rating: 4.5,
            price: 12.50,
            notes: "Great atmosphere",
            dateVisited: Date().addingTimeInterval(-86400 * 7)
        ),
        CoffeeShopVisit(
            userId: "test",
            shopName: "Blue Bottle Coffee",
            address: "123 Main St",
            latitude: 37.7749,
            longitude: -122.4194,
            itemsOrdered: ["Latte"],
            rating: 5.0,
            price: 8.00,
            notes: "Perfect latte art",
            dateVisited: Date()
        )
    ]
    
    ShopVisitsDetailView(mapPin: MapPin(visits: sampleVisits))
        .environmentObject(AuthViewModel())
}
