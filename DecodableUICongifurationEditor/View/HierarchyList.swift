//
//  HierarchyList.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 15.05.2022.
//

import SwiftUI
import Combine

struct HierarchyList<Element, HeaderContent, RowContent>: View
where
    Element: Identifiable,
    HeaderContent: View,
    RowContent: View
{
    fileprivate let recursiveView: RecursiveView<Element, RowContent>
    
    @Binding private var rootElement: Element
    private let rowContent: (Binding<Element>) -> RowContent
    private let headerContent: () -> HeaderContent
    
    var body: some View {
        List {
            headerContent()
            DisclosureGroup {
                recursiveView
            } label: {
                rowContent($rootElement)
            }
        }
        .listStyle(.sidebar)
    }
    
    init(
        rootElement: Binding<Element>,
        children: WritableKeyPath<Element, [Element]>,
        rowContent: @escaping (Binding<Element>) -> RowContent,
        header: @escaping () -> HeaderContent
    ) {
        recursiveView = RecursiveView(
            elements: rootElement[dynamicMember: children],
            children: children,
            rowContent: rowContent
        )
        _rootElement = rootElement
        self.headerContent = header
        self.rowContent = rowContent
    }
}

private struct RecursiveView<Element, RowContent>: View
where
    Element: Identifiable,
    RowContent: View
{
    @Binding var elements: [Element]
    let children: WritableKeyPath<Element, [Element]>
    let rowContent: (Binding<Element>) -> RowContent
    
    var body: some View {
        ForEach($elements) { $element in
            row(for: $element)
        }
    }
    
    @ViewBuilder
    private func row(for element: Binding<Element>) -> some View {
        let subChildren = element[dynamicMember: children]
        if !subChildren.wrappedValue.isEmpty {
            DisclosureGroup {
                RecursiveView(
                    elements: subChildren,
                    children: children,
                    rowContent: rowContent
                )
            } label: {
                rowContent(element)
            }
        } else {
            rowContent(element)
        }
    }

}
