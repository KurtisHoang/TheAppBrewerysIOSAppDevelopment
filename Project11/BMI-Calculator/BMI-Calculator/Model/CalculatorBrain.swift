//
//  CalculatorBrain.swift
//  BMI-Calculator
//
//  Created by Kurtis Hoang on 4/2/21.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    func getBMI() -> String {
        return String(format: "%.1f", bmi?.value ?? 0.0) //optional if bmi exist show value else display 0.0
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? "No Advice"
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? .white
    }
    
    mutating func calculateBMI(_ height: Float, _ weight: Float)
    {
        let bmiValue = weight / pow(height,2)
        
        if bmiValue < 18.5
        {
            bmi = BMI(value: bmiValue, advice: "Eat more Pies", color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        }
        else if bmiValue < 24.9
        {
            bmi = BMI(value: bmiValue, advice: "Fit as a Fiddle", color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        }
        else{
            bmi = BMI(value: bmiValue, advice: "Eat fewer Pies", color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        }
    }
}
