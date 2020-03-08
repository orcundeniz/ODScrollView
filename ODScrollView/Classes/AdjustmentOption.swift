//
//  AdjustmentOption.swift
//  ODScrollView
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2020 Orçun Deniz. All rights reserved.
//

import Foundation

public enum AdjustmentOption {
    
    /**
     ODScrollView always adjusts the UITextInput -firstResponder- which is placed anywhere in the ODScrollView.
     */
    case Always // Default
    
    /***
     ODScrollView only adjusts the UITextInput  -firstResponder- if it overlaps with the keyboard.
     */
    case IfNeeded
}
