// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {
    var body: some View {
        Home(currentTab: 0, tabs: [
            .init(titleView: AnyView(HStack
                                     {
                                         Text("Iceland")
                                             .font(.system(size: 20))
                                     })
                  , contentView: AnyView(Text("Iceland Content"))),
            .init(titleView: AnyView(HStack
                                     {
                                         Text("What About You")
                                             .font(.system(size: 20))
                                         Image(systemName: "person.fill")
                                     }),
                  contentView: AnyView(Text("What about you Content"))),
            .init(titleView: AnyView(HStack
                                     {
                                         Image(systemName: "gear")
                                             .font(.system(size: 20))
                                     }),
                  contentView: AnyView(Text("Brazil Content"))),
        ])
    }
}

@available(iOS 14.0, *)
#Preview {
    ContentView()
}
