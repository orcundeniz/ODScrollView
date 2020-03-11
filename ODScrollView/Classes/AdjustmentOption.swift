//
//  AdjustmentOption.swift
//  ODScrollView
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2020 Orçun Deniz. All rights reserved.
//

import Foundation

/// Default value is `.always`
public enum AdjustmentOption {

    /// ODScrollView always adjusts the UITextInput -firstResponder- which is placed anywhere in the ODScrollView.
    case always

    /// ODScrollView only adjusts the UITextInput  -firstResponder- if it overlaps with the keyboard.
    case ifNeeded
}
