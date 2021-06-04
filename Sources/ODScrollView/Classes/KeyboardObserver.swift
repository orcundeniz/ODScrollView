//
//  KeyboardObserving.swift
//  ODScrollViewApp
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2019 Orçun Deniz. All rights reserved.
//
import UIKit

protocol KeyboardObserver: AnyObject {
    func keyboardDidShow(with keyboardHeight: CGFloat)
    func keyboardDidHide()
}
    
extension KeyboardObserver {
  
    func addKeyboardObservers() {
        NotificationCenter.addObserver(with: UIResponder.keyboardDidShowNotification) { [weak self] notification in
            guard
                let self = self,
                let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
            self.keyboardDidShow(with: keyboardFrame.height)
        }

        NotificationCenter.addObserver(with: UIResponder.keyboardDidHideNotification) { [weak self] _ in
            self?.keyboardDidHide()
        }
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.removeObserver(with: UIResponder.keyboardDidHideNotification, observer: self)
        NotificationCenter.removeObserver(with: UIResponder.keyboardDidShowNotification, observer: self)
    }
}
        
private extension NotificationCenter {
    static func addObserver(with notificationName: NSNotification.Name, using block: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(
            forName: notificationName,
            object: nil,
            queue: nil,
            using: block)
    }

    static func removeObserver(with notificationName: NSNotification.Name, observer: KeyboardObserver) {
        NotificationCenter.default.removeObserver(
            observer,
            name: notificationName,
            object: nil)
    }
}
