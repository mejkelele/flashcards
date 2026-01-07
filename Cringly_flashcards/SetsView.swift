import SwiftUI

struct SetsView: View {
    @EnvironmentObject var manager: FlashcardManager
    @State private var showAddSetAlert = false
    @State private var newSetName = ""
    
    @State private var searchText = ""
    
    var filteredSets: [FlashcardSet] {
        if searchText.isEmpty {
            return manager.sets
        } else {
            return manager.sets.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Tło
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
                    Text("Twoje Zestawy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Szukaj zestawu...", text: $searchText)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    if filteredSets.isEmpty {
                        Spacer()
                        Text(searchText.isEmpty ? "Brak zestawów. Utwórz pierwszy!" : "Nie znaleziono zestawu.")
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredSets) { set in
                                NavigationLink(destination: SetDetailView(set: set)) {
                                    HStack {
                                        Image(systemName: "folder.fill")
                                            .foregroundColor(.green)
                                        VStack(alignment: .leading) {
                                            Text(set.title)
                                                .font(.headline)
                                            Text("\(set.cards.count) fiszek")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .onDelete(perform: deleteSet)
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddSetAlert = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
            }
            .alert("Nowy Zestaw", isPresented: $showAddSetAlert) {
                TextField("Nazwa zestawu", text: $newSetName)
                Button("Anuluj", role: .cancel) { }
                Button("Utwórz") {
                    if !newSetName.isEmpty {
                        manager.addSet(title: newSetName)
                        newSetName = ""
                    }
                }
            }
        }
    }
    
    func deleteSet(at offsets: IndexSet) {
        manager.deleteSet(at: offsets)
    }
}

#Preview {
    SetsView()
        .environmentObject(FlashcardManager())
}
