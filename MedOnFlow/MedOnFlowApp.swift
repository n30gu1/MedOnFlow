//
//  MedOnFlowApp.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import SwiftUI
import SwiftData

@main
struct MedOnFlowApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
