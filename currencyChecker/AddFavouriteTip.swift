//
//  TipView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 14/10/2024.
//

import Foundation
import TipKit

@available(iOS 17.0, *)
struct AddFavouriteTip: Tip {
    
    static let setFavouriteEvent = Event(id: "setFavourite")
    
    var title: Text {
        Text("Add favourite currencies")
            .foregroundStyle(Color("tabBarColor"))
    }
    
    var message: Text? {
        Text("Tap and hold currency to add it to your favourites")
    }
    
    var image: Image? {
        Image(systemName: "star")
    }
    
    var rules: [Rule] {
        #Rule(Self.setFavouriteEvent) { event in
            event.donations.count == 0
        }
    }
}
