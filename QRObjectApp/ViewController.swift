//
//  ViewController.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-11.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UIWebViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var webView = UIWebView()
    
    var webViews = [String : UIWebView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene() //(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        webView.delegate = self
        let defaultRequest = URLRequest(url: URL(string: "https://www.google.se")!)
        webView.loadRequest(defaultRequest)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("WebView finished loading!")
        
        var viewName = ""
        for (text, view) in webViews  {
            if (view == webView) {
                print("Found match: " + text.description)
                viewName = text
            }
        }
        
        if case let node as InfoPlaneNode = sceneView.scene.rootNode.childNode(withName: viewName, recursively: true) {
            print("Found node")
            node.set(contents: webView)
        } else {
            print("Did not find node :(")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "SupportedObjects", bundle: Bundle.main)!
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        /*
         let newWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
         newWebView.delegate = self
         if text.validateUrl() {
         let request = URLRequest(url: URL(string: text)!)
         newWebView.loadRequest(request)
         } else {
         let defaultRequest = URLRequest(url: URL(string: "https://www.google.se")!)
         newWebView.loadRequest(defaultRequest)
         }
         webViews[text] = newWebView
         
         let tvPlaneNode = InfoPlaneNode(width: 0.20, height: 0.15, arFrame: currentFrame, hitTest: hitTestResult, distance: distance)
         tvPlaneNode.set(name: text)
         */
        
        if let objectAnchor = anchor as? ARObjectAnchor {
            print("Found object!")
            
            let baseUrl = "http://kth.elack.net/items/"
            var arItemId = "error"
            
            if let arItem = arItemsModel.getARItemBy(name: objectAnchor.name!) {
                arItemId = arItem.id
            }
            
            let itemUrl = baseUrl + arItemId
            
            DispatchQueue.main.async {
                let newWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
                newWebView.delegate = self
                let request = URLRequest(url: URL(string: itemUrl)!)
                newWebView.loadRequest(request)
                self.webViews[arItemId] = newWebView
            }
            
            let planeNode = InfoPlaneNode(width: CGFloat(0.2), height: CGFloat(0.15), objectAnchor: objectAnchor)
            planeNode.set(name: arItemId)
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
