//
//  JSONObjectValueView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI

struct JSONNestedObjectView: View {
    
    @Binding var object: JSONValue
    private let showSubview: (AnyView) -> Void
    
    var body: some View {
        Button {
            showSubview(AnyView(subview))
        } label: {
            HStack {
                Text("configuration")
                    .font(.system(size: 16, weight: .light, design: .monospaced))
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(.plain)
    }
    
    private var subview: some View {
        JSONObjectView(object: $object)
    }
    
    init(object: Binding<JSONValue>, showSubview: @escaping (AnyView) -> Void) {
        _object = object
        self.showSubview = showSubview
    }
    
}
