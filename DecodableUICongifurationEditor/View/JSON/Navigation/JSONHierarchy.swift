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
    
    private func link(to row: JSONRow) -> some View {
        NavigationLink(tag: row.id, selection: $jsonModel.selectedId) {
            // INFO: Temp
            Text("Detailed view for element: \(row.key ?? "") \(row.typeDescription)")
        } label: {
            JSONHierarchyRow(row: row)
        }
        .contextMenu {
            Button("Delete") {
                jsonModel.delete(with: row.id)
            }
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?
            .firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
}
