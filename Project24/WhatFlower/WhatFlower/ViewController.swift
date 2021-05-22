//
//  ViewController.swift
//  WhatFlower
//
//  Created by Kurtis Hoang on 4/28/21.
//

import UIKit
import CoreML //Machine Learning
import Vision //process image more easily and work with CoreML
import Alamofire
import SwiftyJSON //allows to use JSON(response)
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var wikipediaText: UILabel!
    
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imagePicker setup
        imagePicker.delegate = self //allows for func using UIImagePickerController
        imagePicker.allowsEditing = true //can edit image if true use editedImage, if false use originalImage
        imagePicker.sourceType = .camera //use camera
    }

    @IBAction func CameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            //displayImageView.image = userPickedImage //display userPickedImage
            
            guard let convertedCIImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: convertedCIImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        //create model via FlowerClassificatier
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        //get request form model
        let request = VNCoreMLRequest(model: model) { (request, error) in
            //get results
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Model failed to process image.")
            }
            
            self.navigationItem.title = classification.identifier.capitalized //capitalized first letter
            
            self.requestInfo(flowerName: classification.identifier)
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func requestInfo(flowerName: String) {
        
        let parameters: [String:String] = [
            "format":"json",
            "action":"query",
            "prop":"extracts|pageimages",
            "exintro":"",
            "explaintext":"",
            "titles":flowerName,
            "indexpageids":"",
            "redirects":"1",
            "pithumbsize":"500",
        ]
    
        //alamofire way
        Alamofire.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Got the wikipedia info")
                print(response)
                
                let flowerJSON: JSON = JSON(response.result.value)
                
                let pageID = flowerJSON["query"]["pageids"][0].stringValue
                
                let flowerDescription = flowerJSON["query"]["pages"][pageID]["extract"].stringValue
                
                let flowerImageURL = flowerJSON["query"]["pages"][pageID]["thumbnail"]["source"].stringValue
                
                self.displayImageView.sd_setImage(with: URL(string: flowerImageURL))
                self.wikipediaText.text = flowerDescription
            }
        }
    }
}

