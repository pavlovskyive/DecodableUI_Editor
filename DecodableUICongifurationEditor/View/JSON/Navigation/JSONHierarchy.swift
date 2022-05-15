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
            SideView(list: [jsonModel.jsonObject], content: link(to:))
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                })
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
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?
            .firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
}
