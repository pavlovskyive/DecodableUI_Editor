//
//  JSONModel.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import SwiftUI
import Combine

class JSONModel: ObservableObject {
    
    @Published var selectedId: UUID?
    @Published var rootObject = JSONRow(
        value: .object([
            JSONRow(
                key: "type",
                value: .string("Stack")
            ),
            JSONRow(
                key: "isAvailable",
                value: .bool(false)
            ),
            JSONRow(
                key: "parameters",
                value: .object([
                    JSONRow(key: "direction", value: .string("vertical")),
                    JSONRow(
                        key: "elements",
                        value: .array([
                            JSONRow(
                                value: .object([
                                    JSONRow(key: "type", value: .string("Label")),
                                    JSONRow(key: "parameters", value: .object([
                                        JSONRow(key: "text", value: .string("Some text 1"))
                                    ]))
                                ])
                            ),
                            JSONRow(
                                value: .object([
                                    JSONRow(key: "type", value: .string("Image")),
                                    JSONRow(key: "parameters", value: .object([
                                        JSONRow(key: "systemName", value: .string("photo"))
                                    ]))
                                ])
                            )
                        ])
                    )
                ])
            )
        ])
    )
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        selectedId = rootObject.id
    }
    
    var jsonPublisher: AnyPublisher<String, Never> {
        $rootObject
            .map {
                $0.jsonString
            }
            .eraseToAnyPublisher()
    }
    
    func create(after id: UUID) {
        let newRow = rootObject.create(after: id)
        DispatchQueue.main.async { [weak self] in
            self?.selectedId = newRow?.id
        }
    }
    
    func delete(with id: UUID) {
        guard rootObject.id != id else {
            rootObject.value = .object([])
            return
        }

        let selectedId = selectedId
        let previousRow = rootObject.previousWideRow(for: id)

        rootObject.removeRow(with: id)
        
        if selectedId == id {
            DispatchQueue.main.async { [weak self] in
                self?.selectedId = previousRow?.id
            }
        }
    }

    func deleteSelected() {
        guard let id = selectedId else {
            return
        }
        
        delete(with: id)
    }
    
    func setRow(_ row: JSONRow) {
        rootObject.setRow(row)
    }
    
    func getRow(with id: UUID) -> JSONRow? {
        rootObject.getRow(with: id)
    }
    
}
