//
//  CurencyManager.swift
//  Currency converter
//
//  Created by Zulfat Saitbatalov on 19.01.2023.
//

import Foundation

protocol CurrencyManagerDelegate {
    func didFailWithError(_ error: Error)
    func didUpdateExchangeRate(_ exchangeRate: ExchangeRateModel)
}

struct CurrencyManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "22ACFFEE-F4DB-4780-B82A-D7B1DFFAD9FC"
    var delegate: CurrencyManagerDelegate?
    var selectedCurrencyOne: String
    var selectedCurrencyTwo: String
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    init(selectedCurrencyOne: Int, selectedCurrencyTwo: Int) {
        self.selectedCurrencyOne = currencyArray[selectedCurrencyOne]
        self.selectedCurrencyTwo = currencyArray[selectedCurrencyTwo]
    }
    
    func getCurrencyRate() {
        let urlString = "\(baseURL)/\(selectedCurrencyOne)/\(selectedCurrencyTwo)?apikey=\(apiKey)"
//        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        let url = URL(string: urlString)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                delegate?.didFailWithError(error!)
            }
            if let safeData = data {
                if let exchangeRate = parseJSON(safeData) {
                    delegate?.didUpdateExchangeRate(exchangeRate)
                }
                
            }
        }
        task.resume()
    }
    
    func parseJSON(_ exchangeRateData: Data) -> ExchangeRateModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ExchangeRateData.self, from: exchangeRateData)
            let currencyOne = decodedData.asset_id_base
            let currencyTwo = decodedData.asset_id_quote
            let rate = decodedData.rate
            let exchangeRate = ExchangeRateModel(currencyOne: currencyOne, currencyTwo: currencyTwo, rate: rate)
            return exchangeRate
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}

