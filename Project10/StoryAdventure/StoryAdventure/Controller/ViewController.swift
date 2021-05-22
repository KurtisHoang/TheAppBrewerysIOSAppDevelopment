//
//  ViewController.swift
//  StoryAdventure
//
//  Created by Kurtis Hoang on 4/2/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
   
    var storyController = StoryAdventure()
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateUI()
    }

    @IBAction func choicePressed(_ sender: UIButton) {
        let userChoice = sender.currentTitle!
        
        storyController.proceedStory(userChoice)
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateUI()
    {
        storyLabel.text = storyController.getStoryTitle()
        let choices = storyController.getChoices()
        choice1Button.setTitle(choices[0], for: .normal)
        choice2Button.setTitle(choices[1], for: .normal)
    }

}

