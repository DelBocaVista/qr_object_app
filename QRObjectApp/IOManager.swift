//
//  IOManager.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-13.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

typealias ARItems = [ARItemElement]

struct ARItemElement: Codable {
    let id, name, color, length: String
    let width, height, description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, color, length, width, height, description
    }
}

public class IOManager: NSObject {
    
    private var fetchedItems: ARItems
    private var couldFetchData: Bool
    
    override init (){
        fetchedItems = [ARItemElement]()
        couldFetchData = false
    }
    
    public func fetchData(idURL: String) {
        
        //let baseURL = "http://kth.elack.net:8081/items/$LAT$/" <-- Version for further development?
        let baseURL = "http://kth.elack.net:8081/$URL$"
        
        let completeURL: String = replaceHolders(baseString: baseURL, idURL: idURL)
        
        guard let url = URL(string: completeURL) else {return}
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            
            let items = try? JSONDecoder().decode(ARItems.self, from: dataResponse)
            //let weather = try? JSONDecoder().decode(Weather.self, from: dataResponse)
            
            if items != nil {
                
                self.fetchedItems = items!
                self.couldFetchData = true
                
            }
            // Raise notification flag
            NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey),object: nil)
        }
        task.resume()
    }
    
    func storeData(arItems: ARItems) {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let archiveURL = documentsDirectory.appendingPathComponent("persisted_aritems").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedArray = try? propertyListEncoder.encode(arItems)
        try? encodedArray?.write(to: archiveURL, options: .noFileProtection)

    }
    
    func getStoredData() -> ARItems {
        
        var returnedItems = ARItems()
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let archiveURL = documentsDirectory.appendingPathComponent("persisted_aritems").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedItemsData = try? Data(contentsOf: archiveURL),
            let decodedItemsData = try? propertyListDecoder.decode(ARItems.self, from:
                retrievedItemsData) {
            returnedItems = decodedItemsData }
        
        return returnedItems
    }
    
    func getFetchedARItems () -> ARItems {
        return self.fetchedItems
    }
    
    func ableToFetchData() -> Bool {
        return self.couldFetchData
    }
    
    func setBoolToFetchData(value: Bool){
        self.couldFetchData = value
    }
    
    private func replaceHolders(baseString: String, idURL: String) -> String {
        let newString = baseString.replacingOccurrences(of: "$URL$", with: idURL, options: .literal, range: nil)
        return newString
    }
}
