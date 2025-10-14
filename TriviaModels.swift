//
//  TriviaModels.swift
//  Trivia Game
//
//  Created by shaun amoah on 10/14/25.
//

import Foundation

// MARK: - API Response Model
struct TriviaResponse: Codable {
    let responseCode: Int
    let results: [TriviaQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

// MARK: - Trivia Question Model
struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
    // Get all answers shuffled
    var allAnswers: [String] {
        (incorrectAnswers + [correctAnswer]).shuffled()
    }
    
    // Decode HTML entities
    var decodedQuestion: String {
        question.htmlDecoded
    }
    
    var decodedCorrectAnswer: String {
        correctAnswer.htmlDecoded
    }
    
    var decodedAllAnswers: [String] {
        allAnswers.map { $0.htmlDecoded }
    }
}

// MARK: - String Extension for HTML Decoding
extension String {
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
