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
    var currencyIndexOne : Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "IndexOne")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "IndexOne")
        }
    }
    
    var currencyIndexTwo : Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "IndexTwo")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "IndexTwo")
        }
    }

    lazy var currencyManager = CurrencyManager(selectedCurrencyIndexOne: currencyIndexOne, selectedCurrencyIndexTwo: currencyIndexTwo) 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        moveCurrencyPicker(animated: false)
    }
    
    @IBAction func swapButtonAction(_ sender: Any) {
        (currencyManager.selectedCurrencyIndexOne, currencyManager.selectedCurrencyIndexTwo) = (currencyManager.selectedCurrencyIndexTwo, currencyManager.selectedCurrencyIndexOne)
        (currencyIndexOne, currencyIndexTwo) = (currencyIndexTwo, currencyIndexOne)
        
        moveCurrencyPicker(animated: true)

    }
    
    func moveCurrencyPicker(animated: Bool) {
        currencyPicker.selectRow(currencyManager.selectedCurrencyIndexOne, inComponent: 0, animated: animated)
        currencyPicker.selectRow(currencyManager.selectedCurrencyIndexTwo, inComponent: 1, animated: animated)
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
        case 0: currencyManager.selectedCurrencyIndexOne = row
            currencyIndexOne = row
        case 1: currencyManager.selectedCurrencyIndexTwo = row
            currencyIndexTwo = row
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
