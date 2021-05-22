//
//  CoinData.swift
//  ByteCoinTicker
//
//  Created by Kurtis Hoang on 4/5/21.
//

import Foundation

//Typealias combines two protocols into one
//Codeable = Decodeable and Encodeable
//Decodeable = decode JSON to data
//Encodeable = encode data to JSON

struct CoinData: Codable {
    let asset_id_quote: String
    let rate: Double
}
