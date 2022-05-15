//
//  JSONValue.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import Foundation
import OrderedCollections

enum JSONValue {

    case object([JSONRow])
    case array([JSONValue])
    case string(String)
    case number(Int)
    case bool(Bool)
    case null

}
