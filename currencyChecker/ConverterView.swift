//
//  ConverterView.swift
//  currencyChecker
//
//  Created by Adam Makowski on 23/09/2024.
//

import SwiftUI

struct ConverterView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @State var inputCurrencyValue: Double? = nil
    @State var outputCurrencyValue: Double = 0.0
    @State var inputCurrency: ExchangeRate
    @State var outputCurrency: ExchangeRate
    
    @FocusState private var keyboardFocus: Bool
    
    init(inputCurrency: ExchangeRate, outputCurrency: ExchangeRate) {
        self.inputCurrency = inputCurrency
        self.outputCurrency = outputCurrency
    }
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Input value", value: $inputCurrencyValue, format: .currency(code: inputCurrency.code))
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding()
                    .cornerRadius(15)
                    .keyboardType(.decimalPad)
                    .onSubmit {keyboardFocus = false}
                    .focused($keyboardFocus)
                    .frame(maxWidth: .infinity)
                    .onChange(of: [inputCurrencyValue ?? 0.0, inputCurrency.mid, outputCurrency.mid]) { newValue in
                        withAnimation {
                            outputCurrencyValue = inputCurrency.mid*newValue[0]/outputCurrency.mid
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                keyboardFocus = false
                            }
                        }
                    }
                CurrencyPickerView(pickedCurrency: $inputCurrency)
                    .padding(.horizontal)
                Button {
                    withAnimation{
                        (inputCurrency, outputCurrency) = (outputCurrency, inputCurrency)
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                    
                }
                .tint(.primary)
                .padding()
                
                CurrencyPickerView(pickedCurrency: $outputCurrency)
                    .padding(.horizontal)
                
                Text(outputCurrencyValue, format: .currency(code: outputCurrency.code))
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .fontWeight(.heavy)
                    .contentTransition(.numericText())
                
            }
        }
    }
}

#Preview {
    ConverterView(inputCurrency: ExchangeRate(currency: "Polski Złoty", code: "PLN", mid: 1.0), outputCurrency: ExchangeRate(currency: "Dolar Amerykański", code: "USD", mid: 4.5))
        .environmentObject(HomeViewModel())
}
