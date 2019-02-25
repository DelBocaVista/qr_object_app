//
//  ItemManager.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-13.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import Foundation

class ARItemsModel {
    
    private var arItems: ARItems
    
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
}
