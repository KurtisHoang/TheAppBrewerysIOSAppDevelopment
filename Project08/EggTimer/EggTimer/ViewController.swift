//
//  ViewController.swift
//  EggTimer
//
//  Created by Kurtis Hoang on 4/1/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let eggTimes = ["Soft":5, "Medium":7, "Hard":12] //dictionary ["type of egg": minutes]
//    var secondsRemaining = 0
    var timer = Timer() //timer
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var player:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        progressBar.progress = 0.0
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        timer.invalidate() // stop timer
        
        let hardness = sender.currentTitle! //get button title for hardness
        
        for hard in eggTimes //hard is each element in the dictionary
        {
            if(hard.key == hardness) //check the key of element with hardness of the button
            {
//                //AngelaYu's way
//                secondsRemaining = hard.value * 60
//                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                titleLabel.text = "Cooking \(hard.key) eggs!"
                var seconds = 0
                let maxSeconds = hard.value * 60 //convert to seconds
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                    if (seconds <= maxSeconds)
                    {
                        let percentage = Float(seconds)/Float(maxSeconds) //calc the percentage
                        self.progressBar.progress = percentage //change percentageBar progress
                        self.percentageLabel.text = "\(Int(percentage*100))%" //Cast to Int for whole number percentages
                        seconds += 1
                    }
                    else
                    {
                        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
                        self.player = try! AVAudioPlayer(contentsOf: url!)
                        self.player.play()
                        
                        self.titleLabel.text = "Done!"
                        Timer.invalidate() //stop timer
                    }
                })
            }
        }
    }
    
//    //AngelaYu's way
//    @objc func updateTimer()
//    {
//        print("\(secondsRemaining) seconds")
//        secondsRemaining -= 1
//    }
    
}

