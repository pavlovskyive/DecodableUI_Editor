//
//  JSONHierarchy.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Combine

struct JSONHierarchy: View {
    
    var object: JSONValue
    
    var body: some View {
        NavigationView {
            ScrollView {
                JSONHierarchyObjectView(object: object)
                    .padding()
            }
            .background(AppColor.editorBackround)
            .navigationTitle("Decodable UI Editor")
            .frame(width: 400)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                })
            }
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
}

struct JSONHierarchyObjectView: View {
    
    var object: JSONValue
    
    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.blue.opacity(0.2))
                .frame(maxHeight: .infinity)
                .frame(width: 8)
                .padding(.trailing, 8)

            flow
                .frame(maxHeight: .infinity)
        }
    }
    
    private var flow: some View {
        VStack {
            ForEach(object.objectValue) { row in
                switch row.value {
                case .object:
                    VStack {
                        JSONHierarchyRowView(row: row)
                        JSONHierarchyObjectView(object: row.value)
                    }
                case let .array(values):
                    VStack {
                        JSONHierarchyRowView(row: row)
                        JSONHierarchyArrayView(elements: values)
                    }
                default:
                    JSONHierarchyRowView(row: row)
                }
            }
        }
    }
    
}

struct JSONHierarchyArrayView: View {
    
    var elements: [JSONValue]
    
    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.green.opacity(0.2))
                .frame(maxHeight: .infinity)
                .frame(width: 8)
                .padding(.trailing, 8)

            flow
                .frame(maxHeight: .infinity)
        }
    }
    
    private var flow: some View {
        VStack {
            ForEach(elements) { value in
                switch value {
                case .object:
                    JSONHierarchyObjectView(object: value)
                case let .array(values):
                    JSONHierarchyArrayView(elements: values)
                default:
                    JSONHierarchyRowView(value: value)
                }
            }
        }
    }
    
}

struct JSONHierarchyRowView: View {

    var row: JSONRow
    
    var body: some View {
        NavigationLink {
            Text("Detailed view for | \(row.value.rawValue) | \(row.value.jsonValue)")
        } label: {
            rowView
        }
        .buttonStyle(.plain)
    }
    
    init(row: JSONRow) {
        self.row = row
    }
    
    init(key: String? = nil, value: JSONValue) {
        self.row = JSONRow(key: key ?? "", value: value)
    }
    
    private var rowView: some View {
        HStack {
            Text(row.key)
            Text(row.value.rawValue)
                .foregroundColor(AppColor.editorText.opacity(0.5))
            Spacer()
            switch row.value {
            case .string, .number, .bool:
                Text(row.value.jsonValue)
            default:
                EmptyView()
            }
        }
        .foregroundColor(AppColor.editorText)
        .font(.system(size: 15, weight: .light, design: .monospaced))
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
    
}
