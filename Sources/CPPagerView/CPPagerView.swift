// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {
    var body: some View {
        Home(offset: 0, currentTab: 0, tabs: [
            .init(tabName: "Iceland", titleImage: nil, contentView: AnyView(ContentView1())),
            .init(tabName: "What about you", titleImage: Image(systemName: "person.fill"), contentView: AnyView(Text("Iceland Content"))),
            .init(tabName: "Brazil", titleImage: Image(systemName: "gear"), contentView: AnyView(Text("Iceland Content"))),
            .init(tabName: "England", titleImage: Image(systemName: "house.fill"), contentView: AnyView(Text("Iceland Content"))),
        ])
    }
}

@available(iOS 14.0, *)
#Preview {
    ContentView()
}
