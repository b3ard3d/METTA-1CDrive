//
//  AddOrderViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 09.05.2024.
//

import UIKit

class AddOrderViewController: UIViewController {
    
    var selectedUUID, selectedName, selectedCounterparties, selectedCompanies, selectedUUIDCounterparties, selectedUUIDCompanies: String?
    
    let dataManager = DataManager()
    let networkManager = NetworkManager()
    let coreDataManager = CoreDataManager.shared
    
    var clientArray = [Partner]()
    var counterpartiesArray = [Counterparties]()
    var agreementArray = [String]()
    var companiesArray = [Companies]()
    var operationArray = [String]()
    var warehouseArray = [String]()
    var termsOfSaleArray = [TermsOfSale]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let datePicker: UIDatePicker = {
        let dataPicker = UIDatePicker()
        dataPicker.datePickerMode = .dateAndTime
        dataPicker.preferredDatePickerStyle = .wheels
        dataPicker.locale = .autoupdatingCurrent
        dataPicker.translatesAutoresizingMaskIntoConstraints = false
        return dataPicker
    }()
    
    private lazy var clientPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var counterpartiesPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var termsOfSalePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        //pickerView.cou
        return pickerView
    }()
    
    private lazy var companiesPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var operationPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var warehousePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var dateDocumentLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата документа:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clientLabel: UILabel = {
        let label = UILabel()
        label.text = "Клиент:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterpartiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Контрагент:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var termsOfSaleLabel: UILabel = {
        let label = UILabel()
        label.text = "Соглашение:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var companiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Организация:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var operationLabel: UILabel = {
        let label = UILabel()
        label.text = "Операция:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var warehouseLabel: UILabel = {
        let label = UILabel()
        label.text = "Склад:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарий:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
 /*   private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var meetingStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Статус встречи:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var appointmentLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Место проведения встречи:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }() */
    
    private lazy var dateDocumentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите дату"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var clientTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите клиента"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var counterpartiesTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите контрагента"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var termsOfSaleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите соглашение"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var companiesTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите организацию"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var operationTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите операцию"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var warehouseTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите склад"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
 /*   private lazy var detailsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var meetingStatusTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите статус встречи"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var appointmentLocationTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите место встречи"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }() */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupConstraint()
        createDatePicker()
        
        dataManager.getAllCompanies { companies in
            self.companiesArray = companies
            self.companiesArray.sort { $0.name < $1.name }
            
            var defaultRow = 0
            for (n, element) in self.companiesArray.enumerated() {
                if element.name == "КОМПАНИЯ МЕТТА ООО" {
                    defaultRow = n
                    self.companiesTextField.text = "КОМПАНИЯ МЕТТА ООО"
                    self.selectedUUIDCompanies = element.uuid
                    
                    self.updateTermsOfSaleTable()
                }
            }
            self.companiesPickerView.selectRow(defaultRow, inComponent: 0, animated: true)
        }
        
        dataManager.getAllCounterparties(uuid: selectedUUID ?? "") { counterparties in
            self.counterpartiesArray = counterparties
            self.counterpartiesArray.sort { $0.name < $1.name }
            
            var defaultRow = 0
            for (n, element) in self.counterpartiesArray.enumerated() {
                if element.name == self.selectedCounterparties ?? "" {
                    defaultRow = n
                    self.counterpartiesTextField.text = self.selectedCounterparties ?? ""
                    self.selectedUUIDCounterparties = element.uuid
                    
                    self.updateTermsOfSaleTable()
                }
            }
            self.counterpartiesPickerView.selectRow(defaultRow, inComponent: 0, animated: true)
        }
        
        dataManager.getAllPartners { clients in
            self.clientArray = clients
            self.clientArray.sort { $0.name < $1.name }
            
            var defaultRow = 0
            for (n, element) in self.clientArray.enumerated() {
                if element.name == self.selectedName {
                    defaultRow = n
                    self.clientTextField.text = self.selectedName ?? ""
                }
            }
            self.clientPickerView.selectRow(defaultRow, inComponent: 0, animated: true)
        }
        
  /*      dataManager.getAllPurposeOfContacts { purposeOfContacts in
            self.purposeOfContactArray = purposeOfContacts
            self.purposeOfContactArray.sort { $0.name < $1.name }
        }
        
        dataManager.getAllStatusOfMeetings { statusOfMeetings in
            self.meetingStatusArray = statusOfMeetings
            self.meetingStatusArray.sort { $0.name < $1.name }
        }
        
        dataManager.getAllStatusOfClients { statusOfClients in
            self.stagesOfWorkArray = statusOfClients
            self.stagesOfWorkArray.sort { $0.name < $1.name }
        }   */
        
        var getDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateDocumentTextField.text = dateFormatter.string(from: getDate)
        
        //getDate.addTimeInterval(60*30)
        //dateOfEndTextField.text = dateFormatter.string(from: getDate)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(dateDocumentLabel)
        contentView.addSubview(dateDocumentTextField)
        contentView.addSubview(clientLabel)
        contentView.addSubview(clientTextField)
        contentView.addSubview(counterpartiesLabel)
        contentView.addSubview(counterpartiesTextField)
        contentView.addSubview(termsOfSaleLabel)
        contentView.addSubview(termsOfSaleTextField)
        contentView.addSubview(operationLabel)
        contentView.addSubview(operationTextField)
        contentView.addSubview(companiesLabel)
        contentView.addSubview(companiesTextField)
        contentView.addSubview(warehouseLabel)
        contentView.addSubview(warehouseTextField)
        contentView.addSubview(commentLabel)
        contentView.addSubview(commentTextView)
        //contentView.addSubview(criticalEventLabel)
        //contentView.addSubview(criticalEventTextView)
        //contentView.addSubview(meetingStatusLabel)
        //contentView.addSubview(meetingStatusTextField)
                        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(kbwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        clientTextField.inputView = clientPickerView
        counterpartiesTextField.inputView = counterpartiesPickerView
        termsOfSaleTextField.inputView = termsOfSalePickerView
        operationTextField.inputView = operationPickerView
        companiesTextField.inputView = companiesPickerView
        warehouseTextField.inputView = warehousePickerView
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Заказ"
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonClicked))
        let closeButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 960),

            
            dateDocumentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateDocumentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateDocumentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            dateDocumentTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateDocumentTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateDocumentTextField.topAnchor.constraint(equalTo: dateDocumentLabel.bottomAnchor, constant: 5),
            dateDocumentTextField.heightAnchor.constraint(equalToConstant: 50),
            
            clientLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            clientLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            clientLabel.topAnchor.constraint(equalTo: dateDocumentTextField.bottomAnchor, constant: 10),
            
            clientTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            clientTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            clientTextField.topAnchor.constraint(equalTo: clientLabel.bottomAnchor, constant: 5),
            clientTextField.heightAnchor.constraint(equalToConstant: 50),
            
            counterpartiesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counterpartiesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            counterpartiesLabel.topAnchor.constraint(equalTo: clientTextField.bottomAnchor, constant: 10),

            counterpartiesTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counterpartiesTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            counterpartiesTextField.topAnchor.constraint(equalTo: counterpartiesLabel.bottomAnchor, constant: 5),
            counterpartiesTextField.heightAnchor.constraint(equalToConstant: 50),
            
            termsOfSaleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            termsOfSaleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            termsOfSaleLabel.topAnchor.constraint(equalTo: counterpartiesTextField.bottomAnchor, constant: 10),

            termsOfSaleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            termsOfSaleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            termsOfSaleTextField.topAnchor.constraint(equalTo: termsOfSaleLabel.bottomAnchor, constant: 5),
            termsOfSaleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            operationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            operationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            operationLabel.topAnchor.constraint(equalTo: termsOfSaleTextField.bottomAnchor, constant: 10),
            
            operationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            operationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            operationTextField.topAnchor.constraint(equalTo: operationLabel.bottomAnchor, constant: 5),
            operationTextField.heightAnchor.constraint(equalToConstant: 50),
            
            companiesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            companiesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            companiesLabel.topAnchor.constraint(equalTo: operationTextField.bottomAnchor, constant: 10),
            
            companiesTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            companiesTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            companiesTextField.topAnchor.constraint(equalTo: companiesLabel.bottomAnchor, constant: 5),
            companiesTextField.heightAnchor.constraint(equalToConstant: 50),
            
            warehouseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            warehouseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            warehouseLabel.topAnchor.constraint(equalTo: companiesTextField.bottomAnchor, constant: 10),
            
            warehouseTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            warehouseTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            warehouseTextField.topAnchor.constraint(equalTo: warehouseLabel.bottomAnchor, constant: 5),
            warehouseTextField.heightAnchor.constraint(equalToConstant: 50),
            
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentLabel.topAnchor.constraint(equalTo: warehouseTextField.bottomAnchor, constant: 10),
            
            commentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentTextView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 5),
            commentTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        dateDocumentTextField.inputAccessoryView = toolbar
        dateDocumentTextField.inputView = datePicker
    }
    
    func saveRequestData(_ jsonData: Data) {
        let defaults = UserDefaults.standard
    /*    if selectedType == "Справочник.ХолодныеКлиенты" {
            defaults.set(jsonData, forKey: "SavedJsonMeetingDataColdClients")
        } else if selectedType == "Справочник.Партнеры" {
            defaults.set(jsonData, forKey: "SavedJsonMeetingDataPartners")
        }   */
    }
    
    func updateTermsOfSaleTable() {
        if (selectedUUID ?? "") != "" && (selectedUUIDCompanies ?? "") != "" && (selectedUUIDCounterparties ?? "") != "" {
            dataManager.getTermsOfSale(owner_uuid: selectedUUID ?? "", uuidCompanies: selectedUUIDCompanies ?? "", uuidCounterparties: selectedUUIDCounterparties ?? "") { termsOfSale in
                self.termsOfSaleArray = termsOfSale
                self.termsOfSaleArray.sort { $0.name < $1.name }
            }
        }
    }
    
    func updateCompaniesTable() {
        dataManager.getAllCompanies { companies in
            self.companiesArray = companies
            self.companiesArray.sort { $0.name < $1.name }
        }
    }
    
    func updateCounterpartiesTable() {
        dataManager.getAllCounterparties(uuid: selectedUUID ?? "") { counterparties in
            self.counterpartiesArray = counterparties
            self.counterpartiesArray.sort { $0.name < $1.name }
        }
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateDocumentTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func saveButtonClicked() {
        let dateDocumentText = dateDocumentTextField.text ?? ""
        let clientText = clientTextField.text ?? ""
        var counterpartiesText = counterpartiesTextField.text ?? ""
        let termsOfSaleText = termsOfSaleTextField.text ?? ""
        let operationText = operationTextField.text ?? ""
        let companiesText = companiesTextField.text ?? ""
        let warehouseText = warehouseTextField.text ?? ""
        let commentText = commentTextView.text ?? ""
  /*      let meetingStatusText = meetingStatusTextField.text ?? ""
        var dateBeginText = dateOfBeginTextField.text ?? ""
        var dateEndText = dateOfEndTextField.text ?? ""
        let appointmentLocationText = appointmentLocationTextField.text ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        guard let dateBeginTextTemp = formatter.date(from: dateBeginText) else {return}
        guard let dateEndTextTemp = formatter.date(from: dateEndText) else {return}
        formatter.dateFormat = "dd.MM.yyyy"
        guard let dateOfNewContactTemp = formatter.date(from: dateOfNewContactText) else {return}
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateBeginText = formatter.string(from: dateBeginTextTemp)
        dateEndText = formatter.string(from: dateEndTextTemp)
        formatter.dateFormat = "yyyy.MM.dd"
        dateOfNewContactText = formatter.string(from: dateOfNewContactTemp)
        
        if subjectText.isEmpty && stagesOfWorkText.isEmpty && dateOfNewContactText.isEmpty && purposeOfContactText.isEmpty && detailsText.isEmpty && meetingStatusText.isEmpty && dateBeginText.isEmpty && dateEndText.isEmpty && appointmentLocationText.isEmpty {
            subjectTextField.shake()
            stagesOfWorkTextField.shake()
            dateOfNewContactTextField.shake()
            purposeOfContactTextField.shake()
            detailsTextView.shake()
            meetingStatusTextField.shake()
            dateOfBeginTextField.shake()
            dateOfEndTextField.shake()
            appointmentLocationTextField.shake()
        } else if subjectText.isEmpty || stagesOfWorkText.isEmpty || dateOfNewContactText.isEmpty || purposeOfContactText.isEmpty || detailsText.isEmpty || meetingStatusText.isEmpty || dateBeginText.isEmpty || dateEndText.isEmpty || appointmentLocationText.isEmpty {
            if subjectText.isEmpty {
                subjectTextField.shake()
            }
            if stagesOfWorkText.isEmpty {
                stagesOfWorkTextField.shake()
            }
            if dateOfNewContactText.isEmpty {
                dateOfNewContactTextField.shake()
            }
            if purposeOfContactText.isEmpty {
                purposeOfContactTextField.shake()
            }
            if detailsText.isEmpty {
                detailsTextView.shake()
            }
            if meetingStatusText.isEmpty {
                meetingStatusTextField.shake()
            }
            if dateBeginText.isEmpty {
                dateOfBeginTextField.shake()
            }
            if dateEndText.isEmpty {
                dateOfEndTextField.shake()
            }
            if appointmentLocationText.isEmpty {
                appointmentLocationTextField.shake()
            }
        } else {
            var jsonArray = [String: Any]()
            
            jsonArray["status_of_client"] = selectedStagesOfWork
            jsonArray["status_of_meeting"] = selectedMeetingStatus
            jsonArray["purpose_of_contact"] = selectedPurposeOfContact
            jsonArray["start_date"] = dateBeginText
            jsonArray["end_date"] = dateEndText
            jsonArray["date_of_new_contact"] = dateOfNewContactText
            jsonArray["appointment_location"] = appointmentLocationText
            jsonArray["details"] = detailsText
            jsonArray["subject"] = subjectText
            jsonArray["critical_event"] = criticalEventText
            
            let json: [String: String] = [
                "uuid" : selectedUUID ?? "",
                "type" : selectedType ?? ""
            ]
            
            if json.count > 0 {
                jsonArray["contact"] = json
            }
            
            print(jsonArray)
            
            if jsonArray.count > 1 {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray) else { return }
                
                saveRequestData(jsonData)
                
                let alert = UIAlertController(title: "Встреча сохранена", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }   */
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
        clientTextField.resignFirstResponder()
        counterpartiesTextField.resignFirstResponder()
        termsOfSaleTextField.resignFirstResponder()
        operationTextField.resignFirstResponder()
        companiesTextField.resignFirstResponder()
        warehouseTextField.resignFirstResponder()
        commentTextView.resignFirstResponder()
    }
    
    @objc private func adjustForKeyboard(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let heightTabBar = (self.tabBarController?.tabBar.frame.height ?? 49.0) + 20
            
            if clientTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - clientTextField.frame.origin.y - clientTextField.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if counterpartiesTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - counterpartiesTextField.frame.origin.y - counterpartiesTextField.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if termsOfSaleTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - termsOfSaleTextField.frame.origin.y - termsOfSaleTextField.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if operationTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - operationTextField.frame.origin.y - operationTextField.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if companiesTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - companiesTextField.frame.origin.y - companiesTextField.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if warehouseTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - warehouseTextField.frame.origin.y - warehouseTextField.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if commentTextView.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - commentTextView.frame.origin.y - commentTextView.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            }
        }
    }
    
    @objc func kbwillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension AddOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == clientPickerView {
            return clientArray.count
        } else if pickerView == counterpartiesPickerView {
            return counterpartiesArray.count
        } else if pickerView == termsOfSalePickerView {
            return termsOfSaleArray.count
        } else if pickerView == operationPickerView {
            return operationArray.count
        } else if pickerView == companiesPickerView {
            return companiesArray.count
        } else if pickerView == warehousePickerView {
            return warehouseArray.count
        } else if pickerView == clientPickerView {
            return clientArray.count
        } else {
            return 0
        }
    }
    
