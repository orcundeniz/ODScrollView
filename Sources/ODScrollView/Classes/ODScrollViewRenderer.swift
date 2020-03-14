//
//  ODScrollViewRenderer.swift
//  ODScrollViewApp
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2020 Orçun Deniz. All rights reserved.
//

import Foundation
import UIKit

final class ODScrollViewRenderer {

    /// It's using for resetting the adjusted view.
    private var beforeAdjustmentContentOffsetY: CGFloat = 0
    private var keyboardHeight: CGFloat = 0

    private weak var scrollView: ODScrollView?
   
    public var firstResponderUITextInputView: UIView?
    
    init(_ scrollView: ODScrollView) {
        self.scrollView = scrollView
    }
    
    func isFirstResponderInputViewExists(inside contentView: UIView) -> Bool {

        clearFirstResponder()
        
        setFirstResponderView(view: contentView)

        return firstResponderUITextInputView^!=?
    }
    
    func adjust(_ keyboardHeight: CGFloat,
                _ isKeyboardHidden: Bool,
                _ adjustmentDirection: AdjustmentDirection,
                _ adjustmentOption: AdjustmentOption,
                _ adjustmentMargin: CGFloat) {
        
        self.keyboardHeight = keyboardHeight
        // Global = coordinate at UIScreen frame
        
        // Prepare variables

        guard
            let scrollView = scrollView,
            let scrollViewMinYGlobal = scrollView.superview?.convert(scrollView.frame, to: nil).minY
        else { return }

        if isKeyboardHidden { // You can set another UITextInputs as firstResponder without hiding keyboard. This lets you to reset its very first position
            beforeAdjustmentContentOffsetY = scrollView.contentOffset.y // store it to reset
        }
        
        var totalContentOffset = scrollView.contentOffset.y

        let scrollViewMaxYGlobal = scrollViewMinYGlobal + scrollView.frame.height
        let keyboardMinYGlobal = UIScreen.main.bounds.height - keyboardHeight
        let isScrollViewAndKeyboardOverlapping = ODScrollViewAdjustmentCalculator.isScrollViewAndKeyboardOverlapping(keyboardMinYGlobal: keyboardMinYGlobal, scrollViewMaxYGlobal: scrollViewMaxYGlobal)
        let remainingAreaMaxYGlobal = isScrollViewAndKeyboardOverlapping ? keyboardMinYGlobal : scrollViewMaxYGlobal
        
        DispatchQueue.main.async { [weak self] in
            guard
                let self = self,
                let firstResponderUITextInputView = self.firstResponderUITextInputView
            else { return }
            
            // Do some math and adjust
            
            if ODScrollViewAdjustmentCalculator.isInputViewFitsRemainingArea(inputViewHeight: firstResponderUITextInputView.frame.height,
                                                                             remainingAreaMinYGlobal: scrollViewMinYGlobal,
                                                                             remainingAreaMaxYGlobal: remainingAreaMaxYGlobal) {
                // If UITextInput fits the remaining area,
                
                guard let inputViewRectGlobal = firstResponderUITextInputView.superview?.convert(firstResponderUITextInputView.frame, to: nil) else { return }
                
                if ODScrollViewAdjustmentCalculator.isAdjustmentEnabled(inputViewMaxYGlobal: inputViewRectGlobal.maxY, keyboardMinYGlobal: keyboardMinYGlobal, adjustmentOption: adjustmentOption) {
                    
                    totalContentOffset += ODScrollViewAdjustmentCalculator.calculateContentOffset(
                        adjustmentDirection: adjustmentDirection,
                        inputViewRectGlobal: inputViewRectGlobal,
                        remainingAreaMinYGlobal: scrollViewMinYGlobal,
                        remainingAreaMaxYGlobal: remainingAreaMaxYGlobal,
                        keyboardTopMarginFromAdjustedView: adjustmentMargin
                    )
                    
                    self.adjustView(to: totalContentOffset)
                }
            } else { // If UITextInput does not fits the remaining area, adjust with cursor position
                
                if let currentTextInput = self.firstResponderUITextInputView as? UITextInput,
                    let selectedTextRange = currentTextInput.selectedTextRange {
                    
                    let cursor = currentTextInput.caretRect(for: selectedTextRange.start)

                    /// firstResponderUITextInputView is superView of cursor.
                    let cursorRectGlobal = firstResponderUITextInputView.convert(cursor, to: nil)
                    
                    if ODScrollViewAdjustmentCalculator.isAdjustmentEnabled(inputViewMaxYGlobal: cursorRectGlobal.maxY,
                                                                            keyboardMinYGlobal: keyboardMinYGlobal,
                                                                            adjustmentOption: adjustmentOption) {
                         
                        totalContentOffset += ODScrollViewAdjustmentCalculator.calculateContentOffset(
                            adjustmentDirection: adjustmentDirection,
                            inputViewRectGlobal: cursorRectGlobal,
                            remainingAreaMinYGlobal: scrollViewMinYGlobal,
                            remainingAreaMaxYGlobal: remainingAreaMaxYGlobal,
                            keyboardTopMarginFromAdjustedView: adjustmentMargin
                        )
                        
                        self.adjustView(to: totalContentOffset)
                    }
                }
            }
        }
    }
    
