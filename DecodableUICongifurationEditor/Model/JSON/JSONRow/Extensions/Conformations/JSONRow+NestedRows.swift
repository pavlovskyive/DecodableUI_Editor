//
//  JSONRow+NestedValuesContainable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONRow: NestedValuesContainable {
    
    var nestedValues: [JSONRow]? {
        nestedRows.isEmpty ? nil : nestedRows
    }
    
}

extension JSONRow {
    
    var nestedRows: [JSONRow] {
        get {
            value.arrayValues + value.objectValues
        }
        set {
            switch value {
            case .array:
                value = .array(newValue)
            case .object:
                value = .object(newValue)
            default:
                return
            }
        }
    }
    
}
