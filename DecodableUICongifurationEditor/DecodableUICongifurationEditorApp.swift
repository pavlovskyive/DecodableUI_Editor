//
//  DecodableUICongifurationEditorApp.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 03.05.2022.
//

import SwiftUI

@main
struct DecodableUICongifurationEditorApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            SidebarCommands()
//            CommandGroup(replacing: CommandGroupPlacement.pasteboard) {
//                Button("Delete", action: {
//                    print("lalala")
//                })
//                .keyboardShortcut(.delete, modifiers: [])
//            }
        }
    }

}
