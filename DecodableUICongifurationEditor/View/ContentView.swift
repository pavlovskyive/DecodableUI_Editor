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
    var jsonSubject = PassthroughSubject<String, Never>()
    
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
            .sink { [weak self] view in
                self?.view = view
            }
            .store(in: &cancellables)
    }
    
    private var configurationPublisher: AnyPublisher<DecodableViewConfiguration?, Never> {
        jsonSubject
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
        HStack(spacing: 0) {
            JSONEditor(jsonSubject: uiProvider.jsonSubject)
            Group {
                uiProvider.view
                    .animation(.easeInOut)
                    .environment(\.colorScheme, .light)
                    .frame(width: 300, height: 600)
                    .background(Color.white)
            }
            .cornerRadius(40)
            .padding()
        }

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
