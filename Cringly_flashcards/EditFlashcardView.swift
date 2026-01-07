import SwiftUI

struct EditFlashcardView: View {
    var setId: UUID
    @State var card: Flashcard
    
    @EnvironmentObject var manager: FlashcardManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.6, blue: 0.3),
                    Color(red: 0.0, green: 0.8, blue: 0.5),
                    Color(red: 0.6, green: 1.0, blue: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Edycja Fiszki")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    Text("Pojęcie:")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    TextEditor(text: $card.term)
                        .frame(height: 60)
                        .cornerRadius(10)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                }
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("Definicja:")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    TextEditor(text: $card.definition)
                        .frame(height: 100)
                        .cornerRadius(10)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    zapiszZmiany()
                }) {
                    Text("Zapisz zmiany")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
        }
    }
    
    func zapiszZmiany() {
        manager.updateCard(in: setId, card: card)
        dismiss() // Wracamy do listy po zapisaniu
    }
}
