//
//  JSONValue+JSON.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation

extension JSONValue {
    
    var jsonValue: String {
        switch self {
        case let .object(rows):
            let innerJSON = rows.map { row in
                row.jsonValue
            }.joined(separator: ", ")
            return "{\(innerJSON)}"
        case let .array(elements):
            let innerJSON = elements.map { element in
                element.jsonValue
            }.joined(separator: ", ")
            return "[\(innerJSON)]"
        case .string(let string):
            return "\"\(string)\""
        case .number(let number):
            return "\(number)"
        case .bool(let bool):
            return "\(bool)"
        case .null:
            return ""
        }
    }
    
}
