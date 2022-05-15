//
//  JSONValue+NestedListContainable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 15.05.2022.
//

import Foundation

extension JSONValue: NestedListContainable {

    var children: [JSONValue]? {
        switch self {
        case let .object(rows):
            return rows.map(\.value)
        case let .array(values):
            return values
        default:
            return nil
        }
    }
    
}
