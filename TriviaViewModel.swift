//
//  TriviaViewModel.swift
//  Trivia Game
//
//  Created by shaun amoah on 10/14/25.
//

import SwiftUI

class TriviaViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var userAnswers: [UUID: String] = [:]
    @Published var isLoading = false
    @Published var showingScore = false
    @Published var timeRemaining = 60
    @Published var timerIsActive = false
    
    // Settings
    @Published var numberOfQuestions = 5
    @Published var selectedCategory = "Any Category"
    @Published var difficulty = "easy"
    @Published var questionType = "multiple"
    @Published var timerDuration = 60
    
    private var timer: Timer?
    
    let categories = [
        "Any Category",
        "General Knowledge",
        "Entertainment: Books",
        "Entertainment: Film",
        "Entertainment: Music",
        "Entertainment: Television",
        "Entertainment: Video Games",
        "Science & Nature",
        "Science: Computers",
        "Science: Mathematics",
        "Mythology",
        "Sports",
        "Geography",
        "History",
        "Politics",
        "Vehicles"
    ]
    
    func fetchQuestions() async {
        isLoading = true
        
        do {
            let fetchedQuestions = try await TriviaAPIService.shared.fetchTriviaQuestions(
                amount: numberOfQuestions,
                category: selectedCategory == "Any Category" ? nil : selectedCategory,
                difficulty: difficulty,
                type: questionType == "True or False" ? "boolean" : "multiple"
            )
            
            await MainActor.run {
                self.questions = fetchedQuestions
                self.currentQuestionIndex = 0
                self.userAnswers = [:]
                self.isLoading = false
                self.timeRemaining = timerDuration
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                print("❌ Error fetching questions: \(error)")
            }
        }
    }
    
    func selectAnswer(questionID: UUID, answer: String) {
        userAnswers[questionID] = answer
    }
    
    func calculateScore() -> Int {
        var correct = 0
        
        for question in questions {
            if let userAnswer = userAnswers[question.id],
               userAnswer == question.decodedCorrectAnswer {
                correct += 1
            }
        }
        
        return correct
    }
    
    func startTimer() {
        timerIsActive = true
        timeRemaining = timerDuration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.showingScore = true
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerIsActive = false
    }
    
    func resetGame() {
        questions = []
        currentQuestionIndex = 0
        userAnswers = [:]
        showingScore = false
        timeRemaining = timerDuration
        stopTimer()
    }
}
