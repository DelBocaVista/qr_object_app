//
//  ItemManager.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-13.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import Foundation
import ARKit
import UIKit

class ARItemsModel {
    
    private var arItems: ARItems
    private var previewImages: [String : UIImage] = [:]
    
    init() {
        self.arItems = ARItems()
    }
    
    func getARItemsData () -> ARItems {
        return self.arItems
    }
    
    func updateARItemsData (arItems: ARItems) {
        self.arItems = arItems
    }
    
    func getARItemBy(name: String) -> ARItemElement? {
        
        for arItem in arItems {
            if arItem.name == name {
                return arItem
            }
        }
        return nil
    }
    
    func getARItemBy(imageName: String) -> ARItemElement? {
        
        for arItem in arItems {
            if arItem.img == imageName {
                return arItem
            }
        }
        return nil
    }
    
    func populatePreviewImages() {
        /*guard let supportedImages = ARReferenceImage.referenceImages(inGroupNamed: "SupportedImages", bundle: nil)
            else {
                fatalError("Missing expected asset catalog resources.")
        }
        
        for image in supportedImages {
            previewImages[image.name!] =
        }
        
        guard let supportedObjects = ARReferenceObject.referenceObjects(inGroupNamed: "SupportedObjects", bundle: nil)
            else {
                fatalError("Missing expected asset catalog resources.")
        }
        
        for object in supportedObjects {
            previewImages[object.name ?? <#default value#>] = object.preview
        }*/
        
    }
}
