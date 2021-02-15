//
//  FoundRepositoriesViewController.swift
//  GitHub
//
//  Created by Evgeny Novgorodov on 18.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit

final class FoundRepositoriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var foundRepositories: FoundRepositories!
    
    // MARK: - Initializers
    
    convenience init(_ foundRepositories: FoundRepositories) {
        self.init()
        self.foundRepositories = foundRepositories
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FoundRepositoryTableViewCell.self,
                           forCellReuseIdentifier: FoundRepositoryTableViewCell.identifier)
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        let headerView = UIView()
        headerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        tableView.tableHeaderView = headerView
        
        let headerLabel = UILabel()
        headerView.addSubview(headerLabel)

        headerLabel.text = "Repositories found: \(foundRepositories.count)"
        headerLabel.font = .boldSystemFont(ofSize: 20)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0)
        ])
    }
}

extension FoundRepositoriesTableViewController {
    
    // MARK: - Table view data sourse
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foundRepositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FoundRepositoryTableViewCell.identifier
        ) as! FoundRepositoryTableViewCell
        cell.configure(repository: foundRepositories
                        .repositories[indexPath.row])
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // MARK: - Navigation
        
        let backItem = UIBarButtonItem()
        backItem.title = "Found repositories"
        navigationItem.backBarButtonItem = backItem

        let webVC = WebViewController(url: foundRepositories
                                        .repositories[indexPath.row].url)
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}
