//
//  StackNavigationView.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 14.05.2022.
//

import SwiftUI
import Combine

struct StackNavigationView<RootContent: View>: View {
    
    @Binding var currentSubview: AnyView
    @Binding var showingSubview: Bool
    
    let rootView: () -> RootContent
    
    var body: some View {
        VStack {
            if !showingSubview {
                rootView()
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Image(systemName: "house")
                                .frame(width: 50, alignment: .leading)
                        }
                    }
            } else {
                subview
            }
        }
    }
   
    init(
        currentSubview: Binding<AnyView>,
        showingSubview: Binding<Bool>,
        @ViewBuilder rootView: @escaping () -> RootContent
    ) {
        self._currentSubview = currentSubview
        self._showingSubview = showingSubview
        self.rootView = rootView
    }
    
    private var subview: some View {
        StackNavigationSubview(isVisible: $showingSubview) {
            currentSubview
        }
        .transition(.move(edge: .trailing))
    }
    
}

private struct StackNavigationSubview<Content: View>: View {

    @Binding var isVisible: Bool
    let contentView: () -> Content
    
    var body: some View {
        VStack {
            contentView()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                toolbarButton
                    .frame(width: 50, alignment: .leading)
            }
        }
    }
    
    var toolbarButton: some View {
        Button {
            withAnimation(.spring()) {
                isVisible = false
            }
        } label: {
            Label("back", systemImage: "chevron.left")
        }
    }

}
