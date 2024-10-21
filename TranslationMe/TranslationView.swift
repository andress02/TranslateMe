//
//  TranslationView.swift
//  TranslationMe
//
//  Created by Andress Vizcaino Seolin on 10/17/24.
//

import SwiftUI

struct TranslationView: View {
    @Environment(AuthManager.self) var authManager
    @State var messageManager: MessageManager

    @State private var originalText: String = ""
    @State private var translatedText: String = ""
    @State private var isLoading: Bool = false

    init(isMocked: Bool = false) {
        messageManager = MessageManager(isMocked: isMocked)
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter text to translate", text: $originalText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                if isLoading {
                    ProgressView()
                } else {
                    Text(translatedText)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }

                Button("Translate") {
                    isLoading = true
                    TranslationService.translate(text: originalText) { result in
                        DispatchQueue.main.async {
                            isLoading = false
                            switch result {
                            case .success(let translation):
                                translatedText = translation
                                messageManager.saveTranslation(originalText: originalText, translatedText: translatedText, username: authManager.userEmail ?? "Unknown")
                            case .failure(let error):
                                print("Translation error: \(error)")
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()

                List {
                    ForEach(messageManager.messages) { message in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Original: \(message.originalText)")
                                    .font(.subheadline)
                                Text("Translated: \(message.translatedText)")
                                    .font(.body)
                            }
                            Spacer()
                            Button(role: .destructive) {
                                messageManager.deleteTranslation(message)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("TranslationMe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
