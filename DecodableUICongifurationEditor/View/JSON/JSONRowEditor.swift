//
//  JSONRowEditor.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import SwiftUI
import Combine

struct JSONRowEditor: View {

    @Binding var binding: JSONRow
    
    var body: some View {
        HStack {
            if let key = $binding.key.unwrap() {
                TextField("key", text: key)
            }
            Text(binding.typeDescription)
        }
    }
    
}

extension Binding {

    func unwrap<Wrapped>() -> Binding<Wrapped>? where Optional<Wrapped> == Value {
        guard let value = self.wrappedValue else { return nil }
        return Binding<Wrapped>(
            get: {
                return value
            },
            set: { value in
                self.wrappedValue = value
            }
        )
    }

}