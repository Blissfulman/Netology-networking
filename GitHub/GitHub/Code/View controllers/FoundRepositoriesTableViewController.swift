//
//  FoundRepositoriesViewController.swift
//  GitHub
//
//  Created by User on 18.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit

class FoundRepositoriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var foundRepositories = FoundRepositories()
    
    // MARK: - Initializers
    convenience init(repositories: FoundRepositories) {
        self.init()
        foundRepositories = repositories
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableView.dataSource = self
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
        
        let constraints = [
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


extension FoundRepositoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foundRepositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FoundRepositoryTableViewCell()
        cell.configure(repository: foundRepositories.repositories[indexPath.row])
        return cell
    }
}
