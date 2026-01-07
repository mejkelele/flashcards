import SwiftUI

struct SetDetailView: View {
    var set: FlashcardSet
    @EnvironmentObject var manager: FlashcardManager
    
    @State private var searchText = ""
    
    var liveSet: FlashcardSet {
        manager.sets.first(where: { $0.id == set.id }) ?? set
    }
    
    // Filtrowanie fiszek
    var filteredCards: [Flashcard] {
        if searchText.isEmpty {
            return liveSet.cards
        } else {
            return liveSet.cards.filter {
                $0.term.localizedCaseInsensitiveContains(searchText) ||
                $0.definition.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            VStack {
                Text(liveSet.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                if !liveSet.cards.isEmpty {
                    HStack(spacing: 15) {
                        NavigationLink(destination: StudyView(cards: liveSet.cards, parentSetId: liveSet.id)) {
                            VStack {
                                Image(systemName: "play.fill")
                                    .font(.title2)
                                Text("Po kolei")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(15)
                            .shadow(radius: 3)
                        }
                        
                        NavigationLink(destination: StudyView(cards: liveSet.cards.shuffled())) {
                            VStack {
                                Image(systemName: "shuffle")
                                    .font(.title2)
                                Text("Losowo")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange) // Inny kolor dla odróżnienia
                            .cornerRadius(15)
                            .shadow(radius: 3)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                } else {
                    Text("Dodaj fiszki, aby rozpocząć naukę.")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Szukaj w zestawie...", text: $searchText)
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 10)
                
                List {
                    ForEach(filteredCards) { card in
                        NavigationLink(destination: EditFlashcardView(setId: liveSet.id, card: card)) {
                            VStack(alignment: .leading) {
                                Text(card.term)
                                    .font(.headline)
                                Text(card.definition)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .onDelete(perform: deleteCard)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: stworz_fiszke(targetSetId: liveSet.id)) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    func deleteCard(at offsets: IndexSet) {
        manager.deleteCard(from: liveSet.id, at: offsets)
    }
}
