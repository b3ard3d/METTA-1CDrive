//
//  SettingsViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 18.12.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    lazy var serverAdress: String = ""
    
    private lazy var addressSettingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Сервер:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressSettingsTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите адрес сервера"
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
        
        let defaults = UserDefaults.standard
        serverAdress = defaults.string(forKey: "serverAdress") ?? ""
        print(serverAdress)
        if !serverAdress.isEmpty {
            addressSettingsTextField.text = loadServerAdress(serverAdress: serverAdress)
        }
                    
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItems = [saveButton]
        navigationItem.title = "Настройки"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        serverAdress = defaults.string(forKey: "serverAdress") ?? ""
        addressSettingsTextField.text = loadServerAdress(serverAdress: serverAdress)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(addressSettingsLabel)
        view.addSubview(addressSettingsTextField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func setupNavigationBar() {
        //navigationItem.backButtonTitle = "Назад"
        //navigationController?.navigationBar.tintColor = .systemGray
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            addressSettingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressSettingsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addressSettingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addressSettingsLabel.heightAnchor.constraint(equalToConstant: 40),
            
            addressSettingsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressSettingsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addressSettingsTextField.topAnchor.constraint(equalTo: addressSettingsLabel.bottomAnchor),
            addressSettingsTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func loadServerAdress(serverAdress: String) -> String {
        if !serverAdress.isEmpty {
            if serverAdress[serverAdress.index(before: serverAdress.endIndex)] == "/" {
                return String(serverAdress.dropLast())
            } else {
                return serverAdress
            }
        } else {
            return serverAdress
        }
    }
    
    @objc func tapKeyboardOff(_ sender: Any) {
        addressSettingsTextField.resignFirstResponder()
    }
    
    @objc func saveButtonClicked() {
        guard let adress = addressSettingsTextField.text else {return}
        
        if adress.isEmpty || adress == "" || adress == " " {
            addressSettingsTextField.shake()
            addressSettingsTextField.text = serverAdress
        } else {
            guard var serverAdress = addressSettingsTextField.text else { return }
            let defaults = UserDefaults.standard
            serverAdress = serverAdress.trimmingCharacters(in: .whitespacesAndNewlines)
            if serverAdress[serverAdress.index(before: serverAdress.endIndex)] == "/" {
                defaults.set(serverAdress, forKey: "serverAdress")
            } else {
                defaults.set(serverAdress + "/", forKey: "serverAdress")
            }
            
            print(defaults.string(forKey: "serverAdress") ?? "")
        }
        addressSettingsTextField.resignFirstResponder()
    }    
}
