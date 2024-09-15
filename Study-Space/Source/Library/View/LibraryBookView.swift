//
//  LibraryBookView.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import SwiftUI

struct LibraryBookView: View {
    let book: Book
    @Binding var isFavorite: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                if let coverImageName = book.coverImageName,
                   let uiImage = UIImage(named: coverImageName, in: .main, with: nil) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fit)
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    Color.gray
                        .aspectRatio(2/3, contentMode: .fit)
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                Toggle(isOn: $isFavorite) {
                    EmptyView()
                }
                .toggleStyle(FavoriteToggleStyle())
                .padding(8)
            }
            
            Text(book.title)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 200)
    }
}

struct FavoriteToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            Image(systemName: configuration.isOn ? "star.fill" : "star")
                .foregroundColor(configuration.isOn ? .yellow : .gray)
                .imageScale(.large)
        }
    }
}
