//
//  Study_SpaceApp.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//

import SwiftUI

@main
struct Study_SpaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
