//
//  JSONRow+JSON.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation

extension JSONRow {
    
    var jsonValue: String {
        "\"\(key)\": \(value.jsonValue)"
    }
    
}
