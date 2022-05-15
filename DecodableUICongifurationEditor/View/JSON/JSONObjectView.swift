//
//  JSONEditorView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Combine

struct JSONObjectView: View {
    
    @State private var currentSubview = AnyView(ContentView())
    @State private var showingSubview = false
    
    private func showSubview(view: AnyView) {
        withAnimation(.easeOut(duration: 0.3)) {
            currentSubview = view
            showingSubview = true
        }
    }

    @Binding var object: JSONValue
    
    var body: some View {
        StackNavigationView(
            currentSubview: $currentSubview,
            showingSubview: $showingSubview
        ) {
            content
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach($object.objectValues) { $pair in
                JSONRowView(item: $pair, showSubview: { self.showSubview(view: $0) })
                if pair.id != object.objectValues.last?.id {
                    Divider()
                        .foregroundColor(Color("Text").opacity(0.5))
                }
            }
            Divider()
                .foregroundColor(Color("Text").opacity(0.5))
            addButton
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
    
    private var addButton: some View {
        Button {
            object.objectValues.append(.init(key: "", value: .null))
        } label: {
            Text("add row")
                .font(.system(size: 16, weight: .light, design: .monospaced))
                .foregroundColor(AppColor.editorText)
        }
        .padding()
        .buttonStyle(.plain)
    }

}
