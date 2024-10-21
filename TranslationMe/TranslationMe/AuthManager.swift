//
//  AuthManager.swift
//  TranslationMe
//
//  Created by Andress Vizcaino Seolin on 10/17/24.
//

import Foundation
import FirebaseAuth

@Observable
class AuthManager {
    var user: User?
    var isSignedIn: Bool = false

    var userEmail: String? {
        user?.email
    }

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isSignedIn = user != nil
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signUp(email: String, password: String) {
        Task {
            do {
                print("Attempting to sign up user with email: \(email)")
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                self.user = authResult.user
                print("Sign-up successful for user: \(authResult.user.email ?? "unknown")")
            } catch {
                print("Error during sign-up: \(error.localizedDescription)")
            }
        }
    }

    func signIn(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                self.user = authResult.user // Update the user after a successful login
            } catch {
                print("Error during sign-in: \(error.localizedDescription)")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error during sign-out: \(error.localizedDescription)")
        }
    }
}
