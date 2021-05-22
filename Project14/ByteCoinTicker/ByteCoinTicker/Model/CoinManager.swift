//
//  CoinManager.swift
//  ByteCoinTicker
//
//  Created by Kurtis Hoang on 4/5/21.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateBitCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    let apiKey = "Your_API_KEY"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String)
    {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    /*
     1.create url
     2.create session
     3.give session a task
     4.start task
     */
    
    func performRequest(with urlString: String)
    {
        //1
        if let url = URL(string: urlString) {
            //2
            let session = URLSession(configuration: .default)
            //3
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data{
                    if let bitCoin = parseJSON(with: safeData) {
                        delegate?.didUpdateBitCoin(self, coin: bitCoin)
                    }
                }
            }
            //4
            task.resume()
        }
    }
    
    func parseJSON(with data: Data) -> CoinModel? {
        
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            let currency = decodedData.rate
            let label = decodedData.asset_id_quote
            
            return CoinModel(bitCoinCurrency: currency, bitCoinLabel: label)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
