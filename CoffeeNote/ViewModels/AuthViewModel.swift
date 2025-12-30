//
//  AuthViewModel.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import Foundation
import Combine
import FirebaseAuth

/// ViewModel to manage authentication state and actions
@MainActor
class AuthViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    // MARK: - Services
    private let authService = AuthenticationService()
    private let profileService = UserProfileService()

    // MARK: - Initialization
    init() {
        checkAuthState()
        setupAuthStateListener()
    }

    // MARK: - Auth State
    /// Check if user is currently authenticated
    func checkAuthState() {
        if let user = authService.currentUser {
            self.isAuthenticated = true
            self.currentUser = user
        } else {
            self.isAuthenticated = false
            self.currentUser = nil
        }
    }

    /// Listen for auth state changes
    private func setupAuthStateListener() {
        FirebaseManager.shared.auth.addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.isAuthenticated = user != nil
                self?.currentUser = user
            }
        }
    }

    // MARK: - Sign Up
    /// Create a new user account
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // Create Firebase Auth user
            let user = try await authService.signUp(email: email, password: password)
            self.currentUser = user
            self.isAuthenticated = true

            // Create user profile in Firestore
            _ = try await profileService.createUserProfile(
                userId: user.uid,
                email: email
            )
            print("✅ User profile created in Firestore")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Sign up error: \(error.localizedDescription)")
        }

        isLoading = false
    }

    // MARK: - Sign In
    /// Sign in an existing user
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signIn(email: email, password: password)
            self.currentUser = user
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Sign in error: \(error.localizedDescription)")
        }

        isLoading = false
    }

    // MARK: - Sign Out
    /// Sign out the current user
    func signOut() {
        do {
            try authService.signOut()
            self.currentUser = nil
            self.isAuthenticated = false
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Sign out error: \(error.localizedDescription)")
        }
    }

    // MARK: - Password Reset
    /// Send password reset email
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.resetPassword(email: email)
            self.errorMessage = "Password reset email sent!"
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Password reset error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
