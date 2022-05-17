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
            HierarchyList(
                rootElement: $jsonModel.rootObject,
                children: \.nestedRows
            ) { $row in
                link(to: $row)
                
            } header: {
                Text("Hierarchy")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(.blue.opacity(0.8))
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
    private func link(to row: Binding<JSONRow>) -> some View {
        NavigationLink(tag: row.wrappedValue.id, selection: $jsonModel.selectedId) {
            JSONRowEditor(row: row)
        } label: {
            JSONHierarchyRow(row: row.wrappedValue)
        }
        .deleteDisabled(jsonModel.isRootObject(row.wrappedValue))
        .contextMenu {
            Button("New") {
                jsonModel.create(after: row.wrappedValue.id)
            }
            .keyboardShortcut(KeyboardShortcut(.init("o"), modifiers: [.command]))

            Button("Delete") {
                jsonModel.delete(with: row.wrappedValue.id)
            }
            .disabled(jsonModel.isRootObject(row.wrappedValue))
            .keyboardShortcut(KeyboardShortcut(.delete, modifiers: []))
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?
            .firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
}
