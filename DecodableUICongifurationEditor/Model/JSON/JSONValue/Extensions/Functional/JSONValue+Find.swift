//
//  JSONValue+Find.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONValue {
    
    var nestedValues: [JSONValue] {
        [arrayValues, objectValues.map(\.value)].flatMap { $0 }
    }
    
    var nestedRows: [JSONRow] {
        [arrayValues.flatMap(\.objectValues), objectValues].flatMap { $0 }
    }
    
    func nestedRow(withValueId id: Int) -> JSONRow? {
//        nestedRows.first { $0.value.id == id }
        let rows: [JSONRow] = [arrayValues.flatMap(\.objectValues), objectValues].flatMap { $0 }
        for row in rows {
            if row.value.id == id {
                return row
            }
            if let row = row.value.nestedRow(withValueId: id) {
                return row
            }
        }
        return nil
    }
    
//    func nestedValue(with id: Int) -> JSONValue? {
//        nestedValues.first { $0.id == id }
//        if self.id == id {
//            return self
//        }
//
//        for value in arrayValues {
//            if let result = value.findValue(with: id) {
//                return result
//            }
//        }
//
//        for row in objectValues {
//            if row.value.id == id {
//                return row.value
//            }
//            if let value = row.value.findValue(with: id) {
//                return value
//            }
//        }
//    }
    
    func nestedParent(for id: Int) -> JSONValue? {
        guard self.id != id else {
            return nil
        }
        
        for value in nestedValues {
            if value.id == id {
                return self
            }
            if let result = value.nestedParent(for: id) {
                return result
            }
        }

        return nil
    }
    
}
