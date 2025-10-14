//
//  OptionsView.swift
//  Trivia Game
//
//  Created by shaun amoah on 10/14/25.
//

import SwiftUI

struct OptionsView: View {
    @StateObject private var viewModel = TriviaViewModel()
    @State private var navigateToQuiz = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.blue.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Title
                    Text("Trivia Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 30)
                    
                    // Options Form
                    VStack(spacing: 20) {
                        // Number of Questions
                        // Number of Questions
                        Picker("Number of Questions", selection: $viewModel.numberOfQuestions) {
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("15").tag(15)
                            Text("20").tag(20)
                            Text("25").tag(25)
                            Text("30").tag(30)
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Category
                        Picker("Select Category", selection: $viewModel.selectedCategory) {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Difficulty
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Difficulty:")
                                Spacer()
                                Text(difficulty.capitalized)
                                    .foregroundColor(.gray)
                            }
                            
                            Slider(value: $difficultyValue, in: 0...2, step: 1)
                                .accentColor(.blue)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Type
                        Picker("Select Type", selection: $viewModel.questionType) {
                            Text("Any Type").tag("any")
                            Text("Multiple Choice").tag("multiple")
                            Text("True or False").tag("boolean")
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Timer Duration
                        Picker("Timer Duration", selection: $viewModel.timerDuration) {
                            Text("30 seconds").tag(30)
                            Text("60 seconds").tag(60)
                            Text("120 seconds").tag(120)
                            Text("300 seconds").tag(300)
                            Text("1 hour").tag(3600)
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Start Button
                    Button {
                        Task {
                            await viewModel.fetchQuestions()
                            navigateToQuiz = true
                        }
                    } label: {
                        Text("Start Trivia")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $navigateToQuiz) {
                QuizView(viewModel: viewModel)
            }
        }
    }
    
    @State private var difficultyValue: Double = 0 {
        didSet {
            switch difficultyValue {
            case 0:
                viewModel.difficulty = "easy"
            case 1:
                viewModel.difficulty = "medium"
            case 2:
                viewModel.difficulty = "hard"
            default:
                viewModel.difficulty = "easy"
            }
        }
    }
    
    private var difficulty: String {
        switch difficultyValue {
        case 0: return "easy"
        case 1: return "medium"
        case 2: return "hard"
        default: return "easy"
        }
    }
}

#Preview {
    OptionsView()
}
