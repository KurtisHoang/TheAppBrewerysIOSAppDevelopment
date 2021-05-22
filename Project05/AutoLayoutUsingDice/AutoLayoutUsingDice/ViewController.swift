//
//  ViewController.swift
//  AutoLayoutUsingDice
//
//  Created by Kurtis Hoang on 3/31/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    @IBOutlet weak var rollButtonOutlet: UIButton!
    let diceArray = [#imageLiteral(resourceName: "Dice1"),#imageLiteral(resourceName: "Dice2"),#imageLiteral(resourceName: "Dice3"),#imageLiteral(resourceName: "Dice4"),#imageLiteral(resourceName: "Dice5"),#imageLiteral(resourceName: "Dice6")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rollButtonOutlet.layer.cornerRadius = 15.0
    }

    @IBAction func rollButtonPressed(_ sender: UIButton) {
        diceImageView1.image = diceArray[Int.random(in: 0..<6)]
        diceImageView2.image = diceArray[Int.random(in: 0..<6)]
    }
    
}

