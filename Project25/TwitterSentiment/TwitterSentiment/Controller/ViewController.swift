//
//  ViewController.swift
//  TwitterSentiment
//
//  Created by Kurtis Hoang on 5/1/21.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var apiKey: String {
        get {
            guard let plist = getPlist() else {fatalError("Could not get plist")}
            return plist.API_Key
        }
    }
    
    var apiSecret: String {
        get {
            guard let plist = getPlist() else {fatalError("Could not get plist")}
            return plist.API_Secret
        }
    }
    
    var swifter = Swifter(consumerKey: "consumerKey", consumerSecret: "consumerSecret") //default with dummy key and secret
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    var tweetCount = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //apply key and secret for twitter
        swifter = Swifter(consumerKey: apiKey, consumerSecret: apiSecret)
    }

    @IBAction func predictButtonPressed(_ sender: UIButton) {
        fetchTweet()
    }
    
    func fetchTweet() {
        if let searchText = textField.text {
            //search for tweets that has @Apple, in English, get the first # of tweets, and extend the tweet for full text than truncated
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount {
                    //get every tweet's full_text
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet) //convert to TweetSentimentClassifierInput
                        tweets.append(tweetForClassification) //add to array
                    }
                }
                self.makePrediction(tweets: tweets) //call makePrediction
            } failure: { (error) in
                print("There was an error with the Twitter API Request, \(error)")
            }
        }
    }
    
    func makePrediction(tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            for prediction in predictions {
                let sentiment = prediction.label
                //increment or decrement based on Pos or Neg
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            updateUI(sentimentScore: sentimentScore) //call updateUI
        } catch {
            print("There was an error, \(error)")
        }
    }
    
    func updateUI(sentimentScore: Int) {
        //update sentimentLabel based on score
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "🙁"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
    
    func getPlist() -> Settings? {
        //find Secrets.plist
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist")
        {
            do {
                //get data and decode it using the data model, Settings.swift
                let data = try Data(contentsOf:url)
                let settings = try PropertyListDecoder().decode(Settings.self, from: data)
                return settings
                
            } catch {
                print(error)
                
            }
        }
        return nil
    }
    
}

