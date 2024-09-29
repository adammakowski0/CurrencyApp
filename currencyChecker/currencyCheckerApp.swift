//
//  currencyCheckerApp.swift
//  currencyChecker
//
//  Created by Adam Makowski on 24/04/2024.
//

import SwiftUI

@main
struct currencyCheckerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(HomeViewModel())
        }
    }
}
