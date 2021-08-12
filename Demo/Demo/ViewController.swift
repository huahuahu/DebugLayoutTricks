//
//  ViewController.swift
//  Demo
//
//  Created by tigerguo on 2021/8/12.
//

import UIKit

enum Scenario: String, CaseIterable {
    case basic
    case ambiguity
    case unsatisfiable
    case frameBase

    var targetVC: UIViewController.Type {
        switch self {
        case .basic:
            return BasicVC.self
        case .ambiguity:
            return AmbiguityVC.self
        case .unsatisfiable:
            return UnsatisfiableVC.self
        case .frameBase:
            return FramebaseVC.self
        }
    }
}

class ViewController: UIViewController {
    let tableView = UITableView()

    static let cellIdentifier = "cellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.cellIdentifier)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return Scenario.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier, for: indexPath)
        cell.textLabel?.text = Scenario.allCases[indexPath.row].rawValue
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scenario = Scenario.allCases[indexPath.row]
        let vc = scenario.targetVC.init()
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
