//
//  FocusableTextFIeld.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 04.05.2022.
//

import SwiftUI
import Combine

struct MacEditorv2: NSViewRepresentable {

    @Binding var text: String
    @Binding var formattedText: String
    
    private let textColor: NSColor
    private let insertionPointColor: NSColor
    
    private let insertionPointSize: Float = 4
    
    init(
        text: Binding<String>,
        formattedText: Binding<String>,
        textColor: Color = AppColor.editorText,
        insertionPointColor: Color = AppColor.editorInsertion
    ) {
        self._text = text
        self._formattedText = formattedText
        self.textColor = NSColor(textColor)
        self.insertionPointColor = NSColor(textColor)
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.string = text
        
        textView.font = .monospacedSystemFont(ofSize: 16, weight: .regular)

        textView.textColor = textColor
        textView.insertionPointColor = insertionPointColor
        textView.backgroundColor = .clear
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.allowsUndo = true
        textView.autoresizingMask = [.width]
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        
        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.documentView = textView
        scroll.drawsBackground = false
        
        return scroll
    }
    
    func updateNSView(_ view: NSScrollView, context: Context) {
        guard let textView = view.documentView as? NSTextView else {
            return
        }
        
        guard textView.string != formattedText else {
            return
        }
        
        let difference = formattedText.difference(from: textView.string)
        
        let selectedRanges = textView.selectedRanges
        textView.string = formattedText
        
        var range: NSRange?
        
        for change in difference {
            switch change {
            case .insert(let offset, _, _):
                range = NSRange(location: offset + 1, length: 0)
            default:
                continue
            }
        }
        
        guard let range = range else {
            textView.selectedRanges = selectedRanges
            return
        }

        textView.setSelectedRange(range)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func lineDepth(_ newLineIndex: Int, in text: String) -> Int {
        let openingCharacters: [Character] = ["{", "["]
        let closingCharacters: [Character] = ["}", "]"]

        let charactersBefore = Array(text)[...newLineIndex]

        let openingsCount = charactersBefore.filter { openingCharacters.contains($0) }.count
        let closingsCount = charactersBefore.filter { closingCharacters.contains($0) }.count

        return openingsCount - closingsCount
    }
    
}

extension MacEditorv2 {
    
    class Coordinator: NSObject, NSTextViewDelegate, NSControlTextEditingDelegate {
        
        var parent: MacEditorv2
        var shouldInsertTabs: (atOffset: Int, count: Int)?
        
        init(_ parent: MacEditorv2) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            let text = textView.string
            
            parent.text = text
        }
        
    }
    
    
}
