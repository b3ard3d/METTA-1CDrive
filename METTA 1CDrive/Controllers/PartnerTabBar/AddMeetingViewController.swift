//
//  AddMeetingViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 22.02.2024.
//

import UIKit
import Network

class AddMeetingViewController: UIViewController {
    
    var selectedName, selectedUUID, selectedType, selectedStagesOfWork, selectedPurposeOfContact, selectedMeetingStatus: String?
    
    let dataManager = DataManager()
    let networkManager = NetworkManager()
    
    var stagesOfWorkArray = [StatusOfClient]()
    var purposeOfContactArray = [PurposeOfContact]()
    var meetingStatusArray = [StatusOfMeeting]()
    
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
        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .wheels
        dataPicker.locale = .autoupdatingCurrent
        dataPicker.translatesAutoresizingMaskIntoConstraints = false
        return dataPicker
    }()
    
    let dateAndTimePickerBegin: UIDatePicker = {
        let dataPicker = UIDatePicker()
        dataPicker.datePickerMode = .dateAndTime
        dataPicker.preferredDatePickerStyle = .wheels
        dataPicker.locale = .autoupdatingCurrent
        dataPicker.translatesAutoresizingMaskIntoConstraints = false
        return dataPicker
    }()
    
    let dateAndTimePickerEnd: UIDatePicker = {
        let dataPicker = UIDatePicker()
        dataPicker.datePickerMode = .dateAndTime
        dataPicker.preferredDatePickerStyle = .wheels
        dataPicker.locale = .autoupdatingCurrent
        dataPicker.translatesAutoresizingMaskIntoConstraints = false
        return dataPicker
    }()
    
    private lazy var stagesOfWorkPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var purposeOfContactPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var meetingStatusPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var dateOfBeginLabel: UILabel = {
        let label = UILabel()
        label.text = "Начало:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateOfEndLabel: UILabel = {
        let label = UILabel()
        label.text = "Окончание:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subjectLabel: UILabel = {
        let label = UILabel()
        label.text = "Тема:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stagesOfWorkLabel: UILabel = {
        let label = UILabel()
        label.text = "Этап работы:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateOfNewContactLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата нового контакта:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var purposeOfContactLabel: UILabel = {
        let label = UILabel()
        label.text = "Цель контакта:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var criticalEventLabel: UILabel = {
        let label = UILabel()
        label.text = "Критическое событие:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailsLabel: UILabel = {
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
    }()
    
    private lazy var dateOfBeginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите дату начала"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var dateOfEndTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите дату окончания"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var subjectTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите тему"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var stagesOfWorkTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите этап работы"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var dateOfNewContactTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите дату нового контакта"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var purposeOfContactTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите цель контакта"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var criticalEventTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var detailsTextView: UITextView = {
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
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupConstraint()
        createDatePicker()
        createDateBeginPicker()
        createDateEndPicker()
        
        dataManager.getAllPurposeOfContacts { purposeOfContacts in
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
        }
        
        var getDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateOfBeginTextField.text = dateFormatter.string(from: getDate)
        
        getDate.addTimeInterval(60*30)
        dateOfEndTextField.text = dateFormatter.string(from: getDate)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(dateOfBeginLabel)
        contentView.addSubview(dateOfBeginTextField)
        contentView.addSubview(dateOfEndLabel)
        contentView.addSubview(dateOfEndTextField)
        contentView.addSubview(subjectLabel)
        contentView.addSubview(subjectTextField)
        contentView.addSubview(appointmentLocationLabel)
        contentView.addSubview(appointmentLocationTextField)
        contentView.addSubview(stagesOfWorkLabel)
        contentView.addSubview(stagesOfWorkTextField)
        contentView.addSubview(dateOfNewContactLabel)
        contentView.addSubview(dateOfNewContactTextField)
        contentView.addSubview(purposeOfContactLabel)
        contentView.addSubview(purposeOfContactTextField)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(detailsTextView)
        contentView.addSubview(criticalEventLabel)
        contentView.addSubview(criticalEventTextView)
        contentView.addSubview(meetingStatusLabel)
        contentView.addSubview(meetingStatusTextField)
                        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(kbwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        stagesOfWorkTextField.inputView = stagesOfWorkPickerView
        purposeOfContactTextField.inputView = purposeOfContactPickerView
        meetingStatusTextField.inputView = meetingStatusPickerView
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Встреча"
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

            
            dateOfBeginLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfBeginLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateOfBeginLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            dateOfBeginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfBeginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateOfBeginTextField.topAnchor.constraint(equalTo: dateOfBeginLabel.bottomAnchor, constant: 5),
            dateOfBeginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            dateOfEndLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfEndLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateOfEndLabel.topAnchor.constraint(equalTo: dateOfBeginTextField.bottomAnchor, constant: 10),
            
            dateOfEndTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfEndTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateOfEndTextField.topAnchor.constraint(equalTo: dateOfEndLabel.bottomAnchor, constant: 5),
            dateOfEndTextField.heightAnchor.constraint(equalToConstant: 50),
            
            subjectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subjectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subjectLabel.topAnchor.constraint(equalTo: dateOfEndTextField.bottomAnchor, constant: 10),

            subjectTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subjectTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subjectTextField.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 5),
            subjectTextField.heightAnchor.constraint(equalToConstant: 50),
            
            appointmentLocationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            appointmentLocationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            appointmentLocationLabel.topAnchor.constraint(equalTo: subjectTextField.bottomAnchor, constant: 10),

            appointmentLocationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            appointmentLocationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            appointmentLocationTextField.topAnchor.constraint(equalTo: appointmentLocationLabel.bottomAnchor, constant: 5),
            appointmentLocationTextField.heightAnchor.constraint(equalToConstant: 50),
            
            stagesOfWorkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stagesOfWorkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stagesOfWorkLabel.topAnchor.constraint(equalTo: appointmentLocationTextField.bottomAnchor, constant: 10),
            
            stagesOfWorkTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stagesOfWorkTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stagesOfWorkTextField.topAnchor.constraint(equalTo: stagesOfWorkLabel.bottomAnchor, constant: 5),
            stagesOfWorkTextField.heightAnchor.constraint(equalToConstant: 50),
            
            dateOfNewContactLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfNewContactLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateOfNewContactLabel.topAnchor.constraint(equalTo: stagesOfWorkTextField.bottomAnchor, constant: 10),
            
            dateOfNewContactTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfNewContactTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateOfNewContactTextField.topAnchor.constraint(equalTo: dateOfNewContactLabel.bottomAnchor, constant: 5),
            dateOfNewContactTextField.heightAnchor.constraint(equalToConstant: 50),
            
            purposeOfContactLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            purposeOfContactLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            purposeOfContactLabel.topAnchor.constraint(equalTo: dateOfNewContactTextField.bottomAnchor, constant: 10),
            
            purposeOfContactTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            purposeOfContactTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            purposeOfContactTextField.topAnchor.constraint(equalTo: purposeOfContactLabel.bottomAnchor, constant: 5),
            purposeOfContactTextField.heightAnchor.constraint(equalToConstant: 50),
            
            meetingStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            meetingStatusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            meetingStatusLabel.topAnchor.constraint(equalTo: purposeOfContactTextField.bottomAnchor, constant: 10),
            
            meetingStatusTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            meetingStatusTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            meetingStatusTextField.topAnchor.constraint(equalTo: meetingStatusLabel.bottomAnchor, constant: 5),
            meetingStatusTextField.heightAnchor.constraint(equalToConstant: 50),
            
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailsLabel.topAnchor.constraint(equalTo: meetingStatusTextField.bottomAnchor, constant: 10),
            
            detailsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailsTextView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            detailsTextView.heightAnchor.constraint(equalToConstant: 100),
            
            criticalEventLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            criticalEventLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            criticalEventLabel.topAnchor.constraint(equalTo: detailsTextView.bottomAnchor, constant: 10),
            
            criticalEventTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            criticalEventTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            criticalEventTextView.topAnchor.constraint(equalTo: criticalEventLabel.bottomAnchor, constant: 5),
            criticalEventTextView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        dateOfNewContactTextField.inputAccessoryView = toolbar
        dateOfNewContactTextField.inputView = datePicker
    }
    
    func createDateBeginPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donePressedBegin))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        dateOfBeginTextField.inputAccessoryView = toolbar
        dateOfBeginTextField.inputView = dateAndTimePickerBegin
    }
    
    func createDateEndPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donePressedEnd))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        dateOfEndTextField.inputAccessoryView = toolbar
        dateOfEndTextField.inputView = dateAndTimePickerBegin
    }
    
    func saveRequestData(_ jsonData: Data) {
        let defaults = UserDefaults.standard
        if selectedType == "Справочник.ХолодныеКлиенты" {
            defaults.set(jsonData, forKey: "SavedJsonMeetingDataColdClients")
        } else if selectedType == "Справочник.Партнеры" {
            defaults.set(jsonData, forKey: "SavedJsonMeetingDataPartners")
        }
        
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateOfNewContactTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func donePressedBegin() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateOfBeginTextField.text = formatter.string(from: dateAndTimePickerBegin.date)
        self.view.endEditing(true)
    }
    
    @objc func donePressedEnd() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateOfEndTextField.text = formatter.string(from: dateAndTimePickerBegin.date)
        self.view.endEditing(true)
    }
    
    @objc func saveButtonClicked() {
        let subjectText = subjectTextField.text ?? ""
        let stagesOfWorkText = stagesOfWorkTextField.text ?? ""
        var dateOfNewContactText = dateOfNewContactTextField.text ?? ""
        let purposeOfContactText = purposeOfContactTextField.text ?? ""
        let criticalEventText = criticalEventTextView.text ?? ""
        let detailsText = detailsTextView.text ?? ""
        let meetingStatusText = meetingStatusTextField.text ?? ""
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
        subjectTextField.resignFirstResponder()
        stagesOfWorkTextField.resignFirstResponder()
        dateOfNewContactTextField.resignFirstResponder()
        purposeOfContactTextField.resignFirstResponder()
        criticalEventTextView.resignFirstResponder()
        meetingStatusTextField.resignFirstResponder()
        detailsTextView.resignFirstResponder()
        appointmentLocationTextField.resignFirstResponder()
    }
    
    @objc private func adjustForKeyboard(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let heightTabBar = (self.tabBarController?.tabBar.frame.height ?? 49.0) + 20
            
            if criticalEventTextView.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - criticalEventTextView.frame.origin.y - criticalEventTextView.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if meetingStatusTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - meetingStatusTextField.frame.origin.y - meetingStatusTextField.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if purposeOfContactTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - purposeOfContactTextField.frame.origin.y - purposeOfContactTextField.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            } else if detailsTextView.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - detailsTextView.frame.origin.y - detailsTextView.frame.size.height - heightTabBar
                let difference = keyboardHeight - emptySpaceHeight
                if emptySpaceHeight <= keyboardHeight {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                }
            }
            else if appointmentLocationTextField.isFirstResponder {
                let emptySpaceHeight = view.frame.size.height - appointmentLocationTextField.frame.origin.y - appointmentLocationTextField.frame.size.height - heightTabBar
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

extension AddMeetingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == stagesOfWorkPickerView {
            return stagesOfWorkArray.count
        } else if pickerView == purposeOfContactPickerView {
            return purposeOfContactArray.count
        } else if pickerView == meetingStatusPickerView {
            return meetingStatusArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == stagesOfWorkPickerView {
            return stagesOfWorkArray[row].name
        } else if pickerView == purposeOfContactPickerView {
            return purposeOfContactArray[row].name
        } else if pickerView == meetingStatusPickerView {
            return meetingStatusArray[row].name
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == stagesOfWorkPickerView {
            stagesOfWorkTextField.text = stagesOfWorkArray[row].name
            stagesOfWorkTextField.resignFirstResponder()
            self.selectedStagesOfWork = stagesOfWorkArray[row].uuid
        } else if pickerView == purposeOfContactPickerView {
            purposeOfContactTextField.text = purposeOfContactArray[row].name
            purposeOfContactTextField.resignFirstResponder()
            self.selectedPurposeOfContact = purposeOfContactArray[row].uuid
        } else if pickerView == meetingStatusPickerView {
            meetingStatusTextField.text = meetingStatusArray[row].name
            meetingStatusTextField.resignFirstResponder()
            self.selectedMeetingStatus = meetingStatusArray[row].uuid
        } else {
        
        }
    }
}
