//
//  QuizView.swift
//  Trivia Game
//
//  Created by shaun amoah on 10/14/25.
//


import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: TriviaViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.85, green: 0.95, blue: 0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        viewModel.stopTimer()
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                }
                .padding()
                
                // Timer
                Text("Time remaining: \(viewModel.timeRemaining)s")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                // Questions List
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(Array(viewModel.questions.enumerated()), id: \.element.id) { index, question in
                            QuestionCard(
                                question: question,
                                questionNumber: index + 1,
                                selectedAnswer: viewModel.userAnswers[question.id],
                                showCorrectAnswer: viewModel.showingScore
                            ) { answer in
                                viewModel.selectAnswer(questionID: question.id, answer: answer)
                            }
                        }
                    }
                    .padding()
                }
                
                // Submit Button
                Button {
                    viewModel.stopTimer()
                    viewModel.showingScore = true
                } label: {
                    Text("Submit")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.startTimer()
        }
        .alert("Score", isPresented: $viewModel.showingScore) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("You scored \(viewModel.calculateScore()) out of \(viewModel.questions.count)")
        }
    }
}

// MARK: - Question Card
struct QuestionCard: View {
    let question: TriviaQuestion
    let questionNumber: Int
    let selectedAnswer: String?
    let showCorrectAnswer: Bool
    let onAnswerSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(question.decodedQuestion)
                .font(.body)
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
            
            // DEBUG: Print answers
            let _ = print("📝 Answers: \(question.decodedAllAnswers)")
            
            VStack(spacing: 12) {
                ForEach(question.decodedAllAnswers, id: \.self) { answer in
                    AnswerButton(
                        answer: answer,
                        isSelected: selectedAnswer == answer,
                        isCorrect: showCorrectAnswer && answer == question.decodedCorrectAnswer,
                        showCorrectAnswer: showCorrectAnswer
                    ) {
                        onAnswerSelected(answer)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}
// MARK: - Answer Button
struct AnswerButton: View {
    let answer: String
    let isSelected: Bool
    let isCorrect: Bool
    let showCorrectAnswer: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(answer)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if showCorrectAnswer && isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
        }
        .disabled(showCorrectAnswer)
    }
    
    private var backgroundColor: Color {
        if showCorrectAnswer {
            return isCorrect ? Color.green.opacity(0.2) : (isSelected ? Color.red.opacity(0.2) : Color(.systemGray6))
        } else {
            return isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6)
        }
    }
}
