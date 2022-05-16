//
//  JSONEditor.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import SwiftUI
import Combine

struct JSONEditor: View {

    @StateObject private var jsonModel = JSONModel()
    
    var jsonSubject: PassthroughSubject<String, Never>
    
    var body: some View {
        JSONHierarchy()
            .onReceive(jsonModel.jsonPublisher) {
                jsonSubject.send($0)
            }
            .environmentObject(jsonModel)
    }
    
}
