//
//  ImageInfoPlaneNode.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-25.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class ImageInfoPlaneNode: SCNNode {
    
    var infoPlane: SCNPlane
    var infoPlaneNode: SCNNode
    
    init(width: CGFloat, height: CGFloat, imageAnchor: ARImageAnchor) {
        
        infoPlane = SCNPlane(width: width, height: height)
        infoPlane.firstMaterial?.isDoubleSided = true
        
        infoPlaneNode = SCNNode()
        
        super.init()
        
        infoPlaneNode.geometry = infoPlane
        infoPlaneNode.eulerAngles.x = -.pi / 2
        
        let referenceImage = imageAnchor.referenceImage
        
        self.simdTransform = imageAnchor.transform//.simdWorldOrientation = imageAnchor.transform
        self.worldPosition.x -= Float((referenceImage.physicalSize.width - infoPlane.width) / 2)
        self.worldPosition.y += Float((referenceImage.physicalSize.height - infoPlane.height) / 2)
        
        self.addChildNode(infoPlaneNode)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func set(contents: Any) {
        self.infoPlane.firstMaterial!.diffuse.contents = contents
    }
    
    func set(name: String) {
        self.name = name
    }
}
