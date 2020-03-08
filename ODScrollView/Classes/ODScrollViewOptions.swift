//
//  ODScrollViewOptions.swift
//  ODScrollView
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2020 Orçun Deniz. All rights reserved.
//

import Foundation
import UIKit

struct ODScrollViewOptions {
    static var adjustmentMargin: CGFloat = 0
    static var adjustmentEnabled: Bool = true
    static var adjustmentOption: AdjustmentOption = .Always
    static var adjustmentDirection: AdjustmentDirection = .Bottom
    static var hideKeyboardByTappingToView: UIView?
    static var isResettingAdjustmentEnabled: Bool = false
}
