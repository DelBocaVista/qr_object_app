//
//  ARItems.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-25.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import Foundation

typealias ARItems = [ARItemElement]

struct ARItemElement: Codable {
    let id, name: String
    let url: String
    let img, width, height, description: String
    let active: JSONNull?
    let stampCreated: String
    let stampUpdated: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, url, img, width, height, description, active
        case stampCreated = "stamp_created"
        case stampUpdated = "stamp_updated"
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
