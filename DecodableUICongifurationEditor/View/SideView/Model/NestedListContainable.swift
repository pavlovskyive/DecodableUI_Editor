//
//  NestedListContainable.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 15.05.2022.
//

import Foundation

protocol NestedListContainable: Identifiable {

    var children: [Self]? { get }
    
}
