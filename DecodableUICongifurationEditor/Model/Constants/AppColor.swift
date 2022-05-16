//
//  AppColors.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 04.05.2022.
//

import SwiftUI

enum AppColor {
    
    static let editorBackround = Color("Background")
    static let editorText = Color("Text")
    static let editorInsertion = Color("Text").opacity(0.8)

    static let primaryText = Color("Text")
    static let sidebarTextColor = Color.primary
    
}

extension Color {
    
    var nsColor: NSColor {
        NSColor(self)
    }
    
}
