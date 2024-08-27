//
//  File.swift
//  
//
//  Created by Admin on 20/08/24.
//

import SwiftUI
// MARK: Sample Tab Model And Data
@available(iOS 14.0, *)
public struct PagerTab: Identifiable, Equatable {
    public var id: String = UUID().uuidString
    public var titleView: AnyView?
    public var contentView: AnyView
    
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    
    public init(titleView: AnyView? = nil, contentView: AnyView) {
        self.titleView = titleView
        self.contentView = contentView
    }
    
    // Implement Equatable manually, excluding AnyView from the comparison
    public static func == (lhs: PagerTab, rhs: PagerTab) -> Bool {
        return lhs.id == rhs.id &&
               lhs.size == rhs.size &&
               lhs.minX == rhs.minX
    }
}

@available(iOS 14.0, *)
var sampleTabs: [PagerTab] = [
    .init(titleView: AnyView(HStack
                             {
                                 Text("Iceland")
                                     .font(.system(size: 20))
                             })
          , contentView: AnyView(Text("Iceland Content"))),
    .init(titleView: AnyView(HStack
                             {
                                 Text("Iceland")
                                     .font(.system(size: 20))
                                 Image(systemName: "person.fill")
                             }),
          contentView: AnyView(Text("What about you Content"))),
    .init(titleView: AnyView(HStack
                             { 
                                 Image(systemName: "gear")
                                     .font(.system(size: 20))
                             }),
          contentView: AnyView(Text("Brazil Content")))
]
