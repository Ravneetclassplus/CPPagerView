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
        Text("hello")
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
    @State private var selectedColor: Color = .primary
    @State private var unselectedColor: Color = .gray
    @State private var indicatorHeight: CGFloat = 2
    @State private var indicatorColor: Color = .primary
    
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
                        if tabs.count > 1 {
                            ForEach(0..<tabs.endIndex, id: \.self) { index in
                                    GeometryReader { proxy in
                                        tabs[index].contentView
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
                        if tabs.count > 1 {
                            ForEach($tabs) { $tab in
                                HStack {
                                    tab.titleImage
                                    Text(tab.tabName)
                                        .font(.system(size: 20))
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
                                .foregroundColor(
                                    currentTab == indexOf(tab: tab) ? selectedColor : unselectedColor
                                )
                                .offsetX { rect in
                                    tab.size = rect.size
                                    tab.minX = rect.minX
                                }
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
                    .fill(indicatorColor)
                    .frame(width: indicatorWidth, height: indicatorHeight)
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

@available(iOS 14.0, *)
extension Home {
    public func setTitleColors(selected: Color, unselected: Color) -> Home {
        var copy = self
        copy._selectedColor = State(initialValue: selected)
        copy._unselectedColor = State(initialValue: unselected)
        return copy
    }
    
    public func setIndicatorHeight(to height: CGFloat) -> Home {
        var copy = self
        copy._indicatorHeight = State(initialValue: height)
        return copy
    }
    
    public func setIndicatorColor(to color: Color) -> Home {
        var copy = self
        copy._indicatorColor = State(initialValue: color)
        return copy
    }
}
