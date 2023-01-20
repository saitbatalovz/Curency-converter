//
//  ViewController.swift
//  Currency converter
//
//  Created by Zulfat Saitbatalov on 19.01.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currencyOneLabel: UILabel!
    @IBOutlet weak var currencyTwoLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    lazy var defaultCurrencyIndexOne = 19
    lazy var defaultCurrencyIndexTwo = 16

    lazy var currencyManager = CurrencyManager(selectedCurrencyOne: defaultCurrencyIndexOne, selectedCurrencyTwo: defaultCurrencyIndexTwo)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyPicker.selectRow(defaultCurrencyIndexOne, inComponent: 0, animated: true)
        currencyPicker.selectRow(defaultCurrencyIndexTwo, inComponent: 1, animated: true)
        currencyManager.getCurrencyRate()

    }
}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyManager.currencyArray.count
    }
  
}
//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: currencyManager.selectedCurrencyOne = currencyManager.currencyArray[row]
        case 1: currencyManager.selectedCurrencyTwo = currencyManager.currencyArray[row]
        default:
            break
        }
        currencyManager.getCurrencyRate()
    }
}
//MARK: - CurrencyManagerDelegate
extension ViewController: CurrencyManagerDelegate {
    func didFailWithError(_ error: Error) {
        print(error)
    }
    func didUpdateExchangeRate(_ exchangeRate: ExchangeRateModel) {

        DispatchQueue.main.async {
            self.currencyOneLabel.text = "1 \(exchangeRate.currencyOne)"
            self.currencyTwoLabel.text = "\(exchangeRate.rateString) \(exchangeRate.currencyTwo)"

        }
    }
}
