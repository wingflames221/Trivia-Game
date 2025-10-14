//
//  TriviaAPIService.swift
//  Trivia Game
//
//  Created by shaun amoah on 10/14/25.
//

import Foundation

class TriviaAPIService {
    static let shared = TriviaAPIService()
    
    private let baseURL = "https://opentdb.com/api.php"
    
    func fetchTriviaQuestions(
        amount: Int,
        category: String?,
        difficulty: String,
        type: String
    ) async throws -> [TriviaQuestion] {
        
        var components = URLComponents(string: baseURL)!
        
        var queryItems = [
            URLQueryItem(name: "amount", value: "\(amount)")
        ]
        
        if let category = category, category != "Any Category" {
            queryItems.append(URLQueryItem(name: "category", value: getCategoryID(category)))
        }
        
        if difficulty != "any" {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty.lowercased()))
        }
        
        if type != "any" {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        print("🌐 Fetching URL: \(url.absoluteString)")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(TriviaResponse.self, from: data)
        
        print("✅ Fetched \(response.results.count) questions")
        
        return response.results
    }
    
    private func getCategoryID(_ category: String) -> String {
        let categories: [String: String] = [
            "General Knowledge": "9",
            "Entertainment: Books": "10",
            "Entertainment: Film": "11",
            "Entertainment: Music": "12",
            "Entertainment: Musicals & Theatres": "13",
            "Entertainment: Television": "14",
            "Entertainment: Video Games": "15",
            "Entertainment: Board Games": "16",
            "Science & Nature": "17",
            "Science: Computers": "18",
            "Science: Mathematics": "19",
            "Mythology": "20",
            "Sports": "21",
            "Geography": "22",
            "History": "23",
            "Politics": "24",
            "Art": "25",
            "Celebrities": "26",
            "Animals": "27",
            "Vehicles": "28",
            "Entertainment: Comics": "29",
            "Science: Gadgets": "30",
            "Entertainment: Japanese Anime & Manga": "31",
            "Entertainment: Cartoon & Animations": "32"
        ]
        
        return categories[category] ?? "9"
    }
}
