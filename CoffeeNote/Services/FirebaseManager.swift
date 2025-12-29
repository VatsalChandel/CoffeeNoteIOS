//
//  FirebaseManager.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

/// Singleton class to manage Firebase configuration and services
class FirebaseManager {

    // MARK: - Singleton Instance
    static let shared = FirebaseManager()

    // MARK: - Firebase Services
    // Use lazy properties so they're only initialized after FirebaseApp.configure() is called
    lazy var auth: Auth = {
        return Auth.auth()
    }()

    lazy var firestore: Firestore = {
        return Firestore.firestore()
    }()

    // MARK: - Initialization
    private init() {
        // Don't initialize Firebase services here
        // They'll be initialized lazily after configure() is called
    }

    /// Configure Firebase - should be called once at app launch
    func configure() {
        FirebaseApp.configure()
        print("✅ Firebase configured successfully")
    }

    /// Test Firebase connection by checking Firestore
    func testConnection() async throws {
        // Try to access Firestore to verify connection
        let testRef = firestore.collection("test")
        _ = try await testRef.getDocuments()
        print("✅ Firebase connection test successful")
    }
}
