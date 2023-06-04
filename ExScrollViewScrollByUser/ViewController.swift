//
//  ViewController.swift
//  ExScrollViewScrollByUser
//
//  Created by 김종권 on 2023/06/04.
//

import UIKit

class ViewController: UIViewController {
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("스크롤", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        view.allowsSelection = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.contentInset = .zero
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.estimatedRowHeight = 34
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let items = (1...50).map(String.init)
    var scrolledByUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: button.topAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12)
        ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor),
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func tapButton() {
        let offset = tableView.contentOffset
        tableView.setContentOffset(.init(x: offset.x, y: offset.y + 10), animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = items[indexPath.row]
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let prefix = scrolledByUser ? "byUser, " : "byCode, "
        print(scrolledByUser)
        label.text = prefix + "\(scrollView.contentOffset)"
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrolledByUser = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrolledByUser = false
    }
}
