//
//  PlainTextField.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Combine

fileprivate enum Constants {
    
    static let insertionPointSize: CGFloat = 4
    static let textColor = AppColor.editorText.nsColor
    static let insertionPointColor = AppColor.editorInsertion.nsColor
    static let placeholderColor = AppColor.editorText.nsColor.withAlphaComponent(0.7)
    static let font = NSFont.monospacedSystemFont(ofSize: 16, weight: .light)
    
}


class PlainStyledNSTextField: NSTextField {
    
    override func becomeFirstResponder() -> Bool {
        let textView = window?.fieldEditor(true, for: nil) as? NSTextView
        textView?.insertionPointColor = Constants.insertionPointColor

        return super.becomeFirstResponder()
    }
    
    override var placeholderString: String? {
        get {
            super.placeholderString
        }
        set {
            placeholderAttributedString = NSAttributedString(
                string: newValue ?? "",
                attributes: [
                    NSAttributedString.Key.foregroundColor: Constants.placeholderColor,
                    NSAttributedString.Key.font: Constants.font
                ]
            )
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        font = Constants.font
        textColor = Constants.textColor

        drawsBackground = false
        autoresizingMask = [.width]
        translatesAutoresizingMaskIntoConstraints = true
        isBordered = false
        isBezeled = false
        focusRingType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct PlainTextField: NSViewRepresentable {
    
    @Binding var text: String
    private let placeholder: String
    
    init(
        _ placeholder: String,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self._text = text
    }
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = PlainStyledNSTextField()
        textField.delegate = context.coordinator
        textField.stringValue = text
        textField.placeholderString = placeholder
        
        return textField
    }
    
    func updateNSView(_ view: NSTextField, context: Context) {
        view.stringValue = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

extension PlainTextField {
    
    class Coordinator: NSObject {
        
        private var parent: PlainTextField
        
        init(_ parent: PlainTextField) {
            self.parent = parent
        }
        
    }
    
}

extension PlainTextField.Coordinator: NSTextFieldDelegate {

    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        self.parent.text = textField.stringValue
    }

}

extension NSTextField {

    public func setInsertionPointColor(_ color: NSColor) {
        let fieldEditor = self.window?.fieldEditor(true, for: nil) as? NSTextView
        fieldEditor?.insertionPointColor = color
    }

}
