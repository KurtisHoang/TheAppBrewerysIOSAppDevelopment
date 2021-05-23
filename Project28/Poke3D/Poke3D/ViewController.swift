//
//  ViewController.swift
//  Poke3D
//
//  Created by Kurtis Hoang on 5/6/21.
//

import UIKit
import SceneKit
import ARKit

//quick note: can convert to a .scn by clicking file in art.scnassets folder then click the editor tab and convert to .scn

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true //apply default lighting
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration() //searching for specific image we provided
        
        //if detecting planes and images
        //let configuration = ARWorldTrackingConfiguration()
        
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: .main) //get group of image to track
        {
            
            //if detecting planes and images
            //configuration.detectionImages = imageToTrack//if detecting planes and images
            
            configuration.trackingImages = imagesToTrack //set the tracking Images
            
            configuration.maximumNumberOfTrackedImages = imagesToTrack.count //# of images to track from imagesToTrack
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    //Triggered when pokemon card images are detected since our configuration is tracking imagesToTrack
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height) //set plane to imageAnchor width and height
            plane.firstMaterial?.diffuse.contents = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7) //plane is transparent, without this it would be completely green covering the card
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
            //add 10 grass randomly on card
            var i = 0
            while i < 10 {
                if let grassScene = SCNScene(named: "art.scnassets/grass.scn") {
                    if let grassNode = grassScene.rootNode.childNodes.first {
                        grassNode.eulerAngles.x = .pi/2
                        grassNode.position = SCNVector3(
                            grassNode.position.x+Float.random(in: -0.026..<0.026),
                            grassNode.position.y+Float.random(in: -0.036..<0.036),
                            grassNode.position.z+0.001
                        )
                        planeNode.addChildNode(grassNode)
                    }
                }
                i+=1
            }
            
            if let pokeScene = SCNScene(named: "art.scnassets/\(imageAnchor.referenceImage.name!).scn") { //get pokemon by imageName and find the correct pokemonName.scn
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    pokeNode.eulerAngles.x = .pi/2 //rotate pokemon on x axis

                    planeNode.addChildNode(pokeNode)
                }
            }
        }
        
        return node
    }
}
