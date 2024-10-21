//
//  TranslationMeApp.swift
//  TranslationMe
//
//  Created by Andress Vizcaino Seolin on 10/17/24.
//

import SwiftUI
import FirebaseCore

@main
struct TranslationMeApp: App {
    @State private var authManager: AuthManager

    init() {
        FirebaseApp.configure()
        authManager = AuthManager()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
        }
    }
}
