// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {
    
    var body: some View {
        Home(offset: 0, currentTab: 0, tabs: [
            .init(tabName: "Iceland", sampleImage: "house"),
            .init(tabName: "What about you", sampleImage: "person.fill"),
            .init(tabName: "Brazil", sampleImage: "gear"),
            .init(tabName: "Iceland", sampleImage: "house"),
            .init(tabName: "What about you", sampleImage: "person.fill"),
            .init(tabName: "Brazil", sampleImage: "gear")
        ])
    }
}

@available(iOS 14.0, *)
#Preview {
    ContentView()
}
