import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegisterMode = false
    
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isLoading = false

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
                Spacer()

                VStack(spacing: 20) {
                    Image("cringly")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(.top, 40)

                    Text(isRegisterMode ? "Utwórz konto" : "Witaj ponownie!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green.opacity(0.8))

                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding(.horizontal, 30)

                        SecureField("Hasło", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 30)
                    }

                    Button(action: {
                        handleAction()
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(isRegisterMode ? "Zarejestruj się" : "Zaloguj się")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    }
                    .disabled(isLoading)

                    Button(action: {
                        withAnimation {
                            isRegisterMode.toggle()
                            errorMessage = ""
                            email = ""
                            password = ""
                        }
                    }) {
                        Text(isRegisterMode ? "Masz już konto? Zaloguj się" : "Nie masz konta? Zarejestruj się")
                            .font(.footnote)
                            .foregroundColor(Color.green.opacity(0.9))
                            .underline()
                    }
                    .padding(.bottom, 20)
                }
                .background(Color.white.opacity(0.95))
                .cornerRadius(25)
                .shadow(radius: 8)
                .padding(20)

                Spacer()
            }
        }
        .alert("Błąd", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    func handleAction() {
        isLoading = true
        
        if isRegisterMode {
            authManager.register(email: email, password: password) { success, message in
                isLoading = false
                if !success {
                    errorMessage = message
                    showError = true
                }
            }
        } else {
            authManager.login(email: email, password: password) { success, message in
                isLoading = false
                if !success {
                    errorMessage = message
                    showError = true
                }
            }
        }
    }
}
