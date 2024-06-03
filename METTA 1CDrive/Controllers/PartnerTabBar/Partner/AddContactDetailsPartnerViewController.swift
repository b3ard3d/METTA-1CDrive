//
//  AddContactDetailsPartnerViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 22.04.2024.
//

import UIKit

final class AddContactDetailsPartnerViewController: UIViewController {
    
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    let networkManager = NetworkManager()
    let coreDataManager = CoreDataManager.shared
    
    var selectedUUID: String?
    
    private lazy var telLabel: UILabel = {
        let label = UILabel()
        label.text = "Телефон:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var telTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите телефон"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите email"
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
        view.addSubview(telLabel)
        view.addSubview(telTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
                        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Новая контактная информация"
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonClicked))
        let closeButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    func setupConstraint() {
        
        NSLayoutConstraint.activate([
            telLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            telLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            telLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            telTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            telTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            telTextField.topAnchor.constraint(equalTo: telLabel.bottomAnchor, constant: 5),
            telTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailLabel.topAnchor.constraint(equalTo: telTextField.bottomAnchor, constant: 10),
            
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func validEmail(email: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let validEmail = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return validEmail.evaluate(with: email)
    }
    
    private func formatNumberPhone(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
    }
    
    func saveRequestData(jsonArray: [[String: String]]) {
        let defaults = UserDefaults.standard
        defaults.set(jsonArray, forKey: "SavedJsonContactDetailsPartnerData")
    }
    
/*    func sendSavedRequestData() {
        let defaults = UserDefaults.standard
        
        if let jsonArray = defaults.dictionary(forKey: "SavedJsonContactDetailsPartnerData") {
            for json in jsonArray {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else { return }
                
                networkManager.postCreateContactDetailsPartners(jsonData: jsonData ) { statusCode in
                    
                    DispatchQueue.main.async {
                        if statusCode == "200" {
                            let contactDetailsPartner = ContactDetailsPartner(kind: json.key, presentation: json.value as! String, owner_uuid: self.selectedUUID ?? "")
                            self.coreDataManager.saveContactDetailsPartner(contactDetailsPartners: [contactDetailsPartner]) {
                                self.coreDataManager.saveContext()
                            }
                        } else {
                            let alert = UIAlertController(title: "Ошибка \(statusCode), контактная информация не сохранена", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                                //self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            defaults.removeObject(forKey: "SavedJsonContactDetailsPartnerData")
        }
    }   */
    
    @objc func saveButtonClicked() {
        let tel = telTextField.text ?? ""
        let email = emailTextField.text ?? ""
        
        if tel.isEmpty && email.isEmpty {
            telTextField.shake()
            emailTextField.shake()
        } else if !tel.isEmpty && tel.count != 18 {
            telTextField.shake()
        } else if !email.isEmpty && !validEmail(email: email) {
            emailTextField.shake()
        } else {
            var jsonArray = [[String: String]]()
            var json = [String: String]()
            
            if !tel.isEmpty {
                json.removeAll()
                json["uuid"] = selectedUUID ?? ""
                json["kind"] = "tel"
                json["presentation"] = tel
                jsonArray.append(json)
            }
            if !email.isEmpty {
                json.removeAll()
                json["uuid"] = selectedUUID ?? ""
                json["kind"] = "email"
                json["presentation"] = email
                jsonArray.append(json)
            }
            
            if jsonArray.count > 0 {
            //if json.count > 0 {
                //saveRequestData(jsonArray)
                saveRequestData(jsonArray: jsonArray)
                
                let alert = UIAlertController(title: "Контактная информация сохранена", message: nil, preferredStyle: .alert)
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
        telTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
}

extension AddContactDetailsPartnerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = formatNumberPhone(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        return false
    }
}
