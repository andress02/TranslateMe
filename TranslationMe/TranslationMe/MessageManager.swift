//
//  MessageManager.swift
//  TranslationMe
//
//  Created by Andress Vizcaino Seolin on 10/17/24.
//

import Foundation
import FirebaseFirestore

@Observable
class MessageManager {
    var messages: [Message] = []
    private let dataBase = Firestore.firestore()

    init(isMocked: Bool = false) {
        if isMocked {
            // Comment out or remove the following line if you don't have mocked messages
            // messages = Message.mockedMessages
        } else {
            getMessages()
        }
    }

    func getMessages() {
        dataBase.collection("translations").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            let messages = documents.compactMap { document in
                try? document.data(as: Message.self)
            }
            
            self.messages = messages.sorted(by: { $0.timestamp < $1.timestamp })
        }
    }

    func saveTranslation(originalText: String, translatedText: String, username: String) {
        let message = Message(id: UUID().uuidString, originalText: originalText, translatedText: translatedText, timestamp: Date(), username: username)
        
        do {
            try dataBase.collection("translations").document(message.id).setData(from: message)
        } catch {
            print("Error saving translation to Firestore: \(error)")
        }
    }

    func deleteTranslation(_ message: Message) {
        dataBase.collection("translations").document(message.id).delete { error in
            if let error = error {
                print("Error deleting message: \(error)")
            }
        }
    }
}
