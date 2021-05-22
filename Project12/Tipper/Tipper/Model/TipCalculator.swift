//
//  TipCalculator.swift
//  Tipper
//
//  Created by Kurtis Hoang on 4/3/21.
//

import Foundation

struct TipCalculator {
    
    var reciept: Reciept?
    
    func getCalculatedBill() -> Float {
        return reciept?.calculatedBill ?? 0.0
    }
    
    func getSplit() -> Int {
        return reciept?.split ?? 0
    }
    
    func getTip() -> Float {
        return reciept?.tip ?? 0.0
    }
    
    mutating func calculateBill(_ bill: Float, _ tip: Float, _ split: Int)
    {
        let billTip = bill * tip
        let calcuatedBill = (bill + billTip) / Float(split)
        
        reciept = Reciept(calculatedBill: calcuatedBill, bill: bill, tip: tip, split: split)
    }
    
}
