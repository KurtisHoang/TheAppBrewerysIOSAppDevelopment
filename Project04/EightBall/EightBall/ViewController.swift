//
//  ViewController.swift
//  EightBall
//
//  Created by Kurtis Hoang on 3/31/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var eightBallImageView: UIImageView!
    @IBOutlet weak var askButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        askButtonOutlet.layer.cornerRadius = 15.0
    }

    @IBAction func askButtonPressed(_ sender: UIButton) {
        
        eightBallImageView.image = UIImage(named: "ball\(Int.random(in: 1..<6))")
    }
    
    //triggers when motion ends
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake //if motion was a shake motion
        {
            eightBallImageView.image = UIImage(named: "ball\(Int.random(in: 1..<6))")
        }
    }
    
}

