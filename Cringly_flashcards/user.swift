//
//  user.swift
//  Cringly_flashcards
//
//  Created by Michał Podłaszczyk on 07/11/2025.
//

import SwiftUI

struct user: View {
    @State private var zielony = Color.green.opacity(0.8)
    @State private var bialy = Color.white
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()

                VStack {
                    // 🟢 Właściwy panel logowania
                    VStack(spacing: 20) {
                        // Logo
                        Image("cringly") // <-- podmień na swój plik PNG
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding(.top, 40)

                        // Tekst powitalny
                        Text("Witamy w Cringly Flashcards!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.green.opacity(0.8))
                            .padding(.bottom, 10)

                        // Pola tekstowe
                        
                        
                        VStack(spacing: 15) {
                            Button(action: {
                                // logika logowania
                            }) {
                                Text("Zaloguj")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 30)
                            }
                            Button(action: {
                                // tryb bez logowania
                            }) {
                                Text("Zarejestruj się")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 30)
                            }

                            Button(action: {
                                // tryb bez logowania
                            })
                            {
                                Text("Tryb bez logowania")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.green.opacity(0.9))
                            }
                            
                        }
                        .padding(.bottom, 40)
                    }
                    .background(
                        Color.white
                            .opacity(0.95)
                            .cornerRadius(25)
                            .shadow(radius: 8)
                    )
                    .padding(20)
                }
                .background(
                    Color.black.opacity(0.2)
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 20)

                Spacer()
            }
        }
    }
}











#Preview {
    user()
}
