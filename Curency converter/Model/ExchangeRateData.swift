//
//  ExchangeRateData.swift
//  Currency converter
//
//  Created by Zulfat Saitbatalov on 19.01.2023.
//

import Foundation
struct ExchangeRateData: Decodable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}

