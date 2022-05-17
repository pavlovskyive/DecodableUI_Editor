//
//  JSONRowKeyField.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 17.05.2022.
//

import SwiftUI
import Combine

struct JSONRowKeyField: View {
    
    @Binding private var key: String?
    @State private var state: String
    
    var body: some View {
        TextField("key", text: $state)
            .textFieldStyle(.roundedBorder)
            .disabled(key == nil)
            .onChange(of: state) {
                if key != $0 {
                    key = $0
                }
            }
    }
    
    init(key: Binding<String?>) {
        _key = key
        _state = .init(initialValue: key.wrappedValue ?? "")
    }
    
}
