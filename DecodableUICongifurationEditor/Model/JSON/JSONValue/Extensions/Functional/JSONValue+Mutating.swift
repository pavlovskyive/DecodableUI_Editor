//
//  JSONValue+Mutating.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONValue {

    @discardableResult
    mutating func removingValue(with id: Int) -> JSONValue? {
        guard self.id != id else {
            return nil
        }
        
        switch self {
        case let .object(rows):
            self.objectValues = rows.compactMap { row -> JSONRow? in
                var mutable = row
                guard let updatedValue = mutable.value.removingValue(with: id) else {
                    return nil
                }
                mutable.value = updatedValue
                return mutable
            }
        case let .array(values):
            self.arrayValues = values.compactMap { value -> JSONValue? in
                var mutable = value
                return mutable.removingValue(with: id)
            }
        default:
            break
        }
        
        return self
    }
  
//        if nestedValues.contains { $0.id == id } {
//            // There is a child with given id.
//            // Remove that child and return `self` for parent to update
//            switch self {
//            case let .object(rows):
//                return .object(rows.filter { $0.value.id != id })
//            case let .array(values):
//                return .array(values.filter { $0.id != id })
//            default:
//                return self
//            }
//        }
    
//    private func removingNearestChild(with id: Int) -> JSONValue {
//        switch self {
//        case let .object(rows):
//            return .object(rows.filter { $0.value.id != id })
//        case let .array(values):
//            return .array(values.filter { $0.id != id })
//        default:
//            return self
//        }
//    }

    
}
