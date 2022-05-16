//
//  JSONRow+NestedValuesContainable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONRow: NestedValuesContainable {
    
    var nestedValues: [JSONRow]? {
        let nestedValues = value.arrayValues + value.objectValues
        return nestedValues.isEmpty ? nil : nestedValues
    }
    
}
