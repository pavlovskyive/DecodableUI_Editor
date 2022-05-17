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
        
        rowBinding.unwrap().map { $row in
            NavigationLink(tag: row.id, selection: $jsonModel.selectedId) {
                JSONRowEditor(row: $row)
            } label: {
                JSONHierarchyRow(row: row)
            }
            .deleteDisabled(jsonModel.isRootObject(row))
            .contextMenu {
                Button("New") {
                    jsonModel.create(after: row.id)
                }
                .keyboardShortcut(KeyboardShortcut(.init("o"), modifiers: [.command]))

                Button("Delete") {
                    jsonModel.delete(with: row.id)
                }
                .disabled(jsonModel.isRootObject(row))
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
