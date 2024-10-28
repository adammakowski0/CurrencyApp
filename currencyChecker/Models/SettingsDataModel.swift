//
//  SettingDataModel.swift
//  currencyChecker
//
//  Created by Adam Makowski on 28/10/2024.
//

import Foundation

struct SettingsData: Codable {
    var favouriteRatesCodes: [String]
    var mainRateCode: String
}
