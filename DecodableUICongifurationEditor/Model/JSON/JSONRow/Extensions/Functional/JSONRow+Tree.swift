//
//  JSONRow+Tree.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONRow {
    
    @discardableResult
    mutating func removingRow(with id: UUID) -> JSONRow? {
        guard self.id != id else {
            return nil
        }
        
        switch value {
        case let .object(rows):
            self.value.objectValues = rows.compactMap { row -> JSONRow? in
                var mutable = row
                guard let updatedRow = mutable.removingRow(with: id) else {
                    return nil
                }
                return updatedRow
            }
        case let .array(values):
            self.value.arrayValues = values.compactMap { row -> JSONRow? in
                var mutable = row
                guard let updatedRow = mutable.removingRow(with: id) else {
                    return nil
                }
                return updatedRow
            }
        default:
            break
        }
        
        return self
    }
    
}
