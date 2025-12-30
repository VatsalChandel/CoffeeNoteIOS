//
//  ItemsListEditor.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI

/// Reusable component for editing a list of items (e.g., items ordered at a coffee shop)
struct ItemsListEditor: View {

    @Binding var items: [String]
    @State private var newItem: String = ""
    @FocusState private var isInputFocused: Bool

    var placeholder: String = "Add item (e.g., Cappuccino)"
    var title: String = "Items Ordered"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text(title)
                .font(.subtitle)
                .foregroundColor(.coffeeBrown)

            // Add Item Field
            HStack {
                TextField(placeholder, text: $newItem)
                    .textInputAutocapitalization(.words)
                    .focused($isInputFocused)
                    .onSubmit {
                        addItem()
                    }

                Button(action: addItem) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.coffeeBrown)
                }
                .disabled(newItem.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(10)

            // Items List
            if !items.isEmpty {
                VStack(spacing: 5) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(.coffeeBrown)

                            Text(item)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)

                            Spacer()

                            Button(action: {
                                removeItem(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.coffeeRed)
                            }
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(8)
                    }
                }
            } else {
                Text("No items added yet")
                    .coffeeCaption()
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(8)
            }
        }
    }

    // MARK: - Actions

    private func addItem() {
        let trimmedItem = newItem.trimmingCharacters(in: .whitespaces)
        guard !trimmedItem.isEmpty else { return }

        items.append(trimmedItem)
        newItem = ""
        isInputFocused = true
    }

    private func removeItem(at index: Int) {
        items.remove(at: index)
    }
}

#Preview {
    ItemsListEditor(items: .constant(["Cappuccino", "Croissant", "Latte"]))
        .padding()
}
