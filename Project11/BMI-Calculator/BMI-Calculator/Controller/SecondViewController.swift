//
//  ResultViewController.swift
//  BMI-Calculator
//
//  Created by Kurtis Hoang on 4/2/21.
//

import UIKit

//programming UI without storyboard
class SecondViewController: UIViewController {
    
    var bmiValue = "0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red //UIColor.red
        
        let label = UILabel()
        label.text = bmiValue
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        //view is the initial view
        view.addSubview(label) //add to view
    }
}
