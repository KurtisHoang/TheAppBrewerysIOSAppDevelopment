//
//  ViewController.swift
//  ARRuler
//
//  Created by Kurtis Hoang on 5/5/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var lineNode = SCNNode()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        //debug options
        //showFeaturePoints will display yellow dots on the screen to determine the background
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //when user touch the screen
    //mutlitouch need to enabled via sceneView.isMultipleTouchEnabled = true
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) { //get first touch location
            if let raycastQuery = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any) {
                let hitTestResults = sceneView.session.raycast(raycastQuery)
                if let hitTestResult = hitTestResults.first {
                    addDot(at: hitTestResult)
                }
            }
        }
    }
    
    func addDot(at result: ARRaycastResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(
            result.worldTransform.columns.3.x,
            result.worldTransform.columns.3.y,
            result.worldTransform.columns.3.z
        )
        
        dotNodes.append(dotNode)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let distance = sqrt(
            pow(end.position.x - start.position.x,2) +
            pow(end.position.y - start.position.y,2) +
            pow(end.position.z - start.position.z,2)
        )
        
        drawLine(from: start.position, to: end.position, distance: distance)
        
        updateText(text: "\(String(format: "%.3f",abs(distance)))", position: end.position)
    }
    
    func drawLine(from start: SCNVector3, to end: SCNVector3, distance: Float) {
        
        lineNode.removeFromParentNode()
        
        let line = SCNCylinder(radius: 0.005, height: CGFloat(distance))
        line.firstMaterial?.diffuse.contents = UIColor.red
        
        lineNode = SCNNode(geometry: line)
        let midPosition = SCNVector3(
            (start.x+end.x)/2,
            (start.y+end.y)/2,
            (start.z+end.z)/2
        )
        lineNode.position = midPosition
        lineNode.look(at: start, up: end, localFront: lineNode.worldUp)
        sceneView.scene.rootNode.addChildNode(lineNode)
    }
    
    func updateText(text: String, position: SCNVector3) {
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y, position.z - 0.05)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}
