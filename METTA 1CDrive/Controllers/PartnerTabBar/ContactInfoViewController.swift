//
//  ContactInfoViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 03.02.2024.
//

import UIKit

final class ContactInfoViewController: UIViewController {
    
    var selectedKind, selectedPresentation: String?
    
    private lazy var kindAndPresentationTextView: UITextView = {
        let textView = UITextView()
        if let text = selectedKind {
            textView.text = text + ": "
        }
        if let text = selectedPresentation {
            textView.text = (textView.text ?? "") + text
        }
        textView.font = .systemFont(ofSize: 16)
        textView.dataDetectorTypes = .all
        textView.textAlignment = .justified
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTabBar()
        setupConstraint()
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(kindAndPresentationTextView)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            kindAndPresentationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            kindAndPresentationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            kindAndPresentationTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            kindAndPresentationTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func tapAction() {
        if selectedKind == "Телефон" || selectedKind == "Телефон клиента" {
            UIApplication.shared.open(URL(string: "tel://\(selectedPresentation ?? "")")!)
        }
    }
}
