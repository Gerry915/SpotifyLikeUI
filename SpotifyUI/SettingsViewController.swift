//
//  SettingsViewController.swift
//  SpotifyUI
//
//  Created by Gerry Gao on 11/5/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let sample: [String] = [
        "Account",
        "Data Saver",
        "Languages",
        "Playback",
        "Explicit Content",
        "Devices",
        "Car",
        "Social",
        "Voice Assistants & Apps",
        "Audio Quality",
        "Video Quality",
        "Storage",
        "Notifications",
        "Advertisements",
        "Local Files",
        "About"
    ]
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reusableIdentifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigation()
        configureTableView()
    }
    
    private func setupView() {
        view.backgroundColor = .spotifyBlack
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigation() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .spotifyBlack
//        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear

        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    @objc func test() {
        
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reusableIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.systemBackground
        cell.selectedBackgroundView = selectedView
        
        var content = cell.defaultContentConfiguration()
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        content.attributedText = NSAttributedString(string: sample[indexPath.row], attributes: attributes)
        
        cell.contentConfiguration = content
        
        return cell
    }
}
