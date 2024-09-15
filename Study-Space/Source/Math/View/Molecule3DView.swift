//
//  Molecule3DView.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Molecule3DView: View {
    @Environment(\.dismissWindow) private var dismissWindow
    
    let molecules = ["CarbonDioxide", "Hydrogen", "Methane", "Oxygen", "Water"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Close") {
                    dismissWindow()
                }
                .padding()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(molecules, id: \.self) { molecule in
                        VStack {
                            InteractiveMoleculeView(moleculeName: molecule)
                            Text(molecule)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct InteractiveMoleculeView: View {
    let moleculeName: String
    @State private var scale: CGFloat = 0.75
    @State private var position: CGSize = .zero
    
    var body: some View {
        Model3D(named: moleculeName, bundle: realityKitContentBundle) { model in
            model
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
        } placeholder: {
            ProgressView()
        }
        .scaleEffect(scale)
        .offset(x: position.width, y: position.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    position = value.translation
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    scale = value
                }
        )
    }
}

#Preview {
    Molecule3DView()
}
