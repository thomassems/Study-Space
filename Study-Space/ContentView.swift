//
//  ContentView.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var showLibrary = false
    @State private var opacity = 1.0

    var body: some View {
        ZStack {
            startPage
                .opacity(opacity)
            
            if showLibrary {
                LibraryView()
                    .opacity(1 - opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: opacity)
    }
    
    var startPage: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20) {
                Image(systemName: "pencil.and.outline")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.primary)
                
                Text("Welcome to Study Space")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showLibrary = true
                    opacity = 0
                }
            }) {
                Text("Enter Study Space")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
            }
            .tint(Color.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
