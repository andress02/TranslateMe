//
//  ContentView.swift
//  TranslationMe
//
//  Created by Andress Vizcaino Seolin on 10/17/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) var authManager

    var body: some View {
        if authManager.user != nil {
            TranslationView()
                .environment(authManager)
        } else {
            LoginView()
                .environment(authManager)
        }
    }
}
