//
//  NumberedPlainTextField.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Combine

struct NumberedPlainTextField: View {
    
    @Binding var number: Int
    @State var numberString: String

    var placeholder: String
    
    var body: some View {
        let binding = Binding(
            get: {
                String(describing: number)
            },
            set: {
                self.number = Int($0) ?? 0
            }
        )
        PlainTextField(placeholder, text: binding)
    }
    
    init(_ placeholder: String, number: Binding<Int>) {
        _number = number
        _numberString = .init(wrappedValue: String(describing: number))
        self.placeholder = placeholder
    }
    
}

