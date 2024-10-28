//
//  ExchangeRateModel.swift
//  currencyChecker
//
//  Created by Adam Makowski on 28/10/2024.
//

import Foundation

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
