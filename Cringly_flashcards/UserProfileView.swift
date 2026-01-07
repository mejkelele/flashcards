import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var flashManager: FlashcardManager
    @EnvironmentObject var authManager: AuthManager
    
    var currentXP: Int { authManager.currentUser?.xp ?? 0 }
    
    func getRankName() -> String {
        switch currentXP {
        case 0..<100: return "Początkujący"
        case 100..<500: return "Student"
        case 500..<1000: return "Ekspert"
        case 1000..<5000: return "Mistrz Fiszki"
        default: return "Legenda Cringly"
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.green, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 140, height: 140)
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.white)
                    }
                    
                    Text(authManager.currentUser?.username ?? "Użytkownik")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(getRankName())
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("XP: \(currentXP)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 10)
                                .cornerRadius(5)
                            
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(width: 200 * (Double(currentXP % 500) / 500.0), height: 10)
                                .cornerRadius(5)
                        }
                        .frame(width: 200)
                    }
                }
                .padding(.top, 40)
                
                HStack(spacing: 20) {
                    StatCard(title: "Zestawy", value: "\(flashManager.sets.count)", icon: "folder.fill")
                    StatCard(title: "Fiszki", value: "\(totalFlashcardsCount())", icon: "rectangle.on.rectangle.angled")
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    authManager.logout()
                }) {
                    Text("Wyloguj się")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
    }
    
    func totalFlashcardsCount() -> Int {
        flashManager.sets.reduce(0) { sum, set in sum + set.cards.count }
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.green)
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
