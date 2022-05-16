//
//  JSONHierarchyRow.swift
//  DecodableUICongifurationEditor
//
//  Created by Vsevolod Pavlovskyi on 16.05.2022.
//

import SwiftUI
import Combine

private enum Constants {
    
    static let valueTypeOpacity: CGFloat = 0.5
    static let valueDescriptionOpacity: CGFloat = 0.8
    
}

struct JSONHierarchyRow: View {
    
    @EnvironmentObject var jsonModel: JSONModel
    
    var value: JSONValue
   
    var body: some View {
        Label {
            HStack(alignment: .top, spacing: 5) {
                if let key = jsonModel.rowForId(value.id)?.key {
                    Text(key)
                }
                Text(value.typeDescription)
                    .opacity(Constants.valueTypeOpacity)
                
                Text(value.description)
                    .opacity(Constants.valueDescriptionOpacity)
            }
            .padding(.leading, 5)
        } icon: {
            Image(systemName: value.imageSystemName)
        }
        .foregroundColor(AppColor.sidebarTextColor)
        .font(AppFont.sideBar)
    }
    
}
