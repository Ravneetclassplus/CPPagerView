//
//  File.swift
//  
//
//  Created by Admin on 20/08/24.
//

import SwiftUI
// MARK: Sample Tab Model And Data
@available(iOS 14.0, *)
public struct Tab: Identifiable, Equatable {
    public var id: String = UUID().uuidString
    public var tabName: String
    public var titleImage: Image?
    public var contentView: AnyView
    
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    
    public init(tabName: String, titleImage: Image? = nil, contentView: AnyView) {
        self.tabName = tabName
        self.titleImage = titleImage
        self.contentView = contentView
    }
    
    // Implement Equatable manually, excluding AnyView from the comparison
    public static func == (lhs: Tab, rhs: Tab) -> Bool {
        return lhs.id == rhs.id &&
               lhs.tabName == rhs.tabName &&
               lhs.titleImage == rhs.titleImage &&
               lhs.size == rhs.size &&
               lhs.minX == rhs.minX
    }
}

@available(iOS 14.0, *)
var sampleTabs: [Tab] = [
    .init(tabName: "Iceland", titleImage: nil, contentView: AnyView(Text("Iceland Content"))),
    .init(tabName: "What about you", titleImage: Image(systemName: "person.fill"), contentView: AnyView(Text("What about you Content"))),
    .init(tabName: "Brazil", titleImage: Image(systemName: "gear"), contentView: AnyView(Text("Brazil Content")))
]
