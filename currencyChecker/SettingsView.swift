//
//  SettingsView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 23/09/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        VStack{
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 25)
                .padding([.top, .bottom])
            Text("Choose main currency")
                .font(.headline)
                .padding(.horizontal,30)
                .frame(maxWidth: .infinity, alignment: .leading)
            CurrencyPickerView(pickedCurrency: $vm.mainRate)
                .padding(.horizontal)
                .onChange(of: vm.mainRate) { newValue in
                    withAnimation {
                        vm.saveMainCurrencySetting()
                    }
                }
            Spacer()
            Text("Source of currency data:")
                .font(.headline)
                .padding(.horizontal,30)
            Link("NBP Web API", destination: URL(string: "http://api.nbp.pl")!)
                .padding(.bottom)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    SettingsView()
        .environmentObject(HomeViewModel())
}
