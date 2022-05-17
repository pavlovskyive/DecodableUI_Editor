//
//  AppFont.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import SwiftUI
import CoreText

enum AppFont {

    static let sidebar = Font.system(size: 12, weight: .regular, design: .monospaced)

    static let typePicker = Font.system(size: 14, weight: .light, design: .monospaced)

    static let editor = Font.system(size: 16, weight: .light, design: .monospaced)
    static let nsEditor = NSFont.monospacedSystemFont(ofSize: 16, weight: .light)

}
