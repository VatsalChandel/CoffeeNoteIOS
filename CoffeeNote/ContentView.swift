//
//  ContentView.swift
//  CoffeeNote
//
//  Created by Vatsal Chandel on 12/28/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.coffeeEspresso)

                Text("CoffeeNote")
                    .font(.appTitle)
                    .foregroundColor(.coffeeBrown)

                Text("Welcome!")
                    .coffeeHeading()

                if let email = authViewModel.currentUser?.email {
                    Text(email)
                        .coffeeSubtitle()
                }

                Spacer()

                Text("Coming soon:")
                    .coffeeHeading()

                VStack(alignment: .leading, spacing: 10) {
                    Label("Log coffee shop visits", systemImage: "checkmark.circle")
                    Label("Track your wishlist", systemImage: "checkmark.circle")
                    Label("View shops on a map", systemImage: "checkmark.circle")
                    Label("See your statistics", systemImage: "checkmark.circle")
                }
                .font(.bodySecondary)
                .foregroundColor(.textSecondary)

                Spacer()

                // Test Location Services
                NavigationLink(destination: LocationTestView()) {
                    Text("Test Location Services")
                        .font(.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.coffeeGold)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Test Firestore Services
                NavigationLink(destination: FirestoreTestView()) {
                    Text("Test Firestore Services")
                        .font(.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.coffeeLatte)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Sign Out")
                        .font(.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.coffeeRed)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.appBackground)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
