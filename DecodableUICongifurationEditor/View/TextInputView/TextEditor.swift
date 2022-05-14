//
//  TextEditor.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 06.05.2022.
//

import SwiftUI
import Combine

struct TextEditor: NSViewRepresentable {
    
    @Binding var text: String
    
    private let textColor: NSColor
    private let insertionPointColor: NSColor
    
    init(
        text: Binding<String>,
        textColor: Color = AppColor.editorText,
        insertionPointColor: Color = AppColor.editorInsertion
    ) {
        self._text = text
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
        
        let selectedRanges = textView.selectedRanges
        textView.string = text
        textView.selectedRanges = selectedRanges
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

extension TextEditor {
    
    class Coordinator: NSObject {
        
        private let openingCharacters: [Character] = ["{", "["]
        private let closingCharacters: [Character] = ["}", "]"]
        
        private var parent: TextEditor
        
        init(_ parent: TextEditor) {
            self.parent = parent
        }
        
    }
    
}

extension TextEditor.Coordinator: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
            return
        }
        parent.text = textView.string
    }
    
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(textView.insertNewline(_:)) {
            guard textView.string.count > 0 else {
                return false
            }
            
            let depth = depth(textView)

            let location = textView.selectedRange.location
            let currentIndex = textView.string.index(
                textView.string.startIndex,
                offsetBy: location
            )

            let previousIndex = textView.string.index(before: currentIndex)
            let previousCharacter = textView.string[previousIndex]

            if previousCharacter == lastOpeningCharacter(before: textView.string.count, in: textView.string) {
                let selectedRange = textView.selectedRange
                let tabulation = Array(repeating: "\t", count: depth - 1 < 0 ? 0 : depth - 1).joined()
                switch previousCharacter {
                case "{":
                    textView.insertText("\n\(tabulation)}", replacementRange: selectedRange)
                case "[":
                    textView.insertText("\n\(tabulation)]", replacementRange: selectedRange)
                default:
                    break
                }
                textView.selectedRange = selectedRange
            }

            textView.insertNewlineIgnoringFieldEditor(self)

            let tabulation = Array(repeating: "\t", count: depth).joined()
            textView.insertText(tabulation, replacementRange: textView.selectedRange())
            return true
        }
        return false
    }

    private func lastOpeningCharacter(before offset: Int, in text: String) -> Character? {
        text
            .prefix(offset)
            .filter { ["{", "}", "[", "]"].contains($0)}
            .reduce([]) { (unmatched: [Character], current: Character) -> [Character] in
                var mutable = unmatched
                
                var characterToMatch: Character?
                switch current {
                case "}":
                    characterToMatch = "{"
                case "]":
                    characterToMatch = "["
                default:
                    mutable.append(current)
                    return mutable
                }
                
                guard let characterToMatch = characterToMatch,
                      let index = unmatched.firstIndex(of: characterToMatch) else {
                    return mutable
                }

                mutable.remove(at: index)
                return mutable
            }
            .last
    }
    
    private func depth(offset: Int? = nil, _ textView: NSTextView) -> Int {
        let openingCharacters: [Character] = ["{", "["]
        let closingCharacters: [Character] = ["}", "]"]
        
        let offset = offset ?? textView.selectedRange().location

        return textView.string
            .prefix(offset)
            .map { character -> Int in
                if openingCharacters.contains(character) {
                    return 1
                } else if closingCharacters.contains(character) {
                    return -1
                }
                
                return 0
            }
            .reduce(0, +)
    }
    
}
