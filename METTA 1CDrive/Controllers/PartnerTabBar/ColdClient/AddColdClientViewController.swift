//
//  AddColdClientViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.01.2024.
//

import UIKit
import Network

final class AddColdClientViewController: UIViewController {
    
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    let networkManager = NetworkManager()
    let coreDataManager = CoreDataManager.shared
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Наименование:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите наименование"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupConstraint()
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Новый холодный клиент"
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonClicked))
        let closeButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [saveButton]
        //navigationItem.backButtonTitle = "Назад"
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func saveRequestData(_ jsonData: Data, nameColdClient: String) {
        let defaults = UserDefaults.standard
        defaults.set(jsonData, forKey: "SavedJsonColdClientData")
        defaults.set(nameColdClient, forKey: "SavedNameColdClient")
    }
    
    @objc func saveButtonClicked() {
        let nameColdClient = nameTextField.text ?? ""
        
        if nameColdClient.isEmpty {
            nameTextField.shake()
        } else {
            let json: [String: String] = [
                "name" : nameColdClient,
            ]
            
            if json.count > 0 {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else { return }
                
                saveRequestData(jsonData, nameColdClient: nameColdClient)
                
                let alert = UIAlertController(title: "Новый холодный клиент сохранен", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func closeButtonClicked() {
        let alert = UIAlertController(title: "Все не сохраненные данные будут потеряны, хотите закрыть?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tapKeyboardOff(_ sender: Any) {
        nameTextField.resignFirstResponder()
    }
}
