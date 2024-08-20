//
//  File.swift
//  
//
//  Created by Admin on 20/08/24.
//

import SwiftUI
// MARK: Sample Tab Model And Data
public struct Tab: Identifiable, Equatable {
    public var id: String = UUID().uuidString
    public var tabName: String
    public var sampleImage: String
    
    var size: CGSize = .zero
    var minX: CGFloat = .zero
}

var sampleTabs: [Tab] = [
    .init(tabName: "Iceland", sampleImage: "house"),
    .init(tabName: "What about you", sampleImage: "person.fill"),
    .init(tabName: "Brazil", sampleImage: "gear")
]
