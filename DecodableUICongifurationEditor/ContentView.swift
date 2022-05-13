//
//  ContentView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 03.05.2022.
//

import SwiftUI
import Combine
import DecodableUI

class DecodableUIProvider: ObservableObject {
    
    private let viewsService: DecodableViewsService
    
    @Published var view: AnyView? = AnyView(ProgressView().progressViewStyle(.circular))
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
    
    @Published var configuration: DecodableViewConfiguration?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewTypes: [String: DecodableView.Type]) {
        self.viewsService = DecodableViewsService(viewTypes: viewTypes)

        configurationPublisher
            .compactMap { configuration in
                if configuration == nil {
                    self.view = AnyView(ProgressView().progressViewStyle(.circular))
                }
                
                return configuration
            }
            .compactMap { (configuration: DecodableViewConfiguration) -> AnyView? in
                let view = self.viewsService.resolve(from: configuration)?.anyView
                if view == nil {
                    self.view = AnyView(Image(systemName: "exclamationmark.triangle"))
                }
                return view
            }
            .assign(to: \.view, on: self)
            .store(in: &cancellables)
    }
    
    var configurationPublisher: AnyPublisher<DecodableViewConfiguration?, Never> {
        $input
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
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

}

struct ContentView: View {

    @StateObject var uiProvider = DecodableUIProvider(viewTypes: [
        "Label": LabelView<DefaultViewModifier>.self,
        "Image": ImageView<DefaultViewModifier>.self,
        "Stack": StackView<DefaultViewModifier>.self
    ])
    
    var body: some View {
        HSplitView {
            codeEditor
            Group {
                uiProvider.view
                    .frame(minWidth: 300, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
                    .animation(.easeInOut)
            }
            .background(Color.white)
            .cornerRadius(40)
            .padding()
        }
        .background(Color("Editor"))

    }
    
    private var codeEditor: some View {
        TextEditor(text: $uiProvider.input)
            .padding()
            .frame(minWidth: 600, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
            
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension CharacterSet {
    
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
