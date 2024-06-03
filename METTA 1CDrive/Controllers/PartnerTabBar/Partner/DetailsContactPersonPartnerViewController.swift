//
//  DetailsContactPersonPartnerViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 11.01.2024.
//

import UIKit
import Network

final class DetailsContactPersonPartnerViewController: UIViewController {
    
    var selectedFullName, selectedUUID: String?
    var contactDetailsContactPersonPartners = [ContactDetailsContactPersonPartner]()
    let dataManager = DataManager()
    let networkManager = NetworkManager()
    let coreDataManager = CoreDataManager.shared
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        if let text = selectedFullName {
            label.text = "ФИО: " + text
        } else {
            label.text = "ФИО: "
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableViewContact: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTabBar()
        setupConstraint()
        
        updateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Соединение с интернетом есть, отправляем сохраненные данные
                self.sendSavedRequestData()
            }
        }
        // Запуск монитора подключения к интернету
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(fullNameLabel)
        view.addSubview(tableViewContact)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fullNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            tableViewContact.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewContact.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewContact.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
            tableViewContact.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateTableView() {
        
        dataManager.getContactDetailsContactPersonPartnersByOwnerUUID(owner_uuid: selectedUUID ?? "", complitionHander: { contactDetailsContactPersonPartner in
            self.contactDetailsContactPersonPartners = contactDetailsContactPersonPartner
            self.contactDetailsContactPersonPartners.sort { $0.kind < $1.kind }
            self.tableViewContact.reloadData()
        })
    }
    
    func sendSavedRequestData() {
        let defaults = UserDefaults.standard
        
        if let jsonArray = defaults.object(forKey: "SavedJsonContactDetailsContactPersonsPartnersData") as? [[String: String]] {
            for json in jsonArray {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else { return }
                
                networkManager.postCreateContactDetailsContactPersonsPartners(jsonData: jsonData ) { statusCode in
                    
                    DispatchQueue.main.async {
                        if statusCode == "200" || statusCode == "201" {
                            if json["kind"] == "tel" {
                                let contactDetailsContactPersonPartner = ContactDetailsContactPersonPartner(kind: "Телефон", presentation: json["presentation"] ?? "", owner_uuid: json["uuid"] ?? "")
                                self.coreDataManager.saveContactDetailsContactPersonPartner(contactDetailsContactPersonPartners: [contactDetailsContactPersonPartner]) {
                                    self.coreDataManager.saveContext()
                                }
                            } else if json["kind"] == "email" {
                                let contactDetailsContactPersonPartner = ContactDetailsContactPersonPartner(kind: "Электронная почта", presentation: json["presentation"] ?? "", owner_uuid: json["uuid"] ?? "")
                                self.coreDataManager.saveContactDetailsContactPersonPartner(contactDetailsContactPersonPartners: [contactDetailsContactPersonPartner]) {
                                    self.coreDataManager.saveContext()
                                }
                            }
                            self.updateTableView()
                        } else {
                            let alert = UIAlertController(title: "Ошибка \(statusCode), контактная информация не сохранена", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            defaults.removeObject(forKey: "SavedJsonContactDetailsContactPersonsPartnersData")
        }
    }
    
    @objc func addContactInfoButtonClicked() {
        let alert = UIAlertController(title: "Хотите добавить новую контактную информацию?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            let addContactDetailsContactPersonsPartnersViewController = AddContactDetailsContactPersonsPartnersViewController()
            addContactDetailsContactPersonsPartnersViewController.selectedUUID = self.selectedUUID
            self.navigationController?.pushViewController(addContactDetailsContactPersonsPartnersViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DetailsContactPersonPartnerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewContact {
            return contactDetailsContactPersonPartners.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if tableView == tableViewContact {
            let contactDetailsContactPersonPartner = contactDetailsContactPersonPartners[indexPath.row]
            cell.textLabel?.text = (contactDetailsContactPersonPartner.kind ?? "") + ": " + (contactDetailsContactPersonPartner.presentation ?? "")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .systemBackground
        
        if tableView == tableViewContact {
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
            label.text = "Контактная информация:"
            
            let addContactInfoButton = UIButton.init(frame: CGRect(x: (headerView.frame.width / 2) - 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
            addContactInfoButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addContactInfoButton.addTarget(self, action: #selector(addContactInfoButtonClicked), for: .touchUpInside)
                    
            headerView.addSubview(label)
            headerView.addSubview(addContactInfoButton)
                    
        } else {
            
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewContact {
            let viewController = ContactInfoViewController()
            viewController.selectedKind = contactDetailsContactPersonPartners[indexPath.row].kind
            viewController.selectedPresentation = contactDetailsContactPersonPartners[indexPath.row].presentation
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}