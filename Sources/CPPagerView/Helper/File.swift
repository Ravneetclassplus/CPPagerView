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