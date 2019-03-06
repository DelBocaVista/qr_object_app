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
    
    init(width: CGFloat, height: CGFloat, imageAnchor: ARImageAnchor, direction: String) {
        
        infoPlane = SCNPlane(width: width, height: height)
        infoPlane.firstMaterial?.isDoubleSided = true
        
        infoPlaneNode = SCNNode()
        
        super.init()
        
        infoPlaneNode.geometry = infoPlane
        infoPlaneNode.eulerAngles.x = -.pi / 2
        
        let referenceImage = imageAnchor.referenceImage
        
        self.simdTransform = imageAnchor.transform//.simdWorldOrientation = imageAnchor.transform
        //self.worldPosition.x -= Float((referenceImage.physicalSize.width - infoPlane.width) / 2)
        //self.worldPosition.y += Float((referenceImage.physicalSize.height - infoPlane.height) / 2)
        let (xDiff, yDiff) = calculatePlanePositionDifference(direction: direction, planeWidth: infoPlane.width, refImageWidth: referenceImage.physicalSize.width, planeHeight: infoPlane.height, refImageHeight: referenceImage.physicalSize.height)
        //print("xDiff: " + xDiff.description + ", yDiff: " + yDiff.description)
        self.worldPosition.x += xDiff
        self.worldPosition.y += yDiff
        
        self.addChildNode(infoPlaneNode)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func set(contents: Any) {
        self.infoPlane.firstMaterial!.diffuse.contents = contents
    }
    
    func set(name: String) {
        self.name = name
    }
    
    func calculatePlanePositionDifference(direction: String, planeWidth: CGFloat, refImageWidth: CGFloat, planeHeight: CGFloat, refImageHeight: CGFloat) -> (Float, Float) {
        
        var xDiff: Float
        var yDiff: Float
        
        switch direction {
        case "N":
            xDiff = 0
            yDiff = Float((-refImageHeight + planeHeight) / 2)
        case "N-E":
            xDiff = Float((-refImageWidth + planeWidth) / 2)
            yDiff = Float((-refImageHeight + planeHeight) / 2)
        case "E":
            xDiff = Float((-refImageWidth + planeWidth) / 2)
            yDiff = 0
        case "S-E":
            xDiff = Float((-refImageWidth + planeWidth) / 2)
            yDiff = Float((refImageHeight - planeHeight) / 2)
        case "S":
            xDiff = 0
            yDiff = Float((refImageHeight - planeHeight) / 2)
        case "S-W":
            xDiff = Float((refImageWidth - planeWidth) / 2)
            yDiff = Float((refImageHeight - planeHeight) / 2)
        case "W":
            xDiff = Float((refImageWidth - planeWidth) / 2)
            yDiff = 0
        case "N-W":
            xDiff = Float((refImageWidth - planeWidth) / 2)
            yDiff = Float((-refImageHeight + planeHeight) / 2)
        default:
            // Assume is no preference e.g. "C"
            xDiff = 0
            yDiff = 0
        }
        return (xDiff, yDiff)
    }
}
