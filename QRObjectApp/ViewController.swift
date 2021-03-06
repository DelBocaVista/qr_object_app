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

class ViewController: UIViewController, ARSCNViewDelegate, UIWebViewDelegate, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    //var webView = UIWebView()
    
    var renderedNodes = [String : SCNNode]()
    var webViews = [String : UIWebView]()
    var configuration: ARWorldTrackingConfiguration? //()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene() //(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    
        // Remove?
        let dictionary: [String : Any] = ["UserAgent" : "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0"]
        UserDefaults.standard.register(defaults: dictionary)
        
        /*webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        webView.delegate = self
        let defaultRequest = URLRequest(url: URL(string: "https://www.google.se")!)
        webView.loadRequest(defaultRequest)*/
        addPinchGesturesToSceneView()
    }
    
     func webViewDidFinishLoad(_ webView: UIWebView) {
        //print("WebView finished loading!")
        
        var viewName = ""
        for (text, view) in webViews  {
            if (view == webView) {
                //print("Found match: " + text.description)
                viewName = text
            }
        }
        
        if case let node as ObjectInfoPlaneNode = sceneView.scene.rootNode.childNode(withName: viewName, recursively: true) {
            //print("Found node")
            node.set(contents: webView)
        } else if case let node as ImageInfoPlaneNode = sceneView.scene.rootNode.childNode(withName: viewName, recursively: true) {
            //print("Found node")
            node.set(contents: webView)
        } else {
            print("Did not find node :(")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configuration = ARWorldTrackingConfiguration()
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        configuration!.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "SupportedObjects", bundle: Bundle.main)!
        configuration!.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "SupportedImages", bundle: Bundle.main)!
        // Run the view's session
        sceneView.session.run(configuration!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        renderedNodes.removeAll()
        webViews.removeAll()
        configuration = nil
        print("Removed node + webviews..")
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                if self.renderedNodes.keys.contains(imageAnchor.referenceImage.name!) {
                    let correspondingNode = self.renderedNodes[imageAnchor.referenceImage.name!]
                    
                    var planeWidth: CGFloat = 0.8
                    var planeHeight: CGFloat = 0.6
                    
                    if let arItem = arItemsModel.getARItemBy(imageName: imageAnchor.name!) {
                        planeWidth = CGFloat(Double(arItem.width)! / 1000)
                        planeHeight = CGFloat(Double(arItem.height)! / 1000)
                    }
                    
                    //correspondingNode!.simdTransform = imageAnchor.transform//.simdWorldOrientation = imageAnchor.transform
                    /*correspondingNode!.worldPosition.x = imageAnchor.transform.columns.3.x - Float((imageAnchor.referenceImage.physicalSize.width - CGFloat(0.8)) / 2)
                    correspondingNode!.worldPosition.y = imageAnchor.transform.columns.3.y + Float((imageAnchor.referenceImage.physicalSize.height - CGFloat(0.6)) / 2)*/
                    correspondingNode!.worldPosition.x = imageAnchor.transform.columns.3.x - Float((imageAnchor.referenceImage.physicalSize.width - planeWidth) / 2)
                    correspondingNode!.worldPosition.y = imageAnchor.transform.columns.3.y + Float((imageAnchor.referenceImage.physicalSize.height - planeHeight) / 2)
                }
            }
        }
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
            
            //let baseUrl = "http://kth.elack.net/items/"
            var arItemId = "error"
            var itemUrl = "http://kth.elack.net/items/"//baseUrl + arItemId
            var planeWidth: CGFloat = 0.8
            var planeHeight: CGFloat = 0.6
            
            if let arItem = arItemsModel.getARItemBy(name: objectAnchor.name!) {
                arItemId = arItem.id
                itemUrl = arItem.url
                planeWidth = CGFloat(Double(arItem.width)! / 1000)
                planeHeight = CGFloat(Double(arItem.height)! / 1000)
            }
            
            DispatchQueue.main.async {
                let newWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
                newWebView.delegate = self
                
                //let request = URLRequest(url: URL(string: itemUrl)!)
                let request = URLRequest(url: URL(string: itemUrl)!,
                           cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                           timeoutInterval: 10.0)
                newWebView.loadRequest(request)
                self.webViews[arItemId] = newWebView
            }
            
            let planeNode = ObjectInfoPlaneNode(width: planeWidth, height: planeHeight, objectAnchor: objectAnchor)
            planeNode.set(name: arItemId)
            
            DispatchQueue.main.async {
                //let image = UIImage(named: "spinner-of-dots")
                //let image = UIImage(named: "load_spinner")
                let image = UIImage(named: "logo")
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
                let myView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
                myView.addSubview(imageView)
                myView.rotate360Degrees()
                planeNode.set(contents: myView)
                //self.sceneView.scene.rootNode.addChildNode(imageInfoNode)
                node.addChildNode(planeNode)
            }
            
            //node.addChildNode(planeNode)
            
        } else if let imageAnchor = anchor as? ARImageAnchor {
            
            //let baseUrl = "http://kth.elack.net/items/"
            var arItemId = "error"
            var itemUrl = "http://kth.elack.net/items/"
            var planeWidth: CGFloat = 0.8
            var planeHeight: CGFloat = 0.6
            var direction = "C" // Assume center
            
            if let arItem = arItemsModel.getARItemBy(imageName: imageAnchor.name!) {
                arItemId = arItem.id
                print("arItem.url:" + arItem.url)
                itemUrl = arItem.url
                planeWidth = CGFloat(Double(arItem.width)! / 1000)
                planeHeight = CGFloat(Double(arItem.height)! / 1000)
                direction = arItem.direction
                print("name: " + arItem.name + ", direction: " + direction)
            }
            
            //let itemUrl = baseUrl + arItemId
            
            DispatchQueue.main.async {
                let newWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
                newWebView.delegate = self
                //let request = URLRequest(url: URL(string: itemUrl)!)
                let request = URLRequest(url: URL(string: itemUrl)!, cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,timeoutInterval: 10.0)
                //print(request.debugDescription)
                newWebView.loadRequest(request)
                self.webViews[arItemId] = newWebView
            }
            //let imageInfoNode = ImageInfoPlaneNode(width: 0.8, height: 0.6, imageAnchor: imageAnchor)
            let imageInfoNode = ImageInfoPlaneNode(width: planeWidth, height: planeHeight, imageAnchor: imageAnchor, direction: direction)
            imageInfoNode.set(name: arItemId)
            self.renderedNodes[imageAnchor.referenceImage.name!] = imageInfoNode
            
            // Maybe remove later
            //self.sceneView.scene.rootNode.addChildNode(imageInfoNode)
            // Test
            DispatchQueue.main.async {
                //let image = UIImage(named: "spinner-of-dots")
                //let image = UIImage(named: "load_spinner")
                let image = UIImage(named: "logo")
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
                let myView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
                myView.addSubview(imageView)
                myView.rotate360Degrees()
                imageInfoNode.set(contents: myView)
                self.sceneView.scene.rootNode.addChildNode(imageInfoNode)
            }
        }
        
        return node
    }
    
    var rotateSprite: SKAction {
        return .sequence([
            SKAction.rotate(byAngle: 360, duration: 2),
            SKAction.rotate(byAngle: 360, duration: 2),
            SKAction.rotate(byAngle: 360, duration: 2),
            SKAction.rotate(byAngle: 360, duration: 2),
            SKAction.rotate(byAngle: 360, duration: 2)
            ])
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
    
    func addPinchGesturesToSceneView() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.scaleObject(gesture:)))
        self.view?.addGestureRecognizer(pinchGesture)
    }
    
    /// Scales An SCNNode
    ///
    /// - Parameter gesture: UIPinchGestureRecognizer
    @objc func scaleObject(gesture: UIPinchGestureRecognizer) {
        
        let pinchLocation = gesture.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(pinchLocation)
        
        if let nodeToScale = hitTestResults.first?.node {
            if gesture.state == .changed {
                
                let pinchScaleX: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.x))
                let pinchScaleY: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.y))
                let pinchScaleZ: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.z))
                nodeToScale.scale = SCNVector3Make(Float(pinchScaleX), Float(pinchScaleY), Float(pinchScaleZ))
                gesture.scale = 1
                
            }
            if gesture.state == .ended { }
        } else {
            return
        }
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
