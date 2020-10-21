//
//  FoundRepositoriesViewController.swift
//  GitHub
//
//  Created by User on 18.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit
import Kingfisher

class FoundRepositoriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var repositoriesUnit = RepositoriesUnit()
    
    // MARK: - Initializers
    convenience init(repositories: RepositoriesUnit) {
        self.init()

        repositoriesUnit = repositories
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.dataSource = self
        print(repositoriesUnit.repositories.count)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        let headerView = UIView()
        headerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        tableView.tableHeaderView = headerView
        
        let headerLabel = UILabel()
        headerView.addSubview(headerLabel)

        headerLabel.text = "Repositories found: \(repositoriesUnit.count)"
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
        repositoriesUnit.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let url = URL(string: repositoriesUnit.repositories[indexPath.row].owner.avatarURL)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(with: url)
        cell.textLabel?.text = repositoriesUnit.repositories[indexPath.row].name
        
        return cell
    }
}
