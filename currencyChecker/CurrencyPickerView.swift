//
//  CurrencyPickerView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 23/09/2024.
//

import SwiftUI
import FlagsKit

struct CurrencyPickerView: View {
    
    @Binding var pickedCurrency: ExchangeRate
    @State var searchText: String = ""
    @State var showPicker: Bool = false
    
    @EnvironmentObject var vm : HomeViewModel
    
    var body: some View {
        VStack(spacing: 0){
            Button {
                withAnimation(.easeInOut) {
                    showPicker.toggle()
                }
            } label: {
                HStack{
                    if let countryCode = Country.countryCode(fromCurrencyCode: pickedCurrency.code){
                        FlagView(countryCode: countryCode)
                            .scaledToFit()
                            .frame(width: 40, height: 30)
                    }
                    else{
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 40, height: 20)
                            .shadow(radius: 10)
                    }
                    Text(pickedCurrency.code)
                        .font(.title3.weight(.heavy))
                        .padding(.horizontal, 10)
                    Spacer()
                    Text(pickedCurrency.currency.capitalized)
                        .font(.headline)
                        .fontWeight(.light)
                    Spacer()
                }
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(20)
            .tint(.primary)
            
            if showPicker{
                TextField("\(Image(systemName: "magnifyingglass")) Search currencies", text: $searchText)
                    .padding(.horizontal)
                    .padding(8)
                    .background()
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
                List{
                    ForEach(filteredCurrencies) { rate in
                        HStack{
                            if let countryCode = Country.countryCode(fromCurrencyCode: rate.code){
                                FlagView(countryCode: countryCode)
                                    .scaledToFit()
                                    .frame(width: 40, height: 30)
                            }
                            else{
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 40, height: 20)
                                    .shadow(radius: 10)
                            }
                            Text(rate.code)
                                .font(.title3.weight(.heavy))
                                .padding(.horizontal, 10)
                            Spacer()
                            Text(rate.currency.capitalized)
                                .font(.headline)
                                .fontWeight(.light)
                            Spacer()
                        }
                        .background()
                        .onTapGesture {
                            withAnimation {
                                pickedCurrency = rate
                                showPicker = false
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(.thinMaterial)
        .cornerRadius(20)
        
        var filteredCurrencies: [ExchangeRate] {
            if searchText.isEmpty {
                return vm.exchangeRates
            }
            else {
                return vm.exchangeRates.filter { rate in
                    (rate.currency.lowercased().contains(searchText.lowercased()) ||
                     rate.code.lowercased().contains(searchText.lowercased()))
                }
            }
        }
    }
}

#Preview {
    CurrencyPickerView(pickedCurrency: .constant(ExchangeRate.init(currency: "Dolar Amerykański", code: "USD", mid: 1.0000)))
        .environmentObject(HomeViewModel())
}
