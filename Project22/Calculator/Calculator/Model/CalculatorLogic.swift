//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by Kurtis Hoang on 4/26/21.
//

import Foundation

struct CalculatorLogic {
    
    private var number: Double?
    
    private var intermediateCalculation: (n1: Double, calcMethod:  String)?
    
    mutating func setNumber(_ number: Double) {
        self.number = number
    }
    
    func getNumber() -> Double {
        return number!
    }
    
    mutating func calculate(method: String) -> Double? {
        if let num = number {
            
            switch method {
            case "+/-":
                return num * -1
            case "AC":
                return 0
            case "%":
                return num / 100
            case "=":
                return performTwoNumberCalculation(n2: num)
            default:
                intermediateCalculation = (n1: num, calcMethod: method)
            }
        }
        
        return nil
    }
    
    func performTwoNumberCalculation(n2: Double) -> Double?
    {
        if let n1 = intermediateCalculation?.n1, let operation = intermediateCalculation?.calcMethod {
            
            switch operation {
            case "+":
                return n1 + n2
            case "-":
                return n1 - n2
            case "÷":
                return n1 / n2
            case "×":
                return n1 * n2
            default:
                fatalError("Operation passed does not match any of the cases")
            }
        }
        
        return nil
    }
}
