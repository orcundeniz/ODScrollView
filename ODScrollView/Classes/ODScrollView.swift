//
//  ODScrollView.swift
//  ODScrollViewApp
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2019 Orçun Deniz. All rights reserved.
//

// ODScrollView
import Foundation
import UIKit

public final class ODScrollView: UIScrollView, KeyboardObserver {
    
    private var scrollContentView: UIView?
    private var renderer: ODScrollViewRenderer?
    
    public weak var odScrollViewDelegate: ODScrollViewDelegate? {
        didSet {
            setupDelegateSettings()
            setupRenderer()
        }
    }

    /// ODScrollView's contentView have to be registered on ViewDidLoad()
    public func registerContentView(_ contentView: UIView) {
        scrollContentView = contentView
    }
    
    /// Keyboard States
    /// keyboardDidShow can be called while the keyboard is already open. isKeyboardHidden is needed to be aware of such cases.
    private var isKeyboardHidden: Bool = true
    
    func keyboardDidShow(with keyboardHeight: CGFloat) {
        
        odScrollViewDelegate?.keyboardDidShow(by: self)

        guard let contentView = scrollContentView else {
            assertionFailure("contentView is nil! You have to call ODScrollView.registerContentView")
            return
        }
        
        guard let renderer = renderer else { return }

        // Check whether firstResponder UITextInput object is inside scrollContentView or not.
        
        /// We have to add observer to default notification center with name UIResponder.keyboardDidShowNotification to detect keyboard opening. But this observer can be notified any keyboard
        /// opening not just UITextInput views inside ODScrollView. This is how keyboard notifications works. So we are checking that the notification is came from ODScrollView
        /// or not every time when observer is notified.
        if renderer.isFirstResponderInputViewExists(inside: contentView) {
          
            setupAdjustmentDirectionSetting()

            if ODScrollViewOptions.adjustmentEnabled {
                odScrollViewDelegate?.scrollAdjustmentWillBegin(by: self)
                
                renderer.adjust(keyboardHeight,
                                isKeyboardHidden,
                                ODScrollViewOptions.adjustmentDirection,
                                ODScrollViewOptions.adjustmentOption,
                                ODScrollViewOptions.adjustmentMargin)
                    
                odScrollViewDelegate?.scrollAdjustmentDidEnd(by: self)
            }
        }
        
        isKeyboardHidden = false
    }
    
    func keyboardDidHide() {
        resetAdjustedView()
        resetToInitialSettings()
        self.odScrollViewDelegate?.keyboardDidHide(by: self)
        
        isKeyboardHidden = true
    }
    
    /**
     Adjusts the ODScrollView when the cursor overlaps with keyboard while typing in multiline UITextInput. This method must be called by UITextInput functions that is fired while typing.
                
            func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                _ODScrollView.trackTextInputCursor(for textView)
                return true
            }

     ## IMPORTANT:
     This feature is not going to work unless textView is subView of _ODScrollView
     */
    public func trackTextInputCursor(for textInput: UITextInput) {
        renderer?.trackTextInputCursor(for: textInput)
    }
    
    deinit {
        removeKeyboardObservers()
    }
    // MARK: - Helpers
    
    private func resetAdjustedView() {
        if ODScrollViewOptions.hideKeyboardByTappingToView^!=? && ODScrollViewOptions.isResettingAdjustmentEnabled {
            renderer?.resetAdjustedView()
        }
    }
    
    private func resetToInitialSettings() {
        renderer?.resetToInitialSettings()
    }
    
    @objc func dismissKeyboard() {
        odScrollViewDelegate?.hideKeyboardByTappingToView(for: self)?.endEditing(true)
    }
    
    private func setupDelegateSettings() {
        
        guard let odScrollViewDelegate = odScrollViewDelegate else { return }

        ODScrollViewOptions.adjustmentOption = odScrollViewDelegate.adjustmentOption(for: self)
        ODScrollViewOptions.isResettingAdjustmentEnabled = odScrollViewDelegate.isResettingAdjustmentEnabled(for: self)
        ODScrollViewOptions.hideKeyboardByTappingToView = odScrollViewDelegate.hideKeyboardByTappingToView(for: self)
        if let hideKeyboardView = ODScrollViewOptions.hideKeyboardByTappingToView {
            let hideTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            hideKeyboardView.addGestureRecognizer(hideTapGesture)
        } else {
            assertionFailure("WARNING: UIView was not provided by hideKeyboardByTappingToView func of ODScrollViewDelegate. isResettingAdjustmentEnabled feature cannot be used.")
        }
        
        addKeyboardObservers()
    }
    
    private func setupRenderer() {
        self.renderer = ODScrollViewRenderer(self)
    }
    
    private func setupAdjustmentDirectionSetting() {
        guard
            let odScrollViewDelegate = odScrollViewDelegate,
            let currentTextInput = renderer?.firstResponderUITextInputView as? UITextInput
        else { return }

        ODScrollViewOptions.adjustmentDirection = odScrollViewDelegate.adjustmentDirection(for: currentTextInput, inside: self)
        ODScrollViewOptions.adjustmentMargin = odScrollViewDelegate.adjustmentMargin(for: currentTextInput, inside: self)
        ODScrollViewOptions.adjustmentEnabled = odScrollViewDelegate.adjustmentEnabled(for: currentTextInput, inside: self)
    }
}
