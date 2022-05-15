//
//  JSONValue+AssociatedValues.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation

extension JSONValue {
    
    // MARK: - .string

    var stringValue: String {
        get {
            guard case let .string(value) = self else {
                return ""
            }
            return value
        }
        set {
            guard case .string = self else {
                return
            }
            self = .string(newValue)
        }
    }
    
    // MARK: - .number

    var numberValue: Int {
        get {
            guard case let .number(value) = self else {
                return 0
            }
            return value
        }
        set {
            guard case .number = self else {
                return
            }
            self = .number(newValue)
        }
    }
    
    // MARK: - .object
    
    var objectValue: [JSONRow] {
        get {
            guard case let .object(value) = self else {
                return []
            }
            return value
        }
        set {
            guard case .object = self else {
                return
            }
            self = .object(newValue)
        }
    }
    
    // MARK: - .array
    
    var arrayValue: [JSONValue] {
        get {
            guard case let .array(values) = self else {
                return []
            }
            return values
        }
        set {
            guard case .array = self else {
                return
            }
            self = .array(newValue)
        }
    }
    
}
