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
    
    @FocusState var keyboardFocus: Bool
    
    init(inputCurrency: ExchangeRate, outputCurrency: ExchangeRate) {
        self.inputCurrency = inputCurrency
        self.outputCurrency = outputCurrency
    }
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Input value", value: $inputCurrencyValue, format: .currency(code: inputCurrency.code))
                    .font(.largeTitle.weight(.heavy))
                    .roundedFontDesign()
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
                    .font(.largeTitle.weight(.heavy))
                    .roundedFontDesign()
                    .numericTextTransition()
                    .padding(.bottom, 40)
            }
            .onAppear { keyboardFocus = vm.keyboardFocus }
            .onChange(of: keyboardFocus) { vm.keyboardFocus = $0 }
            .onChange(of: vm.keyboardFocus) { keyboardFocus = $0 }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NumericTextViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .contentTransition(.numericText())
        }
        else {
            content
        }
    }
}

struct RoundedFontViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16.1, *) {
            content
                .fontDesign(.rounded)
        }
        else {
            content
        }
    }
}

public extension View {
    func numericTextTransition() -> some View {
        self.modifier(NumericTextViewModifier())
    }
    func roundedFontDesign() -> some View {
        self.modifier(RoundedFontViewModifier())
    }
}


#Preview {
    ConverterView(inputCurrency: ExchangeRate(currency: "Polski Złoty", code: "PLN", mid: 1.0), outputCurrency: ExchangeRate(currency: "Dolar Amerykański", code: "USD", mid: 4.5))
        .environmentObject(HomeViewModel())
}
