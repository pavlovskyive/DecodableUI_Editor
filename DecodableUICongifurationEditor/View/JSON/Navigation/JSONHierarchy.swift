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
            NestedList(list: [jsonModel.jsonObject], content: link(to:))
        }
        .deleteDisabled(jsonModel.selectedId == nil)
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
    
    private func link(to value: JSONValue) -> some View {
        NavigationLink(tag: value.id, selection: $jsonModel.selectedId) {
            // INFO: Temp
            Text("Detailed view for element: \(jsonModel.rowForId(value.id)?.key ?? "") \(value.typeDescription)")
        } label: {
            JSONHierarchyRow(value: value)
        }
        .deleteDisabled(false)
        .contextMenu {
            Button("Delete", action: handleDeleteCommand)
        }
    }
    
    private func handleDeleteCommand() {
        print("delete command")
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?
            .firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
}
