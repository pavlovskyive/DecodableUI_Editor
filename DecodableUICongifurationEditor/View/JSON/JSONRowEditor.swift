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

    @Binding var binding: JSONRow
    @State private var row: JSONRow
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                $row.key.unwrap().map { $key in
                    HStack(spacing: 12) {
                        Text("key:")
                            .opacity(0.9)
                        TextField("key", text: $key)
                            .textFieldStyle(.roundedBorder)
                    }
                    .frame(height: 40)
                }
                
                HStack(spacing: 12) {
                    Text("value:")
                        .font(AppFont.editor)
                        .opacity(0.9)

                    Picker(selection: $row.value.typeDescription, label: EmptyView()) {
                        ForEach(JSONValue.allCases.map(\.typeDescription), id: \.self) { type in
                            Text(type)
                        }
                    }
                    .frame(width: 100)
                    .disabled(jsonModel.isRootObject(row))
                    valueEditor
                }
                .frame(height: 40)
            }
            Spacer()
        }
        .font(AppFont.editor)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding()
        .onChange(of: row) {
            binding = $0
        }
    }
    
    init(row: Binding<JSONRow>) {
        _binding = row
        _row = .init(initialValue: row.wrappedValue)
    }
    
    @ViewBuilder
    private var valueEditor: some View {
        switch row.value {
        case .object:
            EmptyView()
        case .array:
            EmptyView()
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
            EmptyView()
        }
    }
    
}
