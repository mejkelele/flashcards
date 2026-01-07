import SwiftUI

struct StudyView: View {
    var cards: [Flashcard]
    var parentSetId: UUID?
    
    @EnvironmentObject var flashManager: FlashcardManager
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    @State private var currentIndex = 0
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if currentIndex < cards.count {
                VStack {
                    ProgressView(value: Double(currentIndex), total: Double(cards.count))
                        .tint(.green)
                        .padding(.horizontal)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    let card = cards[currentIndex]
                    FlashcardView(card: card, isFlipped: $isFlipped)
                        .frame(height: 400)
                        .padding()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isFlipped.toggle()
                            }
                        }
                    
                    Spacer()
                    
                    if isFlipped {
                        HStack(spacing: 40) {
                            Button(action: {
                                processAnswer(known: false)
                            }) {
                                VStack {
                                    Image(systemName: "xmark")
                                        .font(.largeTitle)
                                    Text("Nie wiem")
                                        .font(.caption)
                                }
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.red)
                                .clipShape(Circle())
                            }
                            
                            Button(action: {
                                processAnswer(known: true)
                            }) {
                                VStack {
                                    Image(systemName: "checkmark")
                                        .font(.largeTitle)
                                    Text("Umiem")
                                        .font(.caption)
                                }
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.green)
                                .clipShape(Circle())
                            }
                        }
                        .padding(.bottom, 50)
                        .transition(.scale)
                    } else {
                        Text("Dotknij karty, aby sprawdzić odpowiedź")
                            .foregroundColor(.gray)
                            .padding(.bottom, 80)
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow)
                    Text("Sesja zakończona!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Text("Twoje postępy zostały zapisane.")
                        .foregroundColor(.gray)
                    
                    Button("Wróć do menu") {
                        dismiss()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func processAnswer(known: Bool) {
        let currentCard = cards[currentIndex]
        
        if let setId = parentSetId {
            flashManager.markCard(cardId: currentCard.id, in: setId, known: known)
        }
        
        if known {
            authManager.addXP(amount: 10)
            NotificationManager.shared.cancelNotificationForToday()
        } else {
            authManager.addXP(amount: 2)
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isFlipped = false
            currentIndex += 1
        }
    }
}

struct FlashcardView: View {
    var card: Flashcard
    @Binding var isFlipped: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(radius: 10)
                .overlay(
                    Text(card.term)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .multilineTextAlignment(.center)
                )
                .opacity(isFlipped ? 0 : 1)
            
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(radius: 10)
                .overlay(
                    Text(card.definition)
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)

                )
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
        }
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
}
