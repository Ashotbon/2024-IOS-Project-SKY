//
//  authsigninApp.swift
//  WeatherAppSKYUITests
//
//  Created by Ashot Harutyunyan on 2024-03-26.
//

import SwiftUI
import Firebase
@main
struct authsigninApp: App {
    @StateObject var viewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
         ContentView()
                .environmentObject(viewModel)
        }
    }
}
