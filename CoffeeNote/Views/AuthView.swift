//
//  AuthView.swift
//  CoffeeNote
//
//  Created by Claude on 12/28/24.
//

import SwiftUI

struct AuthView: View {

    @StateObject private var viewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUpMode: Bool = false

    var body: some View {
        VStack(spacing: 30) {

            // App Logo and Title
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 80))
                .foregroundColor(.coffeeEspresso)

            Text("CoffeeNote")
                .font(.appTitle)
                .foregroundColor(.coffeeBrown)

            Text("Track your coffee adventures")
                .coffeeSubtitle()

            Spacer()

            // Sign In/Sign Up Form
            VStack(spacing: 20) {

                Text(isSignUpMode ? "Create Account" : "Welcome Back")
                    .coffeeHeading()

                // Email Field
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()

                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .coffeeCaption()
                        .foregroundColor(errorMessage.contains("sent") ? .coffeeGreen : .coffeeRed)
                        .multilineTextAlignment(.center)
                }

                // Sign In/Sign Up Button
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.coffeeBrown)
                } else {
                    Button(action: handleAuthAction) {
                        Text(isSignUpMode ? "Sign Up" : "Sign In")
                            .font(.button)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.buttonPrimary)
                            .cornerRadius(10)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)
                }

                // Toggle between Sign In and Sign Up
                Button(action: {
                    isSignUpMode.toggle()
                    viewModel.errorMessage = nil
                }) {
                    Text(isSignUpMode ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.bodySecondary)
                        .foregroundColor(.coffeeBrown)
                }
            }
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(15)

            Spacer()

            // Temporary Auth Note
            VStack(spacing: 5) {
                Text("Note: Using Email/Password for development")
                    .coffeeCaption()
                Text("Will switch to Sign in with Apple for production")
                    .coffeeCaption()
            }
            .padding(.bottom)
        }
        .padding()
        .background(Color.appBackground)
    }

    // MARK: - Actions
    private func handleAuthAction() {
        Task {
            if isSignUpMode {
                await viewModel.signUp(email: email, password: password)
            } else {
                await viewModel.signIn(email: email, password: password)
            }
        }
    }
}

#Preview {
    AuthView()
}
