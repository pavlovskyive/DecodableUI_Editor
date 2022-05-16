//
//  JSONRow+TypeDesctiption.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONRow {

    var typeDescription: String {
        switch value {
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
