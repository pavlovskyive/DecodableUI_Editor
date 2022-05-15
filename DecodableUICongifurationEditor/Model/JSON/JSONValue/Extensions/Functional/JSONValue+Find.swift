//
//  JSONValue+Find.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONValue {
    
    func findRow(withValueId id: Int) -> JSONRow? {
        for value in arrayValues {
            if let row = value.findRow(withValueId: (id)) {
                return row
            }
        }

        for row in objectValues {
            if row.value.id == id {
                return row
            }
            if let row = row.value.findRow(withValueId: id) {
                return row
            }
        }

        return nil
    }
    
    func findValue(with id: Int) -> JSONValue? {
        if self.id == id {
            return self
        }

        for value in arrayValues {
            if let result = value.findValue(with: id) {
                return result
            }
        }
        
        for row in objectValues {
            if row.value.id == id {
                return row.value
            }
            if let value = row.value.findValue(with: id) {
                return value
            }
        }

        return nil
    }
    
}
