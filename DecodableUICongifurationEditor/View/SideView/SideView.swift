//
//  SideView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 15.05.2022.
//

import SwiftUI
import Combine

struct SideView<E: NestedListContainable, Content: View>: View {
    
    var list: [E]
    var content: (E) -> Content
    
    var body: some View {
        List(list, children: \.children) { listItem in
            content(listItem)
        }
        .listStyle(.sidebar)
    }
    
}
