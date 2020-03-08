//
//  Optional+Extensions.swift
//  ODScrollViewApp
//
//  Created by Orçun Deniz on 10.01.2020.
//  Copyright © 2020 Orçun Deniz. All rights reserved.
//

import Foundation

/**
Operator for Optionals.
Checks whether the given optional's unwrapped value is nil or not.  If the value is nil, then returns false.

    var testStr: Strings? = "NOT NIL"
    testStr^!=? // returns true
*/
postfix operator ^!=?
extension Optional {

    static postfix func ^!=?(_ optional: Optional) -> Bool {
        return (optional == nil) ? false : true
    }
}
