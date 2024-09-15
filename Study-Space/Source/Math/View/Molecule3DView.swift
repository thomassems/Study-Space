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
    @State private var appeared = false
    
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
                HStack(spacing: 20) {
                    ForEach(Array(molecules.enumerated()), id: \.element) { index, molecule in
                        VStack {
                            InteractiveMoleculeView(moleculeName: molecule)
                                .opacity(appeared ? 1 : 0)
                                .animation(.easeIn(duration: 0.5).delay(Double(index) * 0.2), value: appeared)
                            Text(molecule)
                                .opacity(appeared ? 1 : 0)
                                .animation(.easeIn(duration: 0.5).delay(Double(index) * 0.2 + 0.3), value: appeared)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            withAnimation {
                appeared = true
            }
        }
    }
}

struct InteractiveMoleculeView: View {
    let moleculeName: String
    @State private var scale: CGFloat = 0.8
    @State private var position: CGSize = .zero
    @State private var rotation: simd_quatf = simd_quatf(angle: 0, axis: [0, 1, 0])
    @GestureState private var rotationAngle: Angle = .zero
    
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
        .rotation3DEffect(rotationAngle, axis: (x: 0, y: 1, z: 0))
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
        .gesture(
            RotationGesture()
                .updating($rotationAngle) { value, state, _ in
                    state = value
                }
                .onEnded { value in
                    let currentRotation = simd_quatf(angle: Float(rotationAngle.radians), axis: [0, 1, 0])
                    rotation = currentRotation * rotation
                }
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    let sensitivity: Float = 0.01
                    let dragX = Float(value.translation.width) * sensitivity
                    let dragY = Float(value.translation.height) * sensitivity
                    let rotationX = simd_quatf(angle: dragY, axis: [1, 0, 0])
                    let rotationY = simd_quatf(angle: dragX, axis: [0, 1, 0])
                    rotation = rotationY * rotationX * rotation
                }
        )
    }
}

#Preview {
    Molecule3DView()
}
