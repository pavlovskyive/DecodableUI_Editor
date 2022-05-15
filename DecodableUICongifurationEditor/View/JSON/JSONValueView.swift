//
//  JSONValueView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Combine

struct JSONValueView: View {
    
    @Binding var value: JSONValue
    private let showSubview: (AnyView) -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Picker(selection: $value, label: EmptyView()) {
                ForEach(JSONValue.allCases, id: \.typeDescription) { value in
                    Text(value.typeDescription).tag(value)
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                }
            }
            .frame(width: 80)
            valueEditor
        }
    }
    
    init(value: Binding<JSONValue>, showSubview: @escaping (AnyView) -> Void) {
        _value = value
        self.showSubview = showSubview
    }
    
    @ViewBuilder
    var valueEditor: some View {
        switch value {
        case .object:
            JSONNestedObjectView(object: $value, showSubview: showSubview)
//            EmptyView()
        case .array:
            EmptyView()
        case .string:
            PlainTextField("string value", text: $value.stringValue)
        case .number:
            NumberedPlainTextField("number", number: $value.numberValue)
        case .bool:
            EmptyView()
        case .null:
            EmptyView()
        }
    }
    
}
