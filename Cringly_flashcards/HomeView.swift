import SwiftUI

struct HomeView: View {
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

                    VStack(spacing: 20) {
                        
                        NavigationLink(destination: SetsView()) {
                            HStack {
                                Image(systemName: "rectangle.stack.fill")
                                    .font(.title)
                                    .frame(width: 40) // Stała szerokość ikony dla równości
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
