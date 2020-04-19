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
        scrollViewMaxYGlobal > keyboardMinYGlobal
    }
    
    static func isAdjustmentEnabled(inputViewMaxYGlobal: CGFloat? = nil,
                                    keyboardMinYGlobal: CGFloat? = nil,
                                    adjustmentOption: AdjustmentOption) -> Bool {

        switch adjustmentOption {
        case .always:
            return true
        case .ifNeeded:
            guard
                let inputViewMaxYGlobal = inputViewMaxYGlobal,
                let keyboardMinYGlobal = keyboardMinYGlobal
            else { return false }

            // Adjustment is enabled if the inputView stays under keyboard.
            return inputViewMaxYGlobal >= keyboardMinYGlobal
        }
    }
    
    static func isInputViewFitsRemainingArea(inputViewHeight: CGFloat,
                                             remainingAreaMinYGlobal: CGFloat,
                                             remainingAreaMaxYGlobal: CGFloat) -> Bool {
        remainingAreaMaxYGlobal - remainingAreaMinYGlobal >= inputViewHeight
    }
    
    static func calculateContentOffset(adjustmentDirection: AdjustmentDirection,
                                       inputViewRectGlobal: CGRect,
                                       remainingAreaMinYGlobal: CGFloat,
                                       remainingAreaMaxYGlobal: CGFloat,
                                       keyboardTopMarginFromAdjustedView: CGFloat) -> CGFloat {
        
        if !ODScrollViewAdjustmentCalculator.isInputViewFitsRemainingArea(inputViewHeight: inputViewRectGlobal.height,
                                                                          remainingAreaMinYGlobal: remainingAreaMinYGlobal,
                                                                          remainingAreaMaxYGlobal: remainingAreaMaxYGlobal) {
            return 0
        }
        
        switch adjustmentDirection {
        case .top:
            return inputViewRectGlobal.minY - remainingAreaMinYGlobal - keyboardTopMarginFromAdjustedView
        case .center:
            let remainingAreaMidYGlobal = remainingAreaMinYGlobal + (remainingAreaMaxYGlobal - remainingAreaMinYGlobal) / 2
            return inputViewRectGlobal.midY - remainingAreaMidYGlobal
        case .bottom:
            return inputViewRectGlobal.maxY - remainingAreaMaxYGlobal + keyboardTopMarginFromAdjustedView
        }
    }
    
    static func isTextInputCursorTrackingEnabled(cursorMaxYGlobal: CGFloat,
                                                 remainingAreaMaxYGlobal: CGFloat) -> Bool {
        cursorMaxYGlobal > remainingAreaMaxYGlobal
    }
}
