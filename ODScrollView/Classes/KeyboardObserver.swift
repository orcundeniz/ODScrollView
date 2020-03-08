//
//  KeyboardObserving.swift
//  ODScrollViewApp
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2019 Orçun Deniz. All rights reserved.
//
import UIKit

protocol KeyboardObserver: class {
    func keyboardDidShow(with keyboardHeight: CGFloat)
    func keyboardDidHide()
}
    
extension KeyboardObserver {
  
    func addKeyboardObservers() {

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardDidShowNotification,
            object: nil,
            queue: nil,
            using: { [weak self] notification in
                guard let self = self else {return}
                guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                    return
                }

                self.keyboardDidShow(with: keyboardFrame.height)
        })
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardDidHideNotification,
            object: nil,
            queue: nil,
            using: { [weak self] _ in
                self?.keyboardDidHide()
        })
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardDidHideNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
    }
}
