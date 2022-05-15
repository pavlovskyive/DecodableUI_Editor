//
//  JSONRow+JSONString.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation

extension JSONRow {
    
    var jsonString: String {
        "\"\(key)\": \(value.jsonString)"
    }
    
}
