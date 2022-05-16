//
//  JSONRow+CustomStringConvertible.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

private enum Constants {

    static let maxObjectInnerCount = 3
    static let maxArrayInnerCount = 3

}

extension JSONRow {

    var valueDescription: String {
        switch value {
        case .object(let values):
            var innerString = values
                .prefix(Constants.maxObjectInnerCount)
                .compactMap { row in
                    guard let key = row.key else {
                        return nil
                    }
                    return "\(key): \(row.typeDescription)"
                }
                .joined(separator: ", ")

            if values.count > Constants.maxObjectInnerCount {
                innerString.append("...")
            }
            return "{ \(innerString) }"

        case .array(let values):
            var innerString = values
                .prefix(Constants.maxArrayInnerCount)
                .map(\.typeDescription)
                .joined(separator: ", ")
            
            if values.count > Constants.maxArrayInnerCount {
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
