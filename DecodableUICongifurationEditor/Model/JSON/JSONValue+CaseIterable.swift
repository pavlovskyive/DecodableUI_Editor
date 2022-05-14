//
//  JSONValue+CaseIterable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation

extension JSONValue: CaseIterable {
    
    static var allCases: [JSONValue] {
        [
            .object([:]),
            .array([]),
            .string(""),
            .number(0),
            .bool(false),
            .null
        ]
    }
    
}
