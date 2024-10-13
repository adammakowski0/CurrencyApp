//
//  TabBarItem.swift
//  currencyChecker
//
//  Created by Adam Makowski on 13/10/2024.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case home, converter, settings
    
    var symbol: String {
        switch self {
        case .home: return "house"
        case .converter: return "arrow.left.arrow.right.square"
        case .settings: return "gearshape"
        }
    }
    var title: String {
        switch self {
        case .home: return "Home"
        case .converter: return "Converter"
        case .settings: return "Settings"
        }
    }
    
    var color: Color {
        switch self {
        default: Color("tabBarColor")
        }
    }
}
