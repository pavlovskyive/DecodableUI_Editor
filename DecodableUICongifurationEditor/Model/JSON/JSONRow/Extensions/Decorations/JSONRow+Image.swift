//
//  JSONRow+Image.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONRow {
    
    var imageSystemName: String {
        switch value {
        case .object:
            return "curlybraces"

        case .array:
            return "ellipsis.rectangle"

        case .string:
            return "textformat.abc"

        case .number:
            return "textformat.123"

        case .bool:
            return "togglepower"

        case .null:
            return "clear"
        }
    }
    
}
