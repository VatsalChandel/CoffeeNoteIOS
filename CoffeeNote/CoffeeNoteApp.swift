//
//  CoffeeNoteApp.swift
//  CoffeeNote
//
//  Created by Vatsal Chandel on 12/28/25.
//

import SwiftUI

@main
struct CoffeeNoteApp: App {

    @StateObject private var authViewModel = AuthViewModel()

    // Initialize Firebase when app launches
    init() {
        FirebaseManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                AuthView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
