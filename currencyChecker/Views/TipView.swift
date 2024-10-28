//
//  TipView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 14/10/2024.
//

import SwiftUI
import TipKit


@available(iOS 17.0, *)
struct AddFavouriteTipView: View {
    
    let addFavouritesTip = AddFavouriteTip()
    
    var body: some View {
        TipView(addFavouritesTip)
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        AddFavouriteTipView()
            .task {
                try? Tips.resetDatastore()
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
            }
    }
}
