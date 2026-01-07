import SwiftUI

struct stworz_fiszke: View {
    var targetSetId: UUID?
    
    @EnvironmentObject var manager: FlashcardManager
    @Environment(\.dismiss) var dismiss
    
    enum Field {
        case pojecie
        case definicja
    }
    
    @FocusState private var focusedField: Field?
    
    @State private var pojecie: String = ""
    @State private var definicja: String = ""
    @State private var showToast = false
    
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
            
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Image("cringly")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .padding(.top, 20)

                        Text("Szybkie dodawanie")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        VStack(alignment: .leading) {
                            Text("Pojęcie:")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            TextEditor(text: $pojecie)
                                .focused($focusedField, equals: .pojecie)
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
                            TextEditor(text: $definicja)
                                .focused($focusedField, equals: .definicja)
                                .frame(height: 100)
                                .cornerRadius(10)
                                .scrollContentBackground(.hidden)
                                .background(Color.white)
                        }
                        .padding(.horizontal)

                        Button(action: {
                            dodajFiszke()
                        }) {
                            Text("Dodaj i następna")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.green)
                                .cornerRadius(10)
                                .padding(.horizontal, 30)
                                .shadow(radius: 5)
                        }
                        .padding(.top, 20)
                    }
                }
            }
            
            if showToast {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Dodano fiszkę!")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(100)
            }
        }
        .onAppear {
            focusedField = .pojecie
        }
    }
    
    func dodajFiszke() {
        if let id = targetSetId, !pojecie.isEmpty, !definicja.isEmpty {
            
            manager.addCard(to: id, term: pojecie, definition: definicja)
            
            pojecie = ""
            definicja = ""
            
            withAnimation(.spring()) {
                showToast = true
            }
            
            focusedField = .pojecie
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showToast = false
                }
            }
        }
    }
}

#Preview {
    stworz_fiszke()
        .environmentObject(FlashcardManager())
}
