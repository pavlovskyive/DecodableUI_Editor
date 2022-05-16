//
//  JSONRow.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation

struct JSONRow: Identifiable, Hashable {

    let id = UUID()

    var key: String?
    var value: JSONValue
    
    init(key: String? = nil, value: JSONValue) {
        self.key = key
        self.value = value
    }

}
