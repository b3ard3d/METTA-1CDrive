//
//  AddContactPersonColdClientViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.01.2024.
//

import UIKit

final class AddContactPersonColdClientViewController: UIViewController {

    var selectedUUID: String?
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "ФИО:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите ФИО"
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
        view.addSubview(fullNameLabel)
        view.addSubview(fullNameTextField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Новое контактное лицо"
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonClicked))
        let closeButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [saveButton]
        //navigationItem.backButtonTitle = "Назад"
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fullNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            fullNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fullNameTextField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 5),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func saveRequestData(jsonArray: [String: String]) {
        let defaults = UserDefaults.standard
        defaults.set(jsonArray, forKey: "SavedJsonContactPersonColdClientData")
    }
    
    @objc func saveButtonClicked() {
        let fullNameContactPerson = fullNameTextField.text ?? ""
        
        if fullNameContactPerson.isEmpty {
            fullNameTextField.shake()
        } else {
            
            var json = [String: String]()
            json["uuid"] = selectedUUID ?? ""
            json["name"] = fullNameContactPerson
                        
            if json.count > 0 {
                saveRequestData(jsonArray: json)
                
                let alert = UIAlertController(title: "Новое контактное лицо сохранено", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil)
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
        fullNameTextField.resignFirstResponder()
    }
}
