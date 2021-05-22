//
//  CoinModel.swift
//  ByteCoinTicker
//
//  Created by Kurtis Hoang on 4/5/21.
//

import Foundation

struct CoinModel {
    let bitCoinCurrency: Double
    let bitCoinLabel: String
    
    var bitCoinCurrencyString: String {
        return String(format: "%.2f", bitCoinCurrency)
    }
}
