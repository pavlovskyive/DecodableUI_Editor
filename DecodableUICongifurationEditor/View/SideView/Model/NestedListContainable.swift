//
//  NestedListContainable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 15.05.2022.
//

import Foundation

protocol NestedListContainable: Identifiable, Hashable {

    var children: [Self]? { get }
    
}
