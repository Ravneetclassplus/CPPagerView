//
//  File.swift
//  
//
//  Created by Admin on 20/08/24.
//
import SwiftUI

@available(iOS 14.0, *)
struct ContentView1: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
            Text("Hello World")
        }
        
    }
}

@available(iOS 14.0, *)
public struct Home: View {
    @State private var offset: CGFloat = 0
    @State private var currentTab: Int = 0
    @State private var tabs: [Tab]
    @State private var progress: CGFloat = 0
    @State private var isTapped: Bool = false
    @State private var scrollPosition: String = .init()
    
    //Mark: - Gesture Manager
    @StateObject private var gestureManager: InteractionManager = .init()
    
    public init(offset: CGFloat, currentTab: Int, tabs: [Tab]) {
        self.offset = offset
        self.currentTab = currentTab
        self.tabs = tabs
    }
    
    public var body: some View {
        VStack {
            customTabBar(size: UIScreen.main.bounds)
            GeometryReader { proxy in
                let screenSize = proxy.size
                ZStack(alignment: .top) {
                    TabView(selection: $currentTab) {
                            ForEach(0..<tabs.endIndex, id: \.self) { index in
                                if index > -1 {
                                    GeometryReader { proxy in
                                        ContentView1()
                                            .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                                    }
                                    .ignoresSafeArea()
                                    .offsetX { value in
                                        if currentTab == index && !isTapped {
                                            offset = value.minX - (screenSize.width * CGFloat(indexOf(tab: tabs[index])))
                                            progress = -offset / value.width
                                        }
                                        
                                        if value.minX == 0 && isTapped {
                                            isTapped = false
                                        }
                                        
                                        //if user tries to scroll too fast When the offset don't reach to 0
                                        
                                        if isTapped && gestureManager.isInteracting {
                                            isTapped = false
                                        }
                                    }
                                    .tag(index)
                                }
                        }
                    }
                    .ignoresSafeArea()
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onAppear(perform: gestureManager.addGesture)
                    .onDisappear(perform: gestureManager.removeGesture)
                    .onChange(of: currentTab) { newTab in
                        withAnimation(.easeInOut) {
                            scrollPosition = tabs[newTab].id
                        }
                    }
                }
                .frame(width: screenSize.width, height: screenSize.height)
            }
        }
        
    }
    
    @ViewBuilder
    func customTabBar(size: CGRect) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollProxy in
                ZStack {
                    HStack(spacing: 30) {
                        ForEach($tabs) { $tab in
                            HStack {
                                Image(systemName: "gear")
                                Text(tab.tabName)
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        isTapped = true
                                        withAnimation(.easeInOut) {
                                            currentTab = indexOf(tab: tab)
                                            offset = (size.width) * CGFloat(indexOf(tab: tab))
                                            progress = offset / size.width
                                        }
                                    }
                            }
                            .offsetX { rect in
                                tab.size = rect.size
                                tab.minX = rect.minX
                            }
                        }
                    }
                }
                .onChange(of: scrollPosition) { newPosition in
                    withAnimation(.easeInOut) {
                        scrollProxy.scrollTo(newPosition, anchor: .center)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.gray)
                    .frame(height: 1)
                    .offset(y: 14)
                let inputRange = tabs.indices.compactMap { return CGFloat($0) }
                let outputRange = tabs.compactMap { return $0.size.width }
                let outputPositionRange = tabs.compactMap { return $0.minX }
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
                Capsule()
                    .fill()
                    .frame(width: indicatorWidth, height: 2)
                    .offset(x: indicatorPosition - 15, y: 14)
            }
            ,alignment: .bottomLeading
        )
        .padding(15)
    }
    
    func indexOf(tab: Tab) -> Int {
        let index = tabs.firstIndex { CTab in
            CTab == tab
        } ?? 0
        
        return index
    }
}

@available(iOS 14.0, *)
#Preview {
    ContentView()
}

//MARK: - Universal Interaction Manager
@available(iOS 14.0, *)
class InteractionManager: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    @Published var isInteracting: Bool = false
    @Published var isGestureAdded: Bool = false
    
    func addGesture() {
        if !isGestureAdded {
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(onChange(gesture: )))
            gesture.name = "UNIVERSAL"
            gesture.delegate = self
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let window = windowScene.windows.last?.rootViewController else { return }
            window.view.addGestureRecognizer(gesture)
            isGestureAdded = true
        }
    }
    
    func removeGesture() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = windowScene.windows.last?.rootViewController else { return }
        
        window.view.gestureRecognizers?.removeAll(where: { gesture in
            return gesture.name == "UNIVERSAL"
        })
        isGestureAdded = false
    }
     
    @objc
    func onChange(gesture: UIPanGestureRecognizer) {
        isInteracting = (gesture.state == .changed)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return true
    }
}
