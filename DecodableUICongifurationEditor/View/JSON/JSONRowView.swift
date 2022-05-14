//
//  JSONRowView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Foundation

struct JSONRowView: View {
    
    @Binding var item: JSONRow
    
    private let showSubview: (AnyView) -> Void
    
    var body: some View {
        HStack {
            PlainTextField("key", text: $item.key)
                .frame(width: 100, alignment: .leading)
                .padding()

            Divider()
                .foregroundColor(Color("Text").opacity(0.5))

            JSONValueView(value: $item.value, showSubview: showSubview)
                .padding()
            Spacer()
        }
        .frame(height: 50)
        .foregroundColor(Color("Text"))
    }
    
    init(item: Binding<JSONRow>, showSubview: @escaping (AnyView) -> Void) {
        _item = item
        self.showSubview = showSubview
    }
    
}
