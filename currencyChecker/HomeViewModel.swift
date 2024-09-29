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

    var settingData: SettingsData = SettingsData(favouriteRates: [], mainRate: ExchangeRate(currency: "", code: "", mid: 1.0))
    
    @AppStorage("settingStorage") var settingStorage: Data = Data()

    init(){
        fetchData(table: "A")
        fetchData(table: "B")
        exchangeRates.append(ExchangeRate(currency: "Polski Złoty", code: "PLN", mid: 1.00))
        loadFromAppStorage()
    }
    
    func sortRates(){
        self.exchangeRates.sort{$0.mid > $1.mid}
        self.favouriteCurrencies.sort{$0.mid > $1.mid}
    }
    
    func fetchData(table: String) {
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
                    self?.exchangeRates.append(contentsOf: decodedResponse[0].rates)
                    self?.tableDate = decodedResponse[0].effectiveDate
                    self?.sortRates()
                }
                
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    func addToFavourites(rate: ExchangeRate) {
        if !favouriteCurrencies.contains(where: { $0.id == rate.id }) {
            favouriteCurrencies.append(rate)
            settingData.favouriteRates.append(rate)
            saveToAppStorage()
            sortRates()
        }
    }
    
    func deleteFromFavourites(rate: ExchangeRate) {
        favouriteCurrencies.removeAll { $0.id == rate.id }
        settingData.favouriteRates.removeAll { $0.id == rate.id }
        saveToAppStorage()
        sortRates()
    }
    
    func saveMainCurrencySetting() {
        settingData.mainRate = self.mainRate
        saveToAppStorage()
    }
    
    func saveToAppStorage() {
        guard let data = try? JSONEncoder().encode(settingData) else { return }
        self.settingStorage = data
    }
    
    func loadFromAppStorage() {
        
        guard let settingsData = try? JSONDecoder().decode(SettingsData.self, from: settingStorage) else { return }
        self.settingData.favouriteRates = settingsData.favouriteRates
        self.favouriteCurrencies = settingsData.favouriteRates
        self.settingData.mainRate = settingsData.mainRate
        self.mainRate = settingsData.mainRate
    }
}

struct ExchangeRatesResponse: Codable, Identifiable {
    
    let table: String
    let effectiveDate: String
    let rates: [ExchangeRate]
    
    var id: String { table }
}

struct ExchangeRate: Codable, Identifiable, Equatable {

    let currency: String
    let code: String
    let mid: Double
    
    var id: String { code }
}

struct SettingsData: Codable {
    var favouriteRates: [ExchangeRate]
    var mainRate: ExchangeRate
}
