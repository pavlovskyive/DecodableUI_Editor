//
//  JSONValue.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation
import OrderedCollections

enum JSONValue: Identifiable, Hashable {
    
    var id: Int {
        hashValue
    }
    
    var hashValue: Int {
        let innerHash: Int?
        switch self {
        case .object(let rows):
            innerHash = rows.hashValue
        case .array(let array):
            innerHash = array.hashValue
        case .string(let string):
            innerHash = string.hashValue
        case .number(let number):
            innerHash = number.hashValue
        case .bool(let bool):
            innerHash = bool.hashValue
        case .null:
            innerHash = 0
        }
        return rawValue.hashValue &+ (innerHash ?? 0)
    }

    case object([JSONRow])
    case array([JSONValue])
    case string(String)
    case number(Int)
    case bool(Bool)
    case null

}

extension JSONValue {
    
    func rowForId(_ id: Int) -> JSONRow? {
        if case let .array(values) = self {
            for value in values {
                if let row = value.rowForId(id) {
                    return row
                }
            }
        }

        for row in objectValue {
            if row.value.id == id {
                return row
            }
            if let row = row.value.rowForId(id) {
                return row
            }
        }
        return nil
    }
    
}
