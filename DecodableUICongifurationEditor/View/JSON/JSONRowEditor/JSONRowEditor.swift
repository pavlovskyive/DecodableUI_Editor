//
//  JSONRowEditor.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import SwiftUI
import Combine

struct JSONRowEditor: View {
    
    @EnvironmentObject private var jsonModel: JSONModel

    @Binding var row: JSONRow
    
    private let columns = [GridItem(.fixed(100), alignment: .trailing),
                           GridItem(.fixed(250), alignment: .leading)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Value editing")
                .font(.system(.title, design: .monospaced))
            LazyVGrid(columns: columns, spacing: 0) {
                if row.key != nil {
                    Text("Key:")
                        .opacity(row.key == nil ? 0.5 : 0.8)
                        .frame(height: 30)
                    JSONRowKeyField(key: $row.key)
                        .opacity(row.key == nil ? 0.5 : 1)
                        .frame(height: 30)
                }
                
                Text("Type:")
                    .opacity(0.9)
                    .frame(height: 30)
                
                Picker(selection: $row.value.typeDescription, label: EmptyView()) {
                    ForEach(JSONValue.allCases.map(\.typeDescription), id: \.self) { type in
                        Text(type)
                    }
                }
                .frame(width: 100)
                .disabled(jsonModel.isRootObject(row))
                .frame(height: 30)
                
                Text("Value:")
                    .opacity(0.9)
                    .frame(height: 30)
                
                valueEditor
                    .frame(minHeight: 30)
            }
            .padding(15)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private var valueEditor: some View {
        switch row.value {
        case .object:
            Text("Temp")
        case .array:
            Text("Temp")
        case .string:
            TextField("string value", text: $row.value.stringValue)
                .textFieldStyle(.roundedBorder)
        case .number:
            TextField("0", text: Binding(
                get: {
                    String(describing: row.value.numberValue)
                },
                set: {
                    row.value.numberValue = Int($0) ?? 0
                }))
                .textFieldStyle(.roundedBorder)
        case .bool:
            Toggle("", isOn: $row.value.boolValue)
                .toggleStyle(.switch)
        case .null:
            Text("Null")
        }
    }
    
}
