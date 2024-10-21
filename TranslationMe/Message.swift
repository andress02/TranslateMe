//
//  Message.swift
//  TranslationMe
//
//  Created by Andress Vizcaino Seolin on 10/17/24.
//

import Foundation

struct Message: Hashable, Identifiable, Codable {
    let id: String
    let originalText: String
    let translatedText: String
    let timestamp: Date
    let username: String
}
