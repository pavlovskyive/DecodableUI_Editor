//
//  JSONValue+Identifiable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import Foundation

extension JSONValue: Identifiable {
    
    var id: Int {
        hashValue
    }
    
}
