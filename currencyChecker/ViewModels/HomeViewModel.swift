//
//  AppData.swift
//  currencyChecker
//
//  Created by Adam Makowski on 03/05/2024.
//

import Foundation
import SwiftUI

final class HomeViewModel : ObservableObject{
    
    @Published var exchangeRates: [ExchangeRate] = []
    @Published var tableDate: String?
    @Published var favouriteCurrencies : [ExchangeRate] = []
    @Published var searchText = ""
    @Published var mainRate = ExchangeRate(currency: "Polski Złoty", code: "PLN", mid: 1.0)
    @Published var dataLoaded: Bool = false
    @Published var loading: Bool = false
    @Published var numPadFocus: Bool = false
    @Published var keyboardFocus: Bool = false
    
    var settingData: SettingsData = SettingsData(favouriteRatesCodes: [], mainRateCode: "")
    
    var timer: Timer?
    
    @AppStorage("settingStorage") var settingStorage: Data = Data()

    init(){
        fetchData(table: "A")
        fetchData(table: "B")
        exchangeRates.append(ExchangeRate(currency: "Polski Złoty", code: "PLN", mid: 1.00))
    }
    
    func sortRates(){
        self.exchangeRates.sort{$0.mid > $1.mid}
        self.favouriteCurrencies.sort{$0.mid > $1.mid}
    }
    
    func fetchData(table: String) {
        dataLoaded = false
        loading = true
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { timer in
            self.loading = false
            return
        })
        guard let url = URL(string: "https://api.nbp.pl/api/exchangerates/tables/"+table) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url)  { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([ExchangeRatesResponse].self, from: data)  {
                DispatchQueue.main.async {
                    self?.dataLoaded = true
                    self?.timer?.invalidate()
                    self?.exchangeRates.append(contentsOf: decodedResponse[0].rates)
                    self?.tableDate = decodedResponse[0].effectiveDate
                    self?.sortRates()
                    self?.loadFromAppStorage()
                }
                
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    func addToFavourites(rate: ExchangeRate) {
        if !favouriteCurrencies.contains(where: { $0.id == rate.id }) {
            favouriteCurrencies.append(rate)
            settingData.favouriteRatesCodes.append(rate.code)
            saveToAppStorage()
            sortRates()
        }
        if #available(iOS 17.0, *) {
            Task { await AddFavouriteTip.setFavouriteEvent.donate() }
        }
    }
    
    func deleteFromFavourites(rate: ExchangeRate) {
        favouriteCurrencies.removeAll { $0.id == rate.id }
        settingData.favouriteRatesCodes.removeAll { $0 == rate.code }
        saveToAppStorage()
        sortRates()
    }
    
    func saveMainCurrencySetting() {
        settingData.mainRateCode = self.mainRate.code
        saveToAppStorage()
    }
    
    func saveToAppStorage() {
        guard let data = try? JSONEncoder().encode(settingData) else { return }
        self.settingStorage = data
    }
    
    func loadFromAppStorage() {
        
        guard let settingsData = try? JSONDecoder().decode(SettingsData.self, from: settingStorage) else { return }
        self.settingData.favouriteRatesCodes = settingsData.favouriteRatesCodes
        for rate in self.exchangeRates{
            for code in self.settingData.favouriteRatesCodes {
                if rate.code == code && !self.favouriteCurrencies.contains(rate){
                    self.favouriteCurrencies.append(rate)
                }
            }
            if rate.code == settingsData.mainRateCode {
                self.mainRate = rate
            }
        }
        self.settingData.mainRateCode = settingsData.mainRateCode
        
    }
}
