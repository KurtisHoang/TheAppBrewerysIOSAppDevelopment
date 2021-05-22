//
//  ViewController.swift
//  Calculator
//
//  Created by Kurtis Hoang on 4/26/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    private var isFinishedTypingNumber: Bool = true
    
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {fatalError("Cannot convert displayLabel text to double")}
            return number
        }
        set { //calls whenever displayValue =
            
            //check if int
            let isInt = floor(newValue) == newValue
            if isInt {
                displayLabel.text = String(Int(newValue))
            } else {
                displayLabel.text = String(newValue)
            }
        }
    }
    
    private var calculator = CalculatorLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //when a non-number button is pressed
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        isFinishedTypingNumber = true
        
        calculator.setNumber(displayValue) //CalculatorLogic setNumber
        
        if let calcMethod = sender.currentTitle { //get operator from button currentTitle
            
            if let result = calculator.calculate(method: calcMethod) {
                displayValue = result //get result from CalculatorLogic
            }
            
        }
    }
    
    //when a number button is pressed
    @IBAction func numButtonPressed(_ sender: UIButton) {
        if let number = sender.currentTitle {
            if isFinishedTypingNumber {
                displayLabel.text = number
                isFinishedTypingNumber = false
            } else {
                if number == "." //if . is pressed
                {
                    //check if int
                    let isInt = floor(displayValue) == displayValue
                   
                    if !isInt {
                        print("h")
                        return //stop if not an int
                    }
                }
                
                displayLabel.text?.append(number)
            }
        }
    }
}

