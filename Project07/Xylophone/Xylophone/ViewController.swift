//
//  ViewController.swift
//  Xylophone
//
//  Created by Kurtis Hoang on 4/1/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        guard sender.currentTitle != nil else {return} //check if button's current title is not nil
        
        sender.alpha = 0.5
        
        playSound(soundName: sender.currentTitle!)
        
        //execute code after 0.2 sec delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
    }
    
    func playSound(soundName:String) {
        //find file
        let url = Bundle.main.url(forResource: soundName, withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}