    func trackTextInputCursor(for textInput: UITextInput) {
        DispatchQueue.main.async { [weak self] in
            guard
                let self = self,
                let firstResponderUITextInputView = self.firstResponderUITextInputView,
                let firstResponderUITextInput = self.firstResponderUITextInputView as? UITextInput,
                let scrollView = self.scrollView
            else { return }

            if firstResponderUITextInput.isEqual(textInput) {
                if let selectedTextRange = firstResponderUITextInput.selectedTextRange {
                    
                    let cursor = firstResponderUITextInput.caretRect(for: selectedTextRange.start)

                    /// firstResponderUITextInputView is superView of cursor.
                    let cursorRectGlobal = firstResponderUITextInputView.convert(cursor, to: nil)
                    
                    guard let scrollViewMinYGlobal = scrollView.superview?.convert(scrollView.frame, to: nil).minY else { return }
                    let scrollViewMaxYGlobal = scrollViewMinYGlobal + scrollView.frame.height
                    let keyboardMinYGlobal = UIScreen.main.bounds.height - self.keyboardHeight
                    let isScrollViewAndKeyboardOverlapping = ODScrollViewAdjustmentCalculator.isScrollViewAndKeyboardOverlapping(keyboardMinYGlobal: keyboardMinYGlobal,
                                                                                                                                 scrollViewMaxYGlobal: scrollViewMaxYGlobal)
                    let remainingAreaMaxYGlobal = isScrollViewAndKeyboardOverlapping ? keyboardMinYGlobal : scrollViewMaxYGlobal

                    
                    if ODScrollViewAdjustmentCalculator.isTextInputCursorTrackingEnabled(cursorMaxYGlobal: cursorRectGlobal.maxY,
                                                                                         remainingAreaMaxYGlobal: remainingAreaMaxYGlobal) {
                        
                        var totalContentOffset = scrollView.contentOffset.y

                        totalContentOffset += cursor.height
                               
                        self.adjustView(to: totalContentOffset)
                    }
                }
            }
        }
    }
    
    func resetAdjustedView() {
        self.adjustView(to: beforeAdjustmentContentOffsetY)
    }
    
    func resetToInitialSettings() {
        beforeAdjustmentContentOffsetY = 0
        keyboardHeight = 0
        clearFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func clearFirstResponder() {
        firstResponderUITextInputView = nil
    }
    
    private func adjustView(to offset: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard
                let self = self,
                let scrollView = self.scrollView
            else { return }
            
            scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
    
    private func setFirstResponderView(view: UIView) {
        for subView in view.subviews where !(firstResponderUITextInputView^!=?) {
            if subView is UITextInput, subView.isFirstResponder {
                firstResponderUITextInputView = subView
            } else {
                setFirstResponderView(view: subView)
            }
        }
    }
}
