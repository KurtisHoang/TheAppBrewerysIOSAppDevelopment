//
//  ResultViewController.swift
//  BMI-Calculator
//
//  Created by Kurtis Hoang on 4/2/21.
//

import UIKit

class ResultViewController: UIViewController {

    var bmiValue: String?
    var bmiAdvice: String?
    var bmiColor: UIColor?
    
    @IBOutlet weak var bmiResultLabel: UILabel!
    @IBOutlet weak var bmiAdviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bmiResultLabel.text = bmiValue
        bmiAdviceLabel.text = bmiAdvice
        view.backgroundColor = bmiColor
    }
    
    @IBAction func RecalculatePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) //go back to previous screen
    }

}
