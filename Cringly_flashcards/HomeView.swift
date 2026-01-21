import Foundation
import SwiftUI
import Combine

// --- MODEL DANYCH NBP ---
struct NBPRate: Codable {
    let currency: String
    let code: String
    let mid: Double
}

struct NBPTable: Codable {
    let table: String
    let no: String
    let effectiveDate: String
    let rates: [NBPRate]
}

// --- MANAGER WALUT ---
class CurrencyManager: ObservableObject {
    @Published var ratesText: String = "Pobieranie kursów walut..."
    @Published var lastUpdated: String = ""
    
    func fetchRates() {
        // Tabela A kursów średnich w formacie JSON
        guard let url = URL(string: "https://api.nbp.pl/api/exchangerates/tables/A?format=json") else { return }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let _ = error {
                self.setFallback()
                return
            }
            
            guard let data = data else {
                self.setFallback()
                return
            }
            
            do {
                // API NBP zwraca tablicę tabel (dlatego [NBPTable].self)
                let tables = try JSONDecoder().decode([NBPTable].self, from: data)
                if let table = tables.first {
                    DispatchQueue.main.async {
                        self.processRates(table)
                    }
                }
            } catch {
                print("Błąd dekodowania NBP: \(error)")
                self.setFallback()
            }
        }.resume()
    }
    
    private func processRates(_ table: NBPTable) {
        // Szukamy Euro i Dolara
        let eur = table.rates.first(where: { $0.code == "EUR" })?.mid ?? 0.0
        let usd = table.rates.first(where: { $0.code == "USD" })?.mid ?? 0.0
        
        self.ratesText = String(format: "EUR: %.2f zł  |  USD: %.2f zł", eur, usd)
        self.lastUpdated = "Data kursu: \(table.effectiveDate)"
    }
    
    private func setFallback() {
        DispatchQueue.main.async {
            self.ratesText = "Kursy niedostępne (Offline)"
        }
    }
}

// --- WIDOK GŁÓWNY ---
struct HomeView: View {
    @StateObject var currencyManager = CurrencyManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Tło gradientowe
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

                VStack(spacing: 30) {
                    VStack {
                        Image(systemName: "greetingcard.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        Text("Menu Główne")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // --- WIDGET NBP (API) ---
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "banknote") // Ikona walut
                                .foregroundColor(.white)
                            Text("Aktualne kursy NBP:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Text(currencyManager.ratesText)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        
                        if !currencyManager.lastUpdated.isEmpty {
                            Text(currencyManager.lastUpdated)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal, 30)
                    .onAppear {
                        currencyManager.fetchRates()
                    }
                    // ------------------------

                    VStack(spacing: 20) {
                        NavigationLink(destination: SetsView()) {
                            HStack {
                                Image(systemName: "rectangle.stack.fill")
                                    .font(.title)
                                    .frame(width: 40)
                                Text("Moje zestawy i Fiszki")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .foregroundColor(.green)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }

                        NavigationLink(destination: UserProfileView()) {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.title)
                                    .frame(width: 40)
                                Text("Mój Profil")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .foregroundColor(.green)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal, 30)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
