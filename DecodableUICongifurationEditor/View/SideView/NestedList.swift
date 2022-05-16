//
//  NestedList.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 15.05.2022.
//

import SwiftUI
import Combine

struct NestedList<E: NestedValuesContainable, Content: View>: View {

    var list: [E]
    var content: (E) -> Content

    var body: some View {
        List(list, children: \.nestedValues) { value in
            content(value)
        }
        .listStyle(.sidebar)
    }

}
