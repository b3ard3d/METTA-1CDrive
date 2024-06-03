//
//  ColdClientsViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 10.01.2024.
//

import UIKit
import Network

final class ColdClientsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let dataManager = DataManager()
    let coreDataManager = CoreDataManager.shared
    var coldClients = [ColdClient]()
    let openApplication = OpenApplication()
    let networkManager = NetworkManager()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        setupNavigationBar()
        setupTabBar()
        
        dataManager.getAllColdClients { coldClient in
            self.coldClients = coldClient
            self.coldClients.sort { $0.name < $1.name }
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.getAllColdClients { coldClient in
            self.coldClients = coldClient
            self.coldClients.sort { $0.name < $1.name }
            self.tableView.reloadData()
        }
        
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
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
        navigationItem.hidesBackButton = true
        
        let userAuthorization = defaults.bool(forKey: "userAuthorization")
        let userLogin = defaults.string(forKey: "userLogin")
        if userAuthorization {
            let exitButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(exitButtonClicked))
            let addNewColdClientButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done,  target: self, action: #selector(addColdClientButtonClicked))
            navigationItem.rightBarButtonItems = [addNewColdClientButton]
            navigationItem.leftBarButtonItems = [exitButton]
            navigationItem.title = userLogin
        }
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateTableView() {
        dataManager.getAllColdClients { coldClient in
            self.coldClients = coldClient
            self.coldClients.sort { $0.name < $1.name }
            self.tableView.reloadData()
        }
    }
    
    func sendSavedRequestData() {
        let defaults = UserDefaults.standard
        if let jsonData = defaults.data(forKey: "SavedJsonColdClientData"),
           let nameColdClient = defaults.string(forKey: "SavedNameColdClient") {
            
            networkManager.postCreateColdClient(nameColdClient: nameColdClient, jsonData: jsonData) { uuid in
                
                DispatchQueue.main.async {
                    if uuid != "" {
                        let coldClient = ColdClient(uuid: uuid, name: nameColdClient)
                        self.coreDataManager.saveColdClient(coldClients: [coldClient]) {
                            self.coreDataManager.saveContext()
                        }
                        defaults.removeObject(forKey: "SavedJsonColdClientData")
                        defaults.removeObject(forKey: "SavedNameColdClient")
                        
                        self.updateTableView()
                    } else {
                        let alert = UIAlertController(title: "Ошибка \(uuid), холодный клиент \(nameColdClient) не создан", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            if let jsonData = defaults.data(forKey: "SavedJsonMeetingDataColdClients") {
            
                networkManager.postCreateDocumentMeeting(jsonData: jsonData ) { statusCode in
                    
                    DispatchQueue.main.async {
                        if statusCode == 200 {
                            defaults.removeObject(forKey: "SavedJsonMeetingDataColdClients")
                            
                        } else {
                            let alert = UIAlertController(title: "Ошибка \(statusCode), встреча не создана", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
        
    @objc func exitButtonClicked() {
        let alert = UIAlertController(title: "Вы уверены что хотите выйти", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.defaults.removeObject(forKey: "userLogin")
            self.defaults.removeObject(forKey: "userPassword")
            self.defaults.removeObject(forKey: "userAuthorization")
            self.defaults.removeObject(forKey: "useFaceID")
            
            self.defaults.removeObject(forKey: "SavedJsonColdClientData")
            self.defaults.removeObject(forKey: "SavedNameColdClient")
            self.defaults.removeObject(forKey: "SavedTelephoneColdClient")
            self.defaults.removeObject(forKey: "SavedEmailColdClient")
            
            self.defaults.removeObject(forKey: "SavedJsonMeetingDataColdClients")
            self.defaults.removeObject(forKey: "SavedJsonMeetingDataPartners")
            
            self.defaults.removeObject(forKey: "SavedJsonContactDetailsPartnerData")
            self.defaults.removeObject(forKey: "SavedJsonContactDetailsPartnerUUID")
            
            self.defaults.removeObject(forKey: "SavedJsonContactDetailsColdClientsData")
            
            self.defaults.removeObject(forKey: "SavedJsonContactPersonPartnerData")
            
            self.coreDataManager.deleteAllAndCreateNewDB()

            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            guard let rootViewController = window.rootViewController else {
                return
            }
            let viewController = MainTabBarController()
            viewController.view.frame = rootViewController.view.frame
            viewController.view.layoutIfNeeded()

            UIView.transition(with: window, duration: 0.6, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = viewController
            }, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addColdClientButtonClicked() {
        let alert = UIAlertController(title: "Хотите добавить нового холодного клиента?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            let addColdClientViewController = AddColdClientViewController()
            self.navigationController?.pushViewController(addColdClientViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ColdClientsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coldClients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let coldClient = coldClients[indexPath.row]
        cell.textLabel?.text = coldClient.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailsColdClientViewController()
        viewController.selectedName = coldClients[indexPath.row].name
        viewController.selectedUUID = coldClients[indexPath.row].uuid
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
