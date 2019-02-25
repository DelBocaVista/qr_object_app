//
//  InfoPlane.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-13.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class ObjectInfoPlaneNode: SCNNode {
    
    var infoPlane: SCNPlane
    
    init(width: CGFloat, height: CGFloat, objectAnchor: ARObjectAnchor) {
        
        infoPlane = SCNPlane(width: width, height: height)
        infoPlane.firstMaterial?.isDoubleSided = true
        
        super.init()
        
        self.geometry = infoPlane
        
        // Alternative placing putting UIWebView at cameras x and y positions in the room
        // NB! Does not work well whith turning to the side and scanning!
        /*var translation = matrix_identity_float4x4
         translation.columns.3.z = -distance
         self.simdTransform = matrix_multiply(arFrame.camera.transform, translation)*/
        
        self.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.15, objectAnchor.referenceObject.center.z)
        
        // Rotation UIWebView to face camera (set equal rotation around y-axis as camera)
        //self.eulerAngles = SCNVector3Make(0, arFrame.camera.eulerAngles.y, 0)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func set(contents: Any) {
        self.infoPlane.firstMaterial!.diffuse.contents = contents
    }
    
    func set(name: String) {
        self.name = name
    }
}
