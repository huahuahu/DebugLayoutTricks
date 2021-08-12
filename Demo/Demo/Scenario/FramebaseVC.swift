//
//  Framebase.swift
//  Demo
//
//  Created by tigerguo on 2021/8/12.
//

import UIKit

class FramebaseVC: UIViewController {
    let testView = DebugView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        testView.backgroundColor = .systemRed
        testView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        view.addSubview(testView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(animate))
    }

    @objc func animate() {
        UIView.animate(withDuration: 0.2) {
            self.testView.frame = CGRect(x: 100, y: 100, width: 200, height: 400)
        }
    }
}
