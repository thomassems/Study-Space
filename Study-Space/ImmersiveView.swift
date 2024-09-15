//
//  ImmersiveView.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersionState {
    static var shared = "" /// this is a global variable to store the current immersive state
}

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            guard let url = Bundle.main.url(forResource: ImmersionState.shared, withExtension: "jpg"),
                  let resource = try? await TextureResource(contentsOf: url) else {
                  // If the asset isn't available, something is wrong with the app.
                  fatalError("Unable to load texture.")
              }
              var material = UnlitMaterial()
              material.color = .init(texture: .init(resource))

              // Attach the material to a large sphere.
              let entity = Entity()
              entity.components.set(ModelComponent(
                  mesh: .generateSphere(radius: 1000),
                  materials: [material]
              ))

              // Ensure the texture image points inward at the viewer.
              entity.scale *= .init(x: -1, y: 1, z: 1)

              content.add(entity)
          }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
