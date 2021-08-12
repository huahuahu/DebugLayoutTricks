//
//  basic.swift
//  Demo
//
//  Created by tigerguo on 2021/8/12.
//

import Foundation
import UIKit

class BasicVC: UIViewController {
    let testView = DebugView()
    let clippedView = DebugView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configClippedView()
        configCenterView()
//        configOverlay()
        navigationItem.title = "Basic"
    }

    private func configOverlay() {
        let overlayView = UIView()
        view.addSubview(overlayView)
        overlayView.backgroundColor = .systemGreen.withAlphaComponent(0.3)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }

    private func configCenterView() {
        view.addSubview(testView)
        testView.accessibilityIdentifier = "testView"
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = .red
        let widthConstraint = testView.widthAnchor.constraint(equalToConstant: 200)
        widthConstraint.identifier = "width from spec"
        let heightConstraint = testView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.identifier = "width from spec"

        NSLayoutConstraint.activate([
            testView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            widthConstraint,
            heightConstraint,
        ])
    }

    private func configClippedView() {
        clippedView.backgroundColor = .yellow
        clippedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clippedView)
        NSLayoutConstraint.activate([
            clippedView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
            clippedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clippedView.heightAnchor.constraint(equalToConstant: 100),
            clippedView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}
