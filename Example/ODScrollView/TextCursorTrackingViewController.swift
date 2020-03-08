//
//  TextCursorTrackingViewController.swift
//  ODScrollView_Example
//
//  Created by Orçun Deniz on 7.03.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ODScrollView

class TextCursorTrackingViewController: UIViewController {

    @IBOutlet weak var ODScrollView: ODScrollView!
    @IBOutlet weak var ODScrollContentView: UIView!
    @IBOutlet weak var firstTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ODScrollView.registerContentView(ODScrollContentView)
        ODScrollView.odScrollViewDelegate = self
        ODScrollView.delegate = self
        
        // Additional setup for ODScrollView
        ODScrollView.keyboardDismissMode = .onDrag
        
        firstTextView.delegate = self

    }

}

extension TextCursorTrackingViewController: ODScrollViewDelegate {
    
    func keyboardDidShow(by scrollView: ODScrollView) {
    }
    
    func scrollAdjustmentWillBegin(by scrollView: ODScrollView) {
    }
    
    func scrollAdjustmentDidEnd(by scrollView: ODScrollView) {
        
    }
    
    func keyboardDidHide(by scrollView: ODScrollView) {
        
    }
    
    func adjustmentMargin(for textInput: UITextInput, inside scrollView: ODScrollView) -> CGFloat {
        20
    }
    
    func adjustmentEnabled(for textInput: UITextInput, inside scrollView: ODScrollView) -> Bool {
        true
    }
    
    func adjustmentDirection(for textInput: UITextInput, inside scrollView: ODScrollView) -> AdjustmentDirection {
        .Bottom
    }
    
    func adjustmentOption(for scrollView: ODScrollView) -> AdjustmentOption {
        .Always
    }
    
    func hideKeyboardByTappingToView(for scrollView: ODScrollView) -> UIView? {
        self.view
    }
    
    func isResettingAdjustmentEnabled(for scrollView: ODScrollView) -> Bool {
        true
    }
}

extension TextCursorTrackingViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
}

extension TextCursorTrackingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        ODScrollView.trackTextInputCursor(for: textView)
        return true
    }
}
