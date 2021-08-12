//
//  AmbiguityVC.swift
//  Demo
//
//  Created by tigerguo on 2021/8/12.
//

import Foundation
import UIKit

class AmbiguityVC: UIViewController {
    let testView = DebugView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.accessibilityIdentifier = "vcRootView"

        configCenterView()
        navigationItem.title = "AmbiguityVC"
    }

    private func configCenterView() {
        view.addSubview(testView)
        testView.accessibilityIdentifier = "testView"
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = .red
        let widthConstraint = testView.widthAnchor.constraint(equalToConstant: 200)
        widthConstraint.identifier = "width from spec"
        let heightConstraint = testView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.identifier = "heigh from spec"

        NSLayoutConstraint.activate([
            testView.centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: 10),
            testView.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: 200),
            testView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            widthConstraint,
            heightConstraint,
        ])
    }
}
