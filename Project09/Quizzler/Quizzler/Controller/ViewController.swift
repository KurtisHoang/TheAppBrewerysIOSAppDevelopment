//
//  ViewController.swift
//  Quizzler
//
//  Created by Kurtis Hoang on 4/2/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var choiceOneButton: UIButton!
    @IBOutlet weak var choiceTwoButton: UIButton!
    @IBOutlet weak var choiceThreeButton: UIButton!
    
    var timer = Timer()
    
    var quizBrain = QuizBrain() //get model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        choiceOneButton.layer.cornerRadius = 15.0
        choiceTwoButton.layer.cornerRadius = 15.0
        choiceThreeButton.layer.cornerRadius = 15.0
        
        updateUI() //inital update the UI
        
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        let userAnswer = sender.currentTitle!
        
        let userGotItRight = quizBrain.checkAnswer(userAnswer)
        
        if(userGotItRight)
        {
            sender.backgroundColor = UIColor.green
        }
        else
        {
            sender.backgroundColor = UIColor.red
        }
        
        quizBrain.nextQuestion()
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateUI()
    {
        
        choiceOneButton.backgroundColor = UIColor.clear
        choiceTwoButton.backgroundColor = UIColor.clear
        choiceThreeButton.backgroundColor = UIColor.clear
        
        let answers = quizBrain.getQuestionAnswers()
        choiceOneButton.setTitle(answers[0], for: .normal)
        choiceTwoButton.setTitle(answers[1], for: .normal)
        choiceThreeButton.setTitle(answers[2], for: .normal)
        
        scoreLabel.text = "Score: \(quizBrain.getScore())"
        progressBar.progress = quizBrain.getProgress()
        questionLabel.text = quizBrain.getQuestionText()
    }
    
}

