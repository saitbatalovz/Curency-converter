//
//  ExchangeRateModel.swift
//  Currency converter
//
//  Created by Zulfat Saitbatalov on 19.01.2023.
//

import Foundation
struct ExchangeRateModel {
    let currencyOne: String
    let currencyTwo: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
