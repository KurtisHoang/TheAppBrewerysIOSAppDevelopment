//
//  ViewController.swift
//  ThunderChat
//
//  Created by Kurtis Hoang on 4/6/21.
//

import UIKit
//import CLTypingLabel

class WelcomeViewController: UIViewController {

    //@IBOutlet weak var titleLabel: CLTypingLabel! //imported CLTypingLabel pod
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //typing animation
        titleLabel.text = ""
        var charIndex = 0.0
        for letter in K.appName {
            //option 1
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (Timer) in
                self.titleLabel.text?.append(letter)
            }

            //option 2
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 * charIndex)
//            {
//                self.titleLabel.text?.append(letter)
//            }

            charIndex += 1
        }
        
        //IF USING POD CLTypingLabel
//        titleLabel.charInterval = 0.2 //change typing interval
//        titleLabel.text = "⚡️ThunderChat"
    }
    
    //when view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true //hide nav bar
    }
    
    //when view disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false //unhide nav bar
    }
}

