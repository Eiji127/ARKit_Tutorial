//
//  BasicsViewController.swift
//  ARKit_Tutorial
//
//  Created by 白数叡司 on 2020/10/18.
//

import UIKit
import ARKit

class BasicsViewController: UIViewController {
    
// MARK: - Properties
    @IBOutlet weak var sceneView: ARSCNView!

// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration, options: [])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
// MARK: - Helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ship = SCNScene(named: "art.scnassets/ship.scn")!
        let shipNode = ship.rootNode.childNodes.first!
        shipNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        // カメラ座標系で30 cm前
        let infrontCamera = SCNVector3Make(0, 0, -0.3)
        
        guard let cameraNode = sceneView.pointOfView else { return }
        
        //ワールド座標系
        let pointInWorld = cameraNode.convertPosition(infrontCamera, to: nil)
        // スクリーン座標系へ
        var screenPosition = sceneView.projectPoint(pointInWorld)
        //スクリーン座標系
        guard let location: CGPoint = touches.first?.location(in: sceneView) else { return }
        screenPosition.x = Float(location.x)
        screenPosition.y = Float(location.y)
        
        // ワールド座標系
        let finalPosition = sceneView.unprojectPoint(screenPosition)
        
        shipNode.eulerAngles = cameraNode.eulerAngles
        shipNode.position = finalPosition
        sceneView.scene.rootNode.addChildNode(shipNode)
    }
    

}

// MARK: - ARSCNViewDelegate
extension BasicsViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("DEBUG: anchor added..")
        
        if anchor is ARPlaneAnchor {
            print("DEBUG: this is ARPlaneAnchor..")
        }
    }

}
