//
//  LoginView.swift
//  TranslationMe
//
//  Created by Andress Vizcaino Seolin on 10/17/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) var authManager
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Welcome to TranslationMe!")
                .font(.largeTitle)

            VStack {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .padding(40)

            HStack {
                Button("Sign Up") {
                    authManager.signUp(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)

                Button("Login") {
                    authManager.signIn(email: email, password: password)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
