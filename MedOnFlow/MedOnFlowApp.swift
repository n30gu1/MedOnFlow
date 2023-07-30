//
//  MedOnFlowApp.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import SwiftUI
import SwiftData
import Observation

@main
struct MedOnFlowApp: App {
    @Bindable private var viewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.signInState {
            case .notSignedIn:
                SignInView(viewModel: viewModel)
            case .signedIn:
                ContentView()
                    .modelContainer(for: Item.self)
            case .loading:
                EmptyView()
            }
        }
    }
}
