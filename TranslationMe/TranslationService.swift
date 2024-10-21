//
//  TranslationService.swift
//  TranslationMe
//
//  Created by Andress Vizcaino Seolin on 10/17/24.
//

import Foundation

struct TranslationService {
    static func translate(text: String, from sourceLang: String = "en", to targetLang: String = "es", completion: @escaping (Result<String, Error>) -> Void) {
        let baseURL = "https://api.mymemory.translated.net/get"
        let query = "?q=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&langpair=\(sourceLang)|\(targetLang)"
        let urlString = baseURL + query

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }

            do {
                let result = try JSONDecoder().decode(TranslationResponse.self, from: data)
                completion(.success(result.responseData.translatedText))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct TranslationResponse: Codable {
    let responseData: TranslationData
}

struct TranslationData: Codable {
    let translatedText: String
}
