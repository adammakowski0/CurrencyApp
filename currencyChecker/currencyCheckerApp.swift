//
//  currencyCheckerApp.swift
//  currencyChecker
//
//  Created by Adam Makowski on 24/04/2024.
//

import SwiftUI
import TipKit

@main
struct currencyCheckerApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                HomeView()
                    .environmentObject(HomeViewModel())
                    .task {
                        try? Tips.configure([
                            .displayFrequency(.daily),
                            .datastoreLocation(.applicationDefault)
                        ])
                    }
            }
            else {
                HomeView()
                    .environmentObject(HomeViewModel())
            }
        }
    }
}
