//
//  ODScrollViewAdjustmentCalculatorTests.swift
//  ODScrollViewTests
//
//  Created by Orçun Deniz on 07.03.2020.
//  Copyright © 2020 Orçun Deniz. All rights reserved.
//

import Foundation
import XCTest
@testable import ODScrollView

class ODScrollViewAdjustmentCalculatorTests: XCTestCase {
    
    enum ODScrollViewAndKeyboardRelationSettingEnum {
        case overlapping
        case notOverlapping
    }
    
    enum InputViewFrameSettingEnum {
        case fit
        case notFit
    }
    
    struct ODScrollViewCalculatorSetting {
        private let UIScreenBounds: CGRect = UIScreen.main.bounds
        private let keyboardHeight: CGFloat = 200
        let keyboardTopMarginFromAdjustedView: CGFloat = 20
        
        var scrollViewMinYGlobal: CGFloat = CGFloat.zero
        var scrollViewMaxYGlobal: CGFloat = CGFloat.zero
        var keyboardMinYGlobal: CGFloat = CGFloat.zero
  
        var inputViewRectGlobal: CGRect = CGRect.zero
        
        init(position ODScrollViewAndKeyboardPositionSetting: ODScrollViewAndKeyboardRelationSettingEnum? = nil,
             inputFrame inputViewFrameSetting: InputViewFrameSettingEnum? = nil) {
            
            setupUIElements()
            switch (ODScrollViewAndKeyboardPositionSetting, inputViewFrameSetting) {
                
            case (.overlapping, nil):
                setupOverlapping()
                
            case (.notOverlapping, nil):
                setupNotOverlapping()
           
            case (nil, .fit):
                setupFit()
                
            case (nil, .notFit):
                setupNotFit()
                    
            case (.overlapping, .fit):
                setupOverlapping()
                setupFit()
                
            case (.overlapping, .notFit):
                setupOverlapping()
                setupNotFit()
                
            case (.notOverlapping, .fit):
                setupNotOverlapping()
                setupFit()
                
            case (.notOverlapping, .notFit):
                setupNotOverlapping()
                setupNotFit()
                
            default:
                assertionFailure("Something went wrong")
            }
        }
        
        private mutating func setupUIElements() { // Assuming full screen and overlapping
            scrollViewMinYGlobal = UIScreenBounds.minY
            setupOverlapping()
            keyboardMinYGlobal = UIScreenBounds.maxY - keyboardHeight
        }
        
        private mutating func setupOverlapping() {
            scrollViewMaxYGlobal = UIScreenBounds.maxY
        }
        
        private mutating func setupNotOverlapping() {
            scrollViewMaxYGlobal = keyboardMinYGlobal - 1
        }
        
        private mutating func setupFit() {
            let inputFittedHeight = scrollViewMaxYGlobal - scrollViewMinYGlobal - 1
            inputViewRectGlobal = CGRect(x: 0, y: 0, width: 100, height: inputFittedHeight)
        }
        
        
        private mutating func setupNotFit() { // Use cursorMaxYGlobal instead of inputViewMaxYGlobal
            let inputNotFittedHeight = scrollViewMaxYGlobal - scrollViewMinYGlobal + 1
            inputViewRectGlobal = CGRect(x: 0, y: 0, width: 100, height: inputNotFittedHeight)
        }
    }


    // MARK: - isScrollViewAndKeyboardOverlapping
    func testScrollViewAndKeyboardOverlapping() {
 
        let setting = ODScrollViewCalculatorSetting(position: .overlapping)
        
        let res = ODScrollViewAdjustmentCalculator.isScrollViewAndKeyboardOverlapping(keyboardMinYGlobal: setting.keyboardMinYGlobal,
                                                                                      scrollViewMaxYGlobal: setting.scrollViewMaxYGlobal)
        
        XCTAssertEqual(res, true)

    }

    func testScrollViewAndKeyboardNOTOverlapping() {
        
        let setting = ODScrollViewCalculatorSetting(position: .notOverlapping)
        
        let res = ODScrollViewAdjustmentCalculator.isScrollViewAndKeyboardOverlapping(keyboardMinYGlobal: setting.keyboardMinYGlobal,
                                                                                      scrollViewMaxYGlobal: setting.scrollViewMaxYGlobal)
        
        XCTAssertEqual(res, false)

    }
    
