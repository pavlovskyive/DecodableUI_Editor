//
//  JSONValue+Hashable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONValue: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(objectValues)
        hasher.combine(arrayValues)
        hasher.combine(stringValue)
        hasher.combine(numberValue)
        hasher.combine(boolValue)
    }
    
    static func ==(lhs: JSONValue, rhs: JSONValue) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
}
