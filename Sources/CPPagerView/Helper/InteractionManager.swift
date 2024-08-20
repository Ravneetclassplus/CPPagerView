//
//  File.swift
//  
//
//  Created by Admin on 20/08/24.
//

import SwiftUI
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