    // MARK: - isAdjustmentEnable
    func testIsAdjustmentEnableAlways() {
        
        let res = ODScrollViewAdjustmentCalculator.isAdjustmentEnabled(adjustmentOption: .always)
        
        XCTAssertEqual(res, true)
    }
    
    func testIsAdjustmentEnableIfNeededOverlappingAndFit() {
        
        var setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .fit)
        setting.inputViewRectGlobal = CGRect(x: 0, y: 0, width: 100, height: setting.keyboardMinYGlobal + 1)
        
        let res = ODScrollViewAdjustmentCalculator.isAdjustmentEnabled(inputViewMaxYGlobal: setting.inputViewRectGlobal.maxY,
                                                                       keyboardMinYGlobal: setting.keyboardMinYGlobal,
                                                                       adjustmentOption: .ifNeeded)
        
        XCTAssertEqual(res, true)
    }
    
    func testIsAdjustmentNOTEnableIfNeededOverlappingAndFit() {
        
        var setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .fit)
        setting.inputViewRectGlobal = CGRect(x: 0, y: 0, width: 100, height: setting.keyboardMinYGlobal - 1)
        
        let res = ODScrollViewAdjustmentCalculator.isAdjustmentEnabled(inputViewMaxYGlobal: setting.inputViewRectGlobal.maxY,
                                                                       keyboardMinYGlobal: setting.keyboardMinYGlobal,
                                                                       adjustmentOption: .ifNeeded)
        
        XCTAssertEqual(res, false)
    }

    func testIsAdjustmentEnableIfNeededOverlappingAndNotFit() {
        
        let setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .notFit)

        let res = ODScrollViewAdjustmentCalculator.isAdjustmentEnabled(inputViewMaxYGlobal: setting.inputViewRectGlobal.maxY,
                                                                       keyboardMinYGlobal: setting.keyboardMinYGlobal,
                                                                       adjustmentOption: .ifNeeded)
        
        XCTAssertEqual(res, true)
    }
    
    func testIsAdjustmentEnableIfNeededNOTOverlapping() {
        
        let setting = ODScrollViewCalculatorSetting(position: .notOverlapping)

        let res = ODScrollViewAdjustmentCalculator.isAdjustmentEnabled(inputViewMaxYGlobal: setting.inputViewRectGlobal.maxY,
                                                                       keyboardMinYGlobal: setting.keyboardMinYGlobal,
                                                                       adjustmentOption: .ifNeeded)
        
        XCTAssertEqual(res, false)
    }
    
    func testIsAdjustmentEnableIfNeededMissingParameter() {
                
        let res = ODScrollViewAdjustmentCalculator.isAdjustmentEnabled(adjustmentOption: .ifNeeded)
        
        XCTAssertEqual(res, false)
    }
    
    // MARK: - isInputViewFitsRemainingArea
    func testIsInputViewFitsRemainingArea() {
                
        let setting = ODScrollViewCalculatorSetting(inputFrame: .fit)

        let res = ODScrollViewAdjustmentCalculator.isInputViewFitsRemainingArea(inputViewHeight: setting.inputViewRectGlobal.height,
                                                                                remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                                remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal)
        
        XCTAssertEqual(res, true)
    }
    
    func testIsInputViewNOTFitsRemainingArea() {
                
        let setting = ODScrollViewCalculatorSetting(inputFrame: .notFit)

        let res = ODScrollViewAdjustmentCalculator.isInputViewFitsRemainingArea(inputViewHeight: setting.inputViewRectGlobal.height,
                                                                                remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                                remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal)
        
        XCTAssertEqual(res, false)
    }
    
    // MARK: - isTextInputCursorTrackingEnable
    func testIsTextInputCursorTrackingEnable() {

        let setting = ODScrollViewCalculatorSetting(inputFrame: .notFit)

        let cursorMaxYGlobal = setting.inputViewRectGlobal.maxY
        
        let res = ODScrollViewAdjustmentCalculator.isTextInputCursorTrackingEnabled(cursorMaxYGlobal: cursorMaxYGlobal,
                                                                                    remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal)
        
        XCTAssertEqual(res, true)
    }
    
    func testIsTextInputCursorTrackingNOTEnable() {

        let setting = ODScrollViewCalculatorSetting(inputFrame: .fit)
        let cursorMaxYGlobal = setting.inputViewRectGlobal.maxY

        let res = ODScrollViewAdjustmentCalculator.isTextInputCursorTrackingEnabled(cursorMaxYGlobal: cursorMaxYGlobal,
                                                                                    remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal)
        
        XCTAssertEqual(res, false)
    }
    
    // MARK: - calculateContentOffset
    // MARK: - calculateContentOffset - TOP
    func testCalculateContentOffsetTOPWhenOverlappingAndFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .fit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .top,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
                
        let correctResult = setting.inputViewRectGlobal.minY - setting.scrollViewMinYGlobal - setting.keyboardTopMarginFromAdjustedView
        XCTAssertEqual(res, correctResult)
    }
    
    func testCalculateContentOffsetTOPWhenOverlappingAndNOTFit() {
            
        let setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .notFit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .top,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
                
        XCTAssertEqual(res, 0)
    }
    
    func testCalculateContentOffsetTOPWhenNOTOverlappingAndFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .notOverlapping, inputFrame: .fit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .top,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
        
        let correctResult = setting.inputViewRectGlobal.minY - setting.scrollViewMinYGlobal - setting.keyboardTopMarginFromAdjustedView
        XCTAssertEqual(res, correctResult)
    }
    
    func testCalculateContentOffsetTOPWhenNOTOverlappingAndNOTFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .notOverlapping, inputFrame: .notFit)

         let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .top,
                                                                           inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                           remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                           remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                           keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
        XCTAssertEqual(res, 0)
    }
    
    // MARK: - calculateContentOffset - CENTER
    func testCalculateContentOffsetCENTERWhenOverlappingAndFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .fit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .center,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
        
        let remainingAreaMidYGlobal = setting.scrollViewMinYGlobal + (setting.scrollViewMaxYGlobal - setting.scrollViewMinYGlobal) / 2
        
        let correctResult = setting.inputViewRectGlobal.midY - remainingAreaMidYGlobal
        XCTAssertEqual(res, correctResult)
    }
    
    func testCalculateContentOffsetCENTERWhenOverlappingAndNOTFit() {
            
        let setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .notFit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .center,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
        
        XCTAssertEqual(res, 0)
    }
    
    func testCalculateContentOffsetCENTERWhenNOTOverlappingAndFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .notOverlapping, inputFrame: .fit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .center,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
        
        let remainingAreaMidYGlobal = setting.scrollViewMinYGlobal + (setting.scrollViewMaxYGlobal - setting.scrollViewMinYGlobal) / 2
        let correctResult = setting.inputViewRectGlobal.midY - remainingAreaMidYGlobal
        XCTAssertEqual(res, correctResult)
    }
    
    func testCalculateContentOffsetCENTERWhenNOTOverlappingAndNotFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .notOverlapping, inputFrame: .notFit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .top,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
        
        XCTAssertEqual(res, 0)
    }
    
    // MARK: - calculateContentOffset - BOTTOM
    func testCalculateContentOffsetBOTTOMWhenOverlappingAndFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .fit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .bottom,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
        
        let correctResult = setting.inputViewRectGlobal.maxY - setting.scrollViewMaxYGlobal + setting.keyboardTopMarginFromAdjustedView
        XCTAssertEqual(res, correctResult)
    }
    
    func testCalculateContentOffsetBOTTOMWhenOverlappingAndNOTFit() {
            
        let setting = ODScrollViewCalculatorSetting(position: .overlapping, inputFrame: .notFit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .bottom,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
                
        XCTAssertEqual(res, 0)
    }
    
    func testCalculateContentOffsetBOTTOMWhenNOTOverlappingAndFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .notOverlapping, inputFrame: .fit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .bottom,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
        
        let correctResult = setting.inputViewRectGlobal.maxY - setting.scrollViewMaxYGlobal + setting.keyboardTopMarginFromAdjustedView
        XCTAssertEqual(res, correctResult)
    }
    
    func testCalculateContentOffsetBOTTOMWhenNOTOverlappingAndNotFit() {
                
        let setting = ODScrollViewCalculatorSetting(position: .notOverlapping, inputFrame: .notFit)

        let res = ODScrollViewAdjustmentCalculator.calculateContentOffset(adjustmentDirection: .top,
                                                                          inputViewRectGlobal: setting.inputViewRectGlobal,
                                                                          remainingAreaMinYGlobal: setting.scrollViewMinYGlobal,
                                                                          remainingAreaMaxYGlobal: setting.scrollViewMaxYGlobal,
                                                                          keyboardTopMarginFromAdjustedView: setting.keyboardTopMarginFromAdjustedView)
                
        XCTAssertEqual(res, 0)
    }
}
