//
//  ViewController.swift
//  ArkitDemo
//
//  Created by Abhishek Kumar on 06/08/20.
//  Copyright © 2020 Abhishek. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        let sphere = SCNSphere(radius: 0.1)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/sun.jpg")
//        sphere.materials = [material]
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0, y: 0.1, z: -1.0)
//        node.geometry = sphere
        
        
//         Set the scene to the view
//        sceneView.scene.rootNode.addChildNode(node)
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchlocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchlocation, types: .existingPlaneUsingExtent)
            if let hitResult = results.first {
            let diceScence = SCNScene(named: "art.scnassets/diceCollada.scn")!
                if let diceNode = diceScence.rootNode.childNode(withName: "Dice", recursively: true) {
                    diceNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                                   hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                                                   hitResult.worldTransform.columns.3.z)
                    sceneView.scene.rootNode.addChildNode(diceNode)
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            print(planeAnchor, "plane detected")
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }
}
