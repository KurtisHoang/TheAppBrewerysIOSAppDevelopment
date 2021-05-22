//
//  ViewController.swift
//  Tipper
//
//  Created by Kurtis Hoang on 4/3/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var splitStepper: UIStepper!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    
    var tipCalculator = TipCalculator()
    
    var tip: Float = 0.10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        splitLabel.text = "\(Int(splitStepper.value))"
    }
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        var currentButton = sender.currentTitle!
        currentButton = String(currentButton.dropLast())
        tip = Float(currentButton)! / 100
        
        if(currentButton == "0")
        {
            zeroPctButton.isSelected = true
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = false
        }
        else if (currentButton == "10")
        {
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = true
            twentyPctButton.isSelected = false
        }
        else {
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = true
        }
        
        if (Float(billTextField.text!) != nil)
        {
            billTextField.endEditing(true)
        }
    }
    
    @IBAction func splitChanged(_ sender: UIStepper) {
        let split = sender.value
        
        splitLabel.text = "\(Int(split))"
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        let userBill = Float(billTextField.text ?? "0.0")
        let split = Int(splitLabel.text ?? "0")
        
        if(zeroPctButton.isSelected == true)
        {
            tipCalculator.calculateBill(userBill!, tip , split!)
        }
        else if (tenPctButton.isSelected == true)
        {
            tipCalculator.calculateBill(userBill!, tip, split!)
        }
        else {
            tipCalculator.calculateBill(userBill!, tip, split!)
        }
        
        self.performSegue(withIdentifier: "goToTip", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTip" {
            let destination = segue.destination as! TipResultViewController
            destination.calculatedBill = tipCalculator.getCalculatedBill()
            destination.split = tipCalculator.getSplit()
            destination.tip = tipCalculator.getTip()
            
        }
    }
}

