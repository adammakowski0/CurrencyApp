//
//  CurrencyRowView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 17/09/2024.
//

import SwiftUI
import FlagsKit

struct CurrencyRowView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    var rate: ExchangeRate

    var body: some View {
        HStack(spacing: 2){
            
            ZStack{
                
                if rate.code != "NPR"{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 55, height: 25)
                        .shadow(radius: 10)
                }
                
                if let countryCode = Country.countryCode(fromCurrencyCode: rate.code){
                    FlagView(countryCode: countryCode)
                        .scaledToFit()
                        .frame(width: 50)
                }
            }
            Text(rate.code)
                .font(.title3.weight(.heavy))
                .font(.title)
                .padding(10)
            Text(rate.currency.capitalized)
                .font(.headline)
                .fontWeight(.light)
            Spacer()
            Text("\(rateMidValue, specifier: "%.3f") \(vm.mainRate.code)")
                .lineLimit(1)
                .font(.headline.weight(.semibold))
        }
    }
    
    var rateMidValue: Double{
        return rate.mid/vm.mainRate.mid
    }
}

#Preview {
    CurrencyRowView(rate: ExchangeRate(currency: "Dolar amerykański", code: "USD", mid: 4.5))
        .environmentObject(HomeViewModel())
}
