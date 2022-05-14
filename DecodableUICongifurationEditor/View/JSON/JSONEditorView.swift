//
//  JSONEditorView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Combine

struct JSONEditor: View {

    @Binding var json: [JSONRow]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach($json) { $pair in
                JSONRowView(item: $pair)
                if pair.id != json.last?.id {
                    Divider()
                        .foregroundColor(Color("Text").opacity(0.5))
                }
            }
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }

}
