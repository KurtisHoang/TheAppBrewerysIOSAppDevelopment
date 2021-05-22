//
//  TipResultViewController.swift
//  Tipper
//
//  Created by Kurtis Hoang on 4/3/21.
//

import UIKit

class TipResultViewController: UIViewController {

    @IBOutlet weak var calculatedBillLabel: UILabel!
    @IBOutlet weak var billDescriptionLabel: UILabel!
    
    var calculatedBill: Float?
    var tip: Float?
    var split: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calculatedBillLabel.text = String(format: "%.2f", calculatedBill!)
        billDescriptionLabel.text = "Split between \(split!) people, with \(Int(tip!*100))% tip."
    }

    @IBAction func RecalculateButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
