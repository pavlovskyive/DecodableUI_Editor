//
//  NestedListContainable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 15.05.2022.
//

import Foundation

protocol NestedValuesContainable: Identifiable, Hashable {

    var nestedValues: [Self]? { get }
    
}
