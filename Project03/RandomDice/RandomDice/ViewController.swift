//
//  ViewController.swift
//  RandomDice
//
//  Created by Kurtis Hoang on 3/31/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    @IBOutlet weak var rollButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //diceImageView1.image = #imageLiteral(resourceName: "Dice1")
        //diceImageView1.alpha = 0.5 //change transparency of dice1
        //diceImageView2.image = #imageLiteral(resourceName: "Dice2")
        rollButton.layer.cornerRadius = 15.0 //smooth the corners of button
    }

    @IBAction func rollButtonPressed(_ sender: UIButton) {
        
        //Angela version (static array)
        let diceArray = [#imageLiteral(resourceName: "Dice1"), #imageLiteral(resourceName: "Dice2"), #imageLiteral(resourceName: "Dice3"), #imageLiteral(resourceName: "Dice4"), #imageLiteral(resourceName: "Dice5"), #imageLiteral(resourceName: "Dice6")]
        diceImageView1.image = diceArray.randomElement() //automatically choose a random element from diceArrays
        diceImageView2.image = diceArray.randomElement()
        
        //my version, UIImage have to be named perfectly, ex: Dice1
//        diceImageView1.image = UIImage(named: "Dice\(Int.random(in: 0..<6))")
//        diceImageView2.image = UIImage(named: "Dice\(Int.random(in: 0..<6))")
    }
}


