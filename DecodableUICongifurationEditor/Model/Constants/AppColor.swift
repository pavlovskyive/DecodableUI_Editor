//
//  AppColors.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 04.05.2022.
//

import SwiftUI

enum AppColor {
    
    static let editorBackround = Color("Editor")
    
    static let editorText = Color("Text")
    
    static let editorInsertion = Color("InsertionPoint")
    
}

extension Color {
    
    var nsColor: NSColor {
        NSColor(self)
    }
    
}
