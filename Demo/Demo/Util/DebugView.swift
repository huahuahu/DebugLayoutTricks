//
//  DebugView.swift
//  Demo
//
//  Created by tigerguo on 2021/8/12.
//

import Foundation
import UIKit

class DebugView: UIView {
    override func layoutSubviews() {
//        print("\(#function)")
        super.layoutSubviews()
    }

    override func sizeToFit() {
        print("\(#function)")
        super.sizeToFit()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        print("\(#function)")
        return super.sizeThatFits(size)
    }

    override var intrinsicContentSize: CGSize {
        print("\(#function)")
        return super.intrinsicContentSize
    }

    override var frame: CGRect {
        get { super.frame }
        set {
            print("new frame is\(newValue)")
            super.frame = newValue
        }
    }
}
