//
//  JSONValue+NestedListContainable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 15.05.2022.
//

import Foundation

extension JSONValue: NestedListContainable {

    var children: [JSONValue]? {
        let nestedValues = self.nestedValues
        return nestedValues.isEmpty ? nil : nestedValues
    }
    
}
