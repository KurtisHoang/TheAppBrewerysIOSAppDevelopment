//
//  ViewController.swift
//  ByteCoinTicker
//
//  Created by Kurtis Hoang on 4/5/21.
//

import UIKit

class CoinViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
        coinManager.delegate = self
        
        coinManager.getCoinPrice(for: coinManager.currencyArray[0])
    }
}

//MARK: - UIPickerView

extension CoinViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //determin number of components in pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //only one component which is BitCoin
    }
    
    //determine number of rows in each component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    //determine title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row] //get the index of pickerView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate

extension CoinViewController: CoinManagerDelegate {
    func didUpdateBitCoin(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.bitCoinLabel.text = coin.bitCoinLabel
            self.currencyLabel.text = coin.bitCoinCurrencyString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

