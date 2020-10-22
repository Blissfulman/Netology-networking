//
//  FoundRepositoryTableViewCell.swift
//  GitHub
//
//  Created by User on 21.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit
import Kingfisher

class FoundRepositoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    /// Название репозитория
    private let repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Описание репозитория
    private let repositoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Логин хозяина репозитория
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Изображение аватара хозяина репозитория
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(repositoryNameLabel)
        addSubview(repositoryDescriptionLabel)
        addSubview(loginLabel)
        addSubview(avatarImageView)
    }
    
    // MARK: - Setup layout
    private func setupLayout() {
        let constraints = [
            repositoryNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            repositoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            repositoryNameLabel.trailingAnchor.constraint(equalTo: loginLabel.leadingAnchor,
                                                          constant: -30),
            
            loginLabel.topAnchor.constraint(equalTo: repositoryNameLabel.topAnchor),
            loginLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            loginLabel.bottomAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: -10),
            loginLabel.widthAnchor.constraint(equalToConstant: 70),

            repositoryDescriptionLabel.topAnchor.constraint(equalTo: repositoryNameLabel.bottomAnchor,
                                                            constant: 10),
            repositoryDescriptionLabel.leadingAnchor.constraint(equalTo: repositoryNameLabel.leadingAnchor),
            repositoryDescriptionLabel.trailingAnchor.constraint(equalTo: repositoryNameLabel.trailingAnchor),
            
            avatarImageView.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: loginLabel.trailingAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(repository: FoundRepositories.Repository) {
        
        setupUI()
        setupLayout()
        
        let url = URL(string: repository.owner.avatarURL)
                
        repositoryNameLabel.text = repository.name
        repositoryDescriptionLabel.text = repository.description
        loginLabel.text = repository.owner.login
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url)
    }
}
