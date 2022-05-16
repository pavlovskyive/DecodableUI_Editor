//
//  JSONHierarchy.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Combine

struct JSONHierarchy: View {
    
    @EnvironmentObject var jsonModel: JSONModel
    
    var body: some View {
        NavigationView {
            NestedList(list: [jsonModel.rootObject]) { row in
                link(to: row)
            }
        }
        .onDeleteCommand {
            jsonModel.deleteSelected()
        }
        .keyboardShortcut(KeyboardShortcut(.delete, modifiers: []))
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    toggleSidebar()
                } label: {
                    Image(systemName: "sidebar.leading")
                }
            }
        }
    }
    
    @ViewBuilder
    private func link(to row: JSONRow) -> some View {
        let rowBinding = Binding {
            jsonModel.getRow(with: row.id)
        } set: {
            guard let row = $0 else {
                return
            }
            jsonModel.setRow(row)
        }
        
        if let rowBinding = rowBinding.unwrap() {
            NavigationLink(tag: row.id, selection: $jsonModel.selectedId) {
                JSONRowEditor(binding: rowBinding)
            } label: {
                JSONHierarchyRow(row: row)
            }
            .contextMenu {
                Button("New") {
                    jsonModel.create(after: row.id)
                }
                .keyboardShortcut(KeyboardShortcut(.init("o"), modifiers: [.command]))
                Button("Delete") {
                    jsonModel.delete(with: row.id)
                }
                .keyboardShortcut(KeyboardShortcut(.delete, modifiers: []))
            }
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?
            .firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
}
