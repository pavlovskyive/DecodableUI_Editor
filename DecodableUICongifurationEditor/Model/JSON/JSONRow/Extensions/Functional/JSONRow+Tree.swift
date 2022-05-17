//
//  JSONRow+Tree.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

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

// MARK: -CRUD

extension JSONRow {
    
    @discardableResult
    mutating func removeRow(with id: UUID) -> JSONRow? {
        guard self.id != id else {
            return nil
        }
        
        switch value {
        case let .object(rows):
            self.value.objectValues = rows.compactMap { row -> JSONRow? in
                var mutable = row
                guard let updatedRow = mutable.removeRow(with: id) else {
                    return nil
                }
                return updatedRow
            }
        case let .array(values):
            self.value.arrayValues = values.compactMap { row -> JSONRow? in
                var mutable = row
                guard let updatedRow = mutable.removeRow(with: id) else {
                    return nil
                }
                return updatedRow
            }
        default:
            break
        }
        
        return self
    }
    
    @discardableResult
    mutating func create(after id: UUID) -> JSONRow? {
        var newRow = JSONRow(value: .null)
        if case .object = value {
            newRow.key = "key"
        }

        if self.id == id {
            switch value {
            case .object, .array:
                nestedRows.insert(newRow, at: 0)
                return newRow
            default:
                break
            }
        }

        for (index, row) in nestedRows.enumerated() {
            switch row.value {
            case .object, .array:
                break
            default:
                if row.id == id {
                    nestedRows.insert(newRow, at: index + 1)
                    return newRow
                }
            }
            
            var mutable = row
            
            if let result = mutable.create(after: id) {
                nestedRows[index] = mutable
                return result
            }
        }
        
        return nil
    }
    
    func getRow(with id: UUID) -> JSONRow? {
        guard self.id != id else {
            return self
        }
        
        for row in nestedRows {
            if let result = row.getRow(with: id) {
                return result
            }
        }
        
        return nil
    }
    
    @discardableResult
    mutating func setRow(_ row: JSONRow) -> Bool {
        guard self.id != row.id else {
            self = row
            return true
        }
        
        for (index, nestedRow) in nestedRows.enumerated() {
            var mutable = nestedRow
            if mutable.setRow(row) == true {
                nestedRows[index] = mutable
                return true
            }
        }
        return false
    }
    
    func previousWideRow(for id: UUID) -> JSONRow? {
        for (index, row) in nestedRows.enumerated() {
            if row.id == id {
                let index = index - 1
                return index >= 0 ? nestedRows[index] : self
            }
            if let result = row.previousWideRow(for: id) {
                return result
            }
        }
        
        return nil
    }
    
}