/*    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == companiesPickerView {
            return companiesArray[row].name
        } else if pickerView == counterpartiesPickerView {
            return counterpartiesArray[row].name
        } else if pickerView == termsOfSalePickerView {
            return termsOfSaleArray[row].name
        } else if pickerView == clientPickerView {
            return clientArray[row].name
        } else {
            return nil
        }
    }   */
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == companiesPickerView {
            companiesTextField.text = companiesArray[row].name
            companiesTextField.resignFirstResponder()
            selectedCompanies = companiesArray[row].uuid
            updateTermsOfSaleTable()
        } else if pickerView == counterpartiesPickerView {
            counterpartiesTextField.text = counterpartiesArray[row].name
            counterpartiesTextField.resignFirstResponder()
            selectedCounterparties = counterpartiesArray[row].uuid
            updateTermsOfSaleTable()
        } else if pickerView == termsOfSalePickerView {
            if termsOfSaleArray.count > 0 {
                termsOfSaleTextField.text = termsOfSaleArray[row].name
                termsOfSaleTextField.resignFirstResponder()
            }
        } else if pickerView == clientPickerView {
            clientTextField.text = clientArray[row].name
            clientTextField.resignFirstResponder()
        } else {
        
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == companiesPickerView {
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 18)
            label.text =  companiesArray[row].name
            label.textAlignment = .center
            return label
        } else if pickerView == counterpartiesPickerView {
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 18)
            label.text =  counterpartiesArray[row].name
            label.textAlignment = .center
            return label
        } else if pickerView == termsOfSalePickerView {
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 18)
            label.text =  termsOfSaleArray[row].name
            label.textAlignment = .center
            return label
        } else if pickerView == clientPickerView {
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = UIFont (name: "Helvetica Neue", size: 18)
            label.text =  clientArray[row].name
            label.textAlignment = .center
            return label
        } else {
            return UILabel()
        }
    }
}
