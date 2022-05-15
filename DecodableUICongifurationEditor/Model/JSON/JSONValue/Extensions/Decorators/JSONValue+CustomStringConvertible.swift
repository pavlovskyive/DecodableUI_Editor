//
//  JSONValue+CustomStringConvertible.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

private enum Constants {

    static let maxObjectInnerElements = 3
    static let maxArrayInnerElements = 3

}

extension JSONValue: CustomStringConvertible {

    var description: String {
        switch self {
        case .object(let rows):
            var innerString = rows
                .prefix(Constants.maxObjectInnerElements)
                .map { row in
                    return "\(row.key): \(row.value.typeDescription)"
                }
                .joined(separator: ", ")

            if rows.count > Constants.maxObjectInnerElements {
                innerString.append("...")
            }
            return "{ \(innerString) }"

        case .array(let values):
            var innerString = values
                .prefix(Constants.maxArrayInnerElements)
                .map(\.typeDescription)
                .joined(separator: ", ")
            
            if values.count > Constants.maxArrayInnerElements {
                innerString.append("...")
            }
            return "[ \(innerString) ]"

        case .string(let string):
            return "\"\(string)\""

        case .number(let number):
            return String(describing: number)

        case .bool(let bool):
            return String(describing: bool)

        case .null:
            return ""
        }
    }
    
}
