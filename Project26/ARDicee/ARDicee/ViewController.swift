//
//  ViewController.swift
//  ARDicee
//
//  Created by Kurtis Hoang on 5/4/21.
//

import UIKit
//import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showCameras] //show feature points
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        /* creating from scratch
        //create a cube from scratch
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        //create a sphere from scratch //replace cube with sphere
        let sphere = SCNSphere(radius: 0.2)
        
        //create material from scratch
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/New_RedBase_Color.png") //change diffuse to red color
        cube.materials = [material] //add to cube material

        //node = points in 3D space
        let node = SCNNode()
        node.position = SCNVector3(0, 0.1, -0.5) //position for cube
        node.geometry = cube //place cube at position

        sceneView.scene.rootNode.addChildNode(node) //add child node to root node of the scene
         */
        
        sceneView.autoenablesDefaultLighting = true //add light to scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        sceneView.autoenablesDefaultLighting = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - Dice Rendering Methods
    
    //when a touch has been detected
    //to recieve multiple touches, sceneView.isMultipleTouchEnable = true
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { //get first touch
            let touchLocation = touch.location(in: sceneView)
            
            if let raycastQuery = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .horizontal) {
                
                let results = sceneView.session.raycast(raycastQuery)
                
                if let hitResult = results.first {
                    addDice(atLocation: hitResult)
                }
            }
        }
    }
    
    func addDice(atLocation location: ARRaycastResult) {
        // Create a new dice scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!

        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(
                location.worldTransform.columns.3.x,
                location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                location.worldTransform.columns.3.z
            )
            
            diceArray.append(diceNode)
            
            sceneView.scene.rootNode.addChildNode(diceNode) //add dice to sceneView
            
            roll(dice: diceNode)
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    @IBAction func removeAllDice(_ sender: Any) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        //randomize a dice by it four sides * 90degrees in radians
        let randomX = Float(arc4random_uniform(4)+1)*(Float.pi/2)
        let randomZ = Float(arc4random_uniform(4)+1)*(Float.pi/2)
        
        dice.runAction(
            SCNAction.rotateBy(
                x: CGFloat(randomX * 5),
                y: 0,
                z: CGFloat(randomZ * 5),
                duration: 0.5
        ))
    }
    
    //MARK: - ARSCNViewDelegate Method
    
    //when detects a plane detection
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}

        let planeNode = createPlane(withPlaneAnchor: planeAnchor)

        node.addChildNode(planeNode)
    }
    
    //MARK: - Plane Rendering Methods
    func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)) //create a plane based on the planeAnchor
        
        //create a node where the position and rotation will be set
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        //set the material to be a grid to show
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        
        planeNode.geometry = plane
        
        return planeNode
    }
}
