//
//  File.swift
//  
//
//  Created by Admin on 20/08/24.
//

import SwiftUI
@available(iOS 14.0, *)
extension View {
    @ViewBuilder func offsetX(completion: @escaping(CGRect) -> ())->some View {
        self.overlay(
            GeometryReader { proxy in
                let frame = proxy.frame(in: .global)
                Color.clear
                    .preference(key: RectKey.self, value: frame)
                    .onPreferenceChange(RectKey.self) { value in
                        completion(value)
                    }
            }
        )
    }
}

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

extension CGFloat {
    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
        guard inputRange.count == outputRange.count else {
            fatalError("Input and output ranges must have the same number of elements.")
        }

        let x = self
        let length = inputRange.count - 1

        if x <= inputRange[0] { return outputRange[0] }
        if x >= inputRange[length] { return outputRange[length] }

        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]

            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]

            if x <= x2 {
                return y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
            }
        }

        return outputRange[length]
    }
}

@available(iOS 14.0, *)
extension Color {
    
    var components: (r: Double, g: Double, b: Double, o: Double)? {
        let uiColor: UIColor
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        if self.description.contains("NamedColor") {
            let lowerBound = self.description.range(of: "name: \"")!.upperBound
            let upperBound = self.description.range(of: "\", bundle")!.lowerBound
            let assetsName = String(self.description[lowerBound..<upperBound])
            
            uiColor = UIColor(named: assetsName)!
        } else {
            uiColor = UIColor(self)
        }
        
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &o) else { return nil }
        return (Double(r), Double(g), Double(b), Double(o))
    }
    
    func interpolateTo(color: Color, fraction: Double) -> Color {
        let s = self.components!
        let t = color.components!
        
        let r: Double = s.r + (t.r - s.r) * fraction
        let g: Double = s.g + (t.g - s.g) * fraction
        let b: Double = s.b + (t.b - s.b) * fraction
        let o: Double = s.o + (t.o - s.o) * fraction
        
        return Color(red: r, green: g, blue: b, opacity: o)
    }
}
