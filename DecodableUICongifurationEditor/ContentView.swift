//
//  ContentView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 03.05.2022.
//

import SwiftUI
import Combine
import DecodableUI

class InputHandler: ObservableObject {

    @Published var input =
    """
    {
    \t"type": "Label",
    \t"parameters": {
    \t\t"text": "Sample text 1",
    \t\t"fontColor": "A1A1B2",
    \t\t"lineLimit": 1,
    \t\t"padding": 15,
    \t\t"cornerRadius": 8
    \t}
    }
    """
    
    @Published var formattedInput = ""

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        formattedLines
            .map { lines in
                lines.joined(separator: "\n")
            }
            .assign(to: \.formattedInput, on: self)
            .store(in: &cancellables)
        
        $formattedInput
            .assign(to: \.input, on: self)
            .store(in: &cancellables)
    }
    
    var formattedLines: AnyPublisher<[String], Never> {
        inputLinesPublisher
            .removeDuplicates()
            .withPrevious()
            .map { previous, current -> [String] in
                typealias ChangedLine = (offset: Int, value: String)
                
                print("new lines arrives")
                
                guard let previous = previous else {
                    print("first time here")
                    return current
                }
                
                // Format lines
                
                var mutable = current
                
                let difference = current.difference(from: previous)

                guard !difference.isEmpty else {
                    return current
                }

                var insertionChange: ChangedLine?
                var removalChange: ChangedLine?

                // Getting first changes
                for change in difference {
                    switch change {
                    case .insert(let offset, let value, _):
                        insertionChange = ChangedLine(offset: offset, value: value)
                    case .remove(let offset, let value, _):
                        removalChange = ChangedLine(offset: offset, value: value)
                    }
                }


                // On new line
                if let insertionChange = insertionChange {
                    var newlineOffset = insertionChange.offset

                    guard newlineOffset != removalChange?.offset else {
                        return mutable
                    }

                    // Remove previous line if its empty
                    let previousLineOffset = newlineOffset - 1

                    if let previousLine = mutable[safe: previousLineOffset],
                       previousLine.isEmpty {
                        mutable.remove(at: previousLineOffset)
                        newlineOffset = previousLineOffset
                    }

                    // Add tabulation
                    let depth = self.lineDepth(lineOffset: newlineOffset, lines: mutable)
                    let tabulation = Array(repeating: "\t", count: depth).joined()

                    mutable[newlineOffset].insert(
                        contentsOf: tabulation,
                        at:  mutable[newlineOffset].startIndex
                    )
                }

                return mutable
            }
            .eraseToAnyPublisher()
    }
    
    var inputLinesPublisher: AnyPublisher<[String], Never> {
        $input
            .removeDuplicates()
            .filter { input in
                input != self.formattedInput
            }
            .map { input in
                print("New input arrives")
                return input.components(separatedBy: CharacterSet.newlines)
            }
            .eraseToAnyPublisher()
    }
    
    private func lineDepth(lineOffset: Int, lines: [String]) -> Int {
        let openingCharacters: [Character] = ["{", "["]
        let closingCharacters: [Character] = ["}", "]"]

        return lines[...lineOffset]
            .map { line -> Int in
                let openingsCount = Array(line).filter { openingCharacters.contains($0) }.count
                let closingsCount = Array(line).filter { closingCharacters.contains($0) }.count
                
                return openingsCount - closingsCount
            }
            .reduce(0, +)
    }

}

class DecodableUIProvider: ObservableObject {
    
    private let viewsService: DecodableViewsService
    
    @Published var view: AnyView? = nil
    @Published var input: String = ""
    
    @Published var configuration: DecodableViewConfiguration?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewTypes: [String: DecodableView.Type]) {
        self.viewsService = DecodableViewsService(viewTypes: viewTypes)

        configurationPublisher
            .compactMap { $0 }
            .compactMap { configuration in
                self.viewsService.resolve(from: configuration)?.anyView
            }
            .assign(to: \.view, on: self)
            .store(in: &cancellables)
    }
    
    var configurationPublisher: AnyPublisher<DecodableViewConfiguration?, Never> {
        $input
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .compactMap {
                $0.data(using: .utf8)
            }
            .flatMap {
                Just($0)
                    .decode(type: DecodableViewConfiguration?.self, decoder: JSONDecoder())
                    .replaceError(with: nil)
            }
            .eraseToAnyPublisher()
    }
    
    func subscribeToInput(_ inputPublisher: Published<String>.Publisher) {
        inputPublisher
            .assign(to: &$input)
    }
    
}

struct ContentView: View {
    
    @StateObject var inputHandler = InputHandler()
    @StateObject var uiProvider = DecodableUIProvider(viewTypes: [
        "Label": LabelView<DefaultViewModifier>.self,
        "Image": ImageView<DefaultViewModifier>.self,
        "Stack": StackView<DefaultViewModifier>.self
    ])
    
    var body: some View {
        HStack {
            codeEditor
            Group {
                uiProvider.view
            }
            .frame(minWidth: 300, minHeight: 600)
        }
        .frame(idealWidth: 900, maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            uiProvider.subscribeToInput(inputHandler.$input)
        }
    }
    
    private var codeEditor: some View {
        MacEditorv2(text: $inputHandler.input,
                    formattedText: $inputHandler.formattedInput)
            .padding()
            .background(Color("Editor"))
            .frame(minWidth: 600, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


private extension CharacterSet {
    
    func containsUnicodeScalars(of character: Character) -> Bool {
        character.unicodeScalars.allSatisfy(contains(_:))
    }
    
}

extension Publisher {
    
    typealias Pairwise<T> = (previous: T?, current: T)
    
    func withPrevious() -> AnyPublisher<Pairwise<Output>, Failure> {
        scan(nil) { previousPair, currentElement -> Pairwise<Output>? in
            Pairwise(previous: previousPair?.current, current: currentElement)
        }
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }
    
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
