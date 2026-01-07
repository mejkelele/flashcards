import Foundation
import SwiftUI
import Combine

struct Flashcard: Identifiable, Codable, Hashable {
    var id = UUID()
    var term: String
    var definition: String
    var masteryLevel: Int = 0 // 0 = nowe, 1 = kojarzę, 2 = umiem, 3 = mistrz
}

struct FlashcardSet: Identifiable, Codable {
    var id = UUID()
    var title: String
    var cards: [Flashcard]
}

class FlashcardManager: ObservableObject {
    @Published var sets: [FlashcardSet] = [] {
        didSet { save() }
    }
    
    private let saveKey = "SavedFlashcardsData"
    
    init() { load() }
    
    
    func markCard(cardId: UUID, in setID: UUID, known: Bool) {
        guard let setIndex = sets.firstIndex(where: { $0.id == setID }),
              let cardIndex = sets[setIndex].cards.firstIndex(where: { $0.id == cardId }) else { return }
        
        var card = sets[setIndex].cards[cardIndex]
        
        if known {
            card.masteryLevel = min(card.masteryLevel + 1, 3)
        } else {
            card.masteryLevel = 0
        }
        
        sets[setIndex].cards[cardIndex] = card
    }
    
    func addSet(title: String) {
        let newSet = FlashcardSet(title: title, cards: [])
        sets.append(newSet)
    }
    
    func addCard(to setID: UUID, term: String, definition: String) {
        if let index = sets.firstIndex(where: { $0.id == setID }) {
            let newCard = Flashcard(term: term, definition: definition)
            sets[index].cards.append(newCard)
        }
    }
    
    func updateCard(in setID: UUID, card: Flashcard) {
        if let setIndex = sets.firstIndex(where: { $0.id == setID }),
           let cardIndex = sets[setIndex].cards.firstIndex(where: { $0.id == card.id }) {
            sets[setIndex].cards[cardIndex] = card
        }
    }
    
    func deleteSet(at offsets: IndexSet) { sets.remove(atOffsets: offsets) }
    
    func deleteCard(from setID: UUID, at offsets: IndexSet) {
        if let index = sets.firstIndex(where: { $0.id == setID }) {
            sets[index].cards.remove(atOffsets: offsets)
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(sets) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([FlashcardSet].self, from: data) {
            sets = decoded
        }
    }
}
