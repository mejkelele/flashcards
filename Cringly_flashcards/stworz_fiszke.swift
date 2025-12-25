//
//  stworz_fiszke.swift
//  Cringly_flashcards
//
//  Created by Michał Podłaszczyk on 07/11/2025.
//

import SwiftUI

struct stworz_fiszke: View {
    @State private var pojecie: String = ""
    @State private var definicja: String = ""
    @State private var userProfileImage: UIImage? = nil
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.6, blue: 0.3),   // ciemna zieleń
                    Color(red: 0.0, green: 0.8, blue: 0.5),   // żywsza zieleń
                    Color(red: 0.6, green: 1.0, blue: 0.7)    // jasny akcent
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GeometryReader{geo in
                VStack(spacing: 20){
                    Image("cringly")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame( height: 100)
                        .padding(.top, 40)

                    if let image = userProfileImage {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width: 100, height: 100)
                                        } else {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.gray.opacity(0.6))
                                        }

                    TextEditor(text: $pojecie)
                        .frame(width: geo.size.width * 0.8, height: 60)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    TextEditor(text: $definicja)
                        .frame(width: geo.size.width * 0.8,height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    Button(action: {
                        // dodawanie
                    }) {
                        Text("Dodaj fiszke")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                    VStack {
                                    Image("cringly")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 100)
                                        .padding(.top, 40)
                                    
                                    Spacer() // Wypycha logo na samą górę ZStacka
                                }
                }
                .background(Color.blue
                    .opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
            
        }
    }
    }









#Preview {
    stworz_fiszke()
}
