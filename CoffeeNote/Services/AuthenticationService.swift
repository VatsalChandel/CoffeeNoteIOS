//
//  AuthenticationService.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import FirebaseAuth

/// Service to handle Firebase Email/Password authentication
/// NOTE: This is temporary for development. Will switch to Sign in with Apple when paid developer account is available.
class AuthenticationService {

    // MARK: - Properties
    private let auth = FirebaseManager.shared.auth

    // MARK: - Current User
    var currentUser: User? {
        return auth.currentUser
    }

    var isAuthenticated: Bool {
        return auth.currentUser != nil
    }

    // MARK: - Sign Up
    /// Create a new user account with email and password
    func signUp(email: String, password: String) async throws -> User {
        let result = try await auth.createUser(withEmail: email, password: password)
        print("✅ User signed up successfully: \(result.user.email ?? "no email")")
        return result.user
    }

    // MARK: - Sign In
    /// Sign in an existing user with email and password
    func signIn(email: String, password: String) async throws -> User {
        let result = try await auth.signIn(withEmail: email, password: password)
        print("✅ User signed in successfully: \(result.user.email ?? "no email")")
        return result.user
    }

    // MARK: - Sign Out
    /// Sign out the current user
    func signOut() throws {
        try auth.signOut()
        print("✅ User signed out successfully")
    }

    // MARK: - Password Reset
    /// Send password reset email
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
        print("✅ Password reset email sent to: \(email)")
    }
}
