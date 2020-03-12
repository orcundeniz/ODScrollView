//
//  ODScrollViewDelegate.swift
//  ODScrollViewApp
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2020 Orçun Deniz. All rights reserved.
//

import UIKit

public protocol ODScrollViewDelegate: AnyObject {
    
    // MARK:- State Notifiers

    ///
    /// Notifies when the keyboard showed.
    ///
    /// - Parameter scrollView: The scroll-view object that is about to scroll the content view.
    func keyboardDidShow(by scrollView: ODScrollView)

    ///
    /// Notifies before the UIScrollView adjustment.
    ///
    /// - Parameter scrollView: The scroll-view object that is about to scroll the content view.
    func scrollAdjustmentWillBegin(by scrollView: ODScrollView)
    
    ///
    /// Notifies after the UIScrollView adjustment.
    ///
    /// - Parameter scrollView: The scroll-view object that is about to scroll the content view.
    func scrollAdjustmentDidEnd(by scrollView: ODScrollView)

    ///
    /// Notifies when the keyboard hid.
    ///
    /// - Parameter scrollView: The scroll-view object that is about to scroll the content view.
    func keyboardDidHide(by scrollView: ODScrollView)
    
    
    // MARK:- Adjustment Settings

    ///
    /// Specifies the margin between UITextInput and ODScrollView's top or bottom constraint depending on AdjustmentDirection
    ///
    /// ```
    ///     if let textField = textInput as? UITextField, textField == self.UITextField_inside_contentView {
    ///         return 20
    ///     } else {
    ///         return 40
    ///     }
    /// ```
    /// - Parameters:
    ///   - textInput: The UITextInput that is about to adjust.
    ///   - scrollView: The scroll-view object that is about to scroll the content view.
    /// - Returns: *CGFloat* margin between UITextInput and ODScrollView's top or bottom constraint depending on AdjustmentDirection. Default is 20.
    func adjustmentMargin(for textInput: UITextInput, inside scrollView: ODScrollView) -> CGFloat


    ///
    /// Specifies adjustment direction for each UITextInput. It means that  some of UITextInputs inside ODScrollView can be adjusted to the bottom, while others can be adjusted to center or top.
    ///
    /// ```
    ///     if let textView = textInput as? UITextView, textView == self.YOURTEXTVIEW {
    ///         return .Bottom
    ///     } else {
    ///         return .Center
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - textInput: The UITextInput that is about to adjust.
    ///   - scrollView: The scroll-view object that is about to scroll the content view.
    /// - Returns: *AdjustmentDirection.* Default is .bottom
    func adjustmentDirection(for textInput: UITextInput, inside scrollView: ODScrollView) -> AdjustmentDirection

    ///
    /// Specifies that whether adjustment is enabled or not for each UITextInput seperately.
    ///
    /// - Parameters:
    ///   - textInput: The UITextInput that is about to adjust.
    ///   - scrollView: The scroll-view object that is about to scroll the content view.
    /// - Returns: *true* if adjustment is enabled for UITextInput; *false*  if adjustment is disabled for UITextInputs. Default is *true* for all UITextInputs.
    func adjustmentEnabled(for textInput: UITextInput, inside scrollView: ODScrollView) -> Bool

    ///
    /// There 2 types of adjustment option: Always and IfNeeded
    ///
    /// - always : ODScrollView always adjusts the UITextInput which is placed anywhere in the ODScrollView.
    /// - ifNeeded : ODScrollView only adjusts the UITextInput if it overlaps with the shown keyboard.
    ///
    /// - Parameter scrollView: The scroll-view object that is about to scroll the content view.
    /// - Returns: *AdjustmentOption.* Default is .always
    func adjustmentOption(for scrollView: ODScrollView) -> AdjustmentOption


    // MARK: - Hiding Keyboard Settings

    ///
    /// Provides a view for tap gesture that hides keyboard.
    ///
    /// By default, keyboard can be dismissed by keyboardDismissMode of UIScrollView.
    ///
    ///```
    ///    keyboardDismissMode = .none
    ///    keyboardDismissMode = .onDrag
    ///    keyboardDismissMode = .interactive
    ///```
    /// Beside above settings:
    ///

    ///
    /// - Parameter scrollView: The scroll-view object that is about to scroll the content view.
    /// - Returns: *UIView* from this, lets you to hide the keyboard by tapping the UIView you provide, and also be able to use isResettingAdjustmentEnabled(for scrollView: ODScrollView) setting.  If you return nil instead of UIView object, It means that hiding the keyboard by tapping is disabled. Default is nil
    func hideKeyboardByTappingToView(for scrollView: ODScrollView) -> UIView?

    ///
    /// Resets the scroll view offset - which is adjusted before - to beginning its position after keyboard hid by tapping to the provided UIView via hideKeyboardByTappingToView.
    ///
    /// ## IMPORTANT:
    /// This feature requires a UIView that is provided by hideKeyboardByTappingToView().
    /// 
    /// - Parameter scrollView: The scroll-view object that is about to scroll the content view.
    /// - Returns: *true* to enable resetting; *false* to disable resetting. Default is false.
    func isResettingAdjustmentEnabled(for scrollView: ODScrollView) -> Bool
    
}

public extension ODScrollViewDelegate {
    func keyboardDidShow(by scrollView: ODScrollView) {}
    func scrollAdjustmentWillBegin(by scrollView: ODScrollView) {}
    func scrollAdjustmentDidEnd(by scrollView: ODScrollView) {}
    func keyboardDidHide(by scrollView: ODScrollView) {}
    
    func adjustmentMargin(for textInput: UITextInput, inside scrollView: ODScrollView) -> CGFloat { 20 }
    func adjustmentDirection(for textInput: UITextInput, inside scrollView: ODScrollView) -> AdjustmentDirection{ .bottom }
    func adjustmentEnabled(for textInput: UITextInput, inside scrollView: ODScrollView) -> Bool { true }
    func adjustmentOption(for scrollView: ODScrollView) -> AdjustmentOption { .always }

    func hideKeyboardByTappingToView(for scrollView: ODScrollView) -> UIView? { nil }
    func isResettingAdjustmentEnabled(for scrollView: ODScrollView) -> Bool { false }
    
}
