//
//  ODScrollViewAdjustor.swift
//  ODScrollViewApp
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2020 Orçun Deniz. All rights reserved.
//

import Foundation
import UIKit

final class ODScrollViewAdjustmentCalculator {
    
    static func isScrollViewAndKeyboardOverlapping(keyboardMinYGlobal: CGFloat,
                                                   scrollViewMaxYGlobal: CGFloat) -> Bool {
        return scrollViewMaxYGlobal > keyboardMinYGlobal
    }
    
    static func isAdjustmentEnable(inputViewMaxYGlobal: CGFloat? = nil, keyboardMinYGlobal: CGFloat? = nil, adjustmentOption: AdjustmentOption) -> Bool {
        switch adjustmentOption {
        case .Always:
            return true
        case .IfNeeded:
            guard let inputViewMaxYGlobal = inputViewMaxYGlobal, let keyboardMinYGlobal = keyboardMinYGlobal else {
                return false
            }

            return inputViewMaxYGlobal >= keyboardMinYGlobal ? true : false // Adjustment is enabled if the inputView stays under keyboard.
        }
    }
    
    static func isInputViewFitsRemainingArea(inputViewHeight: CGFloat,
                                             remainingAreaMinYGlobal: CGFloat,
                                             remainingAreaMaxYGlobal: CGFloat) -> Bool {
        return remainingAreaMaxYGlobal - remainingAreaMinYGlobal >= inputViewHeight
    }
    
    static func calculateContentOffset(adjustmentDirection: AdjustmentDirection,
                                       inputViewRectGlobal: CGRect,
                                       remainingAreaMinYGlobal: CGFloat,
                                       remainingAreaMaxYGlobal: CGFloat,
                                       keyboardTopMarginFromAdjustedView: CGFloat) -> CGFloat {
        
        if !ODScrollViewAdjustmentCalculator.isInputViewFitsRemainingArea(inputViewHeight: inputViewRectGlobal.height, remainingAreaMinYGlobal: remainingAreaMinYGlobal, remainingAreaMaxYGlobal: remainingAreaMaxYGlobal) {
            return 0
        }
        
        switch adjustmentDirection {
        case .Top:
            return inputViewRectGlobal.minY - remainingAreaMinYGlobal - keyboardTopMarginFromAdjustedView
        case .Center:
            let remainingAreaMidYGlobal = remainingAreaMinYGlobal + (remainingAreaMaxYGlobal - remainingAreaMinYGlobal) / 2
            return inputViewRectGlobal.midY - remainingAreaMidYGlobal
        case .Bottom:
            return inputViewRectGlobal.maxY - remainingAreaMaxYGlobal + keyboardTopMarginFromAdjustedView
        }
    }
    
    static func isTextInputCursorTrackingEnable(cursorMaxYGlobal: CGFloat,
                                                remainingAreaMaxYGlobal: CGFloat ) -> Bool {
        return cursorMaxYGlobal > remainingAreaMaxYGlobal
    }
}
