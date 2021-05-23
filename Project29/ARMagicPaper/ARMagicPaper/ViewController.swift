//
//  ViewController.swift
//  ARMagicPaper
//
//  Created by Kurtis Hoang on 5/7/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var nodeAdded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "NewspaperImages", bundle: .main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
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
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            //creating the video
            let videoNode = SKVideoNode(fileNamed: "harryPotter.mp4") //set videoNode via video
            videoNode.play() //play video
            videoNode.name = "video node"
        
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720)) //720p video
            videoScene.name = "video scene"
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            videoNode.yScale = -1
            videoScene.addChild(videoNode)
            print("from nodeFor, \(videoScene)")
            
            nodeAdded = true
            
            //create plane onto node
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = videoScene //display videoScene
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
        }
        
        return node
    }
    
    //
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if node.isHidden {
            if nodeAdded {
                if let videoScene = node.childNodes.first?.geometry?.firstMaterial?.diffuse.contents as? SKScene {
                    if let videoNode = videoScene.childNode(withName: "video node") as? SKVideoNode {
                        videoNode.pause()
                        print("from didUpdate&isHidden, \(videoScene)")
                    }
                }
                nodeAdded = false
            }
        }
        else {
            if !nodeAdded {
                if let videoScene = node.childNodes.first?.geometry?.firstMaterial?.diffuse.contents as? SKScene {
                    if let videoNode = videoScene.childNode(withName: "video node") as? SKVideoNode {
                        videoNode.play()
                    }
                    print(videoScene)
                }
                
                nodeAdded = true
            }
        }
    }
}
