//
//  ViewController.swift
//  BMI-Calculator
//
//  Created by Kurtis Hoang on 4/2/21.
//

import UIKit

class CalculateViewController: UIViewController {

    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    var calculatorBrain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        heightSlider.value = heightSlider.maximumValue/2
        weightSlider.value = weightSlider.maximumValue/2
    }

    @IBAction func heightSliderChanged(_ sender: UISlider) {
        let sliderHeight = sender.value
        height.text = String(format: "%.2f", sliderHeight) + "m"
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        let sliderWeight = sender.value
        weight.text = String(Int(sliderWeight)) + "Kg"
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let weight = weightSlider.value
        let height = heightSlider.value
        
        calculatorBrain.calculateBMI(height, weight)
        
        self.performSegue(withIdentifier: "goToResults", sender: self)
        
        /*
        //when programming UI without storyboard
         //SecondViewController program UI
        let secondVC = SecondViewController() //
        secondVC.bmiValue = String(format: "%.1f", bmi)
        self.present(secondVC, animated: true, completion: nil)
         */
    }
    
    //prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToResults"
        {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.bmiValue = calculatorBrain.getBMI()
            destinationVC.bmiAdvice = calculatorBrain.getAdvice()
            destinationVC.bmiColor = calculatorBrain.getColor()
        }
    }
}

