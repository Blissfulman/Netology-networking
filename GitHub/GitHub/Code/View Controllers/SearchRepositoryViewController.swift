//
//  HelloViewController.swift
//  GitHub
//
//  Created by User on 17.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit
import Kingfisher

final class SearchRepositoryViewController: UIViewController {

    // MARK: - Properties
    private var user: User!
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchRepositoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Search repository"
        label.font = .systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Изображение аватара пользователя
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var repositoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "repository name"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var languageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "language"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.returnKeyType = .search
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    /// Позволяет выбрать способ сортировки для поиска
    private lazy var sortingSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "ascended",
                                       at: 0,
                                       animated: false)
        segmentedControl.insertSegment(withTitle: "descended",
                                       at: 1,
                                       animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        let normalTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        segmentedControl.setTitleTextAttributes(normalTitleTextAttributes,
                                                for: .normal)
        let selectedTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(selectedTitleTextAttributes,
                                                for: .selected)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var startSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start search", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 26)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    // MARK: - Initializers
    convenience init(user: User) {
        self.init()
        self.user = user
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        startSearchButton.addTarget(self,
                                    action: #selector(startSearchButtonPressed),
                                    for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    // MARK: - Actions
    @objc func startSearchButtonPressed() {
        view.endEditing(true)
        searchRepositories()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(helloLabel)
        view.addSubview(avatarImageView)
        view.addSubview(searchRepositoryLabel)
        view.addSubview(repositoryNameTextField)
        view.addSubview(languageTextField)
        view.addSubview(sortingSegmentedControl)
        view.addSubview(startSearchButton)
        
        helloLabel.text = "Hello, \(user.login)!"
        
        let url = URL(string: user.avatarUrl)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url)
    }
    
    // MARK: - Setup layout
    private func setupLayout() {
        
        let constraints = [
            helloLabel.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                            constant: 40),
            helloLabel.centerXAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            avatarImageView.topAnchor
                .constraint(equalTo: helloLabel.bottomAnchor, constant: 30),
            avatarImageView.centerXAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor
                .constraint(equalTo: avatarImageView.widthAnchor),
            
            searchRepositoryLabel.topAnchor
                .constraint(
                equalTo: avatarImageView.bottomAnchor, constant: 50),
            searchRepositoryLabel.centerXAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            repositoryNameTextField.topAnchor
                .constraint(equalTo: searchRepositoryLabel.bottomAnchor,
                            constant: 20),
            repositoryNameTextField.centerXAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            repositoryNameTextField.widthAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                            multiplier: 0.7),
            
            languageTextField.topAnchor
                .constraint(equalTo: repositoryNameTextField.bottomAnchor,
                            constant: 20),
            languageTextField.centerXAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            languageTextField.widthAnchor
                .constraint(equalTo: repositoryNameTextField.widthAnchor),
            
            sortingSegmentedControl.topAnchor
                .constraint(equalTo: languageTextField.bottomAnchor,
                            constant: 20),
            sortingSegmentedControl.centerXAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            sortingSegmentedControl.widthAnchor
                .constraint(equalTo: repositoryNameTextField.widthAnchor),
            
            startSearchButton.topAnchor
                .constraint(equalTo: sortingSegmentedControl.bottomAnchor,
                            constant: 50),
            startSearchButton.centerXAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // Скрытие клавиатуры по тапу в свободное место вью
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    // MARK: - Private methods
    private func searchRepositories() {
        
        let name = repositoryNameTextField.text ?? ""
        let language = languageTextField.text ?? ""
        let order = sortingSegmentedControl.selectedSegmentIndex == 0
            ? "asc" : "desc"
                
        NetworkService().search(name: name, language: language, order: order) {
            [weak self] (foundRepositories) in
            
            guard let `self` = self else { return }
            
            // MARK: Navigation
            DispatchQueue.main.async {
                let backItem = UIBarButtonItem()
                backItem.title = "Search repository"
                self.navigationItem.backBarButtonItem = backItem
                
                let foundRepositoriesTVC =
                    FoundRepositoriesTableViewController(foundRepositories)
                self.navigationController?
                    .pushViewController(foundRepositoriesTVC, animated: true)
            }
        }
    }
}

// MARK: - TextFieldDelegate
extension SearchRepositoryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == repositoryNameTextField {
            languageTextField.becomeFirstResponder()
        } else {
            startSearchButtonPressed()
        }
        return true
    }
}
