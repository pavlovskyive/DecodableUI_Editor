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
    
    var body: some View {
        HStack {
            Picker(selection: $value, label: EmptyView()) {
                ForEach(JSONValue.allCases, id: \.rawValue) { value in
                    Text(value.rawValue).tag(value)
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                }
            }
            .frame(width: 80)
            valueEditor
        }
    }
    
    @ViewBuilder
    var valueEditor: some View {
        switch value {
        case .object:
            EmptyView()
        case .array:
            EmptyView()
        case .string:
            PlainTextField("string value", text: $value.stringValue)
        case .number:
            NumberedPlainTextField("", number: $value.numberValue)
        case .bool:
            EmptyView()
        case .null:
            EmptyView()
        }
    }
    
}
