//
//  JSONValue+RawRepresentable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation

extension JSONValue: RawRepresentable {
    
    init?(rawValue: String) {
        let type = JSONValue.allCases.first(where: { type in
            type.rawValue == rawValue
        })
        
        guard let type = type else {
            return nil
        }

        self = type
    }

    var rawValue: String {
        switch self {
        case .object:
            return "Object"
        case .array:
            return "Array"
        case .string:
            return "String"
        case .number:
            return "Number"
        case .bool:
            return "Bool"
        case .null:
            return "Null"
        }
    }
    
}

