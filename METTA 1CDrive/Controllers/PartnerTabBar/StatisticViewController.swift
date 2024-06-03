//
//  StatisticViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 17.02.2024.
//

import UIKit

class StatisticViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let coreDataManager = CoreDataManager.shared
    let networkManager = NetworkManager()    
    
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
    
    private lazy var dayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var monthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleDayLabel: UILabel = {
        let label = UILabel()
        label.text = "План/Факт/% выполнения (день)"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saleDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Продажи, руб: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var callsPcsDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Звонки, шт: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var callsMinDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Звонки, мин: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var newClientDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Новые клиенты: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var numberOfMessagesDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Число сообщений: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var commercialOfferDayLabel: UILabel = {
        let label = UILabel()
        label.text = "КП: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "План/Факт/% выполнения (месяц)"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saleMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "Продажи, руб: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var callsPcsMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "Звонки, шт: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var callsMinMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "Звонки, мин: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var newClientMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "Новые клиенты: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var numberOfMessagesMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "Число сообщений: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var commercialOfferMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "КП: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        setupNavigationBar()
        setupTabBar()
        
        let userAuthorization = defaults.bool(forKey: "userAuthorization")
        let userLogin = defaults.string(forKey: "userLogin")
        if userAuthorization {
            let exitButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(exitButtonClicked))

            navigationItem.leftBarButtonItems = [exitButton]
            navigationItem.title = userLogin
        }
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(dayStackView)
        contentView.addSubview(monthStackView)
        
        dayStackView.addArrangedSubview(titleDayLabel)
        dayStackView.addArrangedSubview(saleDayLabel)
        dayStackView.addArrangedSubview(callsPcsDayLabel)
        dayStackView.addArrangedSubview(callsMinDayLabel)
        dayStackView.addArrangedSubview(newClientDayLabel)
        dayStackView.addArrangedSubview(numberOfMessagesDayLabel)
        dayStackView.addArrangedSubview(commercialOfferDayLabel)
        
        monthStackView.addArrangedSubview(titleMonthLabel)
        monthStackView.addArrangedSubview(saleMonthLabel)
        monthStackView.addArrangedSubview(callsPcsMonthLabel)
        monthStackView.addArrangedSubview(callsMinMonthLabel)
        monthStackView.addArrangedSubview(newClientMonthLabel)
        monthStackView.addArrangedSubview(numberOfMessagesMonthLabel)
        monthStackView.addArrangedSubview(commercialOfferMonthLabel)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
        navigationItem.hidesBackButton = true
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            dayStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dayStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dayStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            dayStackView.heightAnchor.constraint(equalToConstant: 250),
            
            monthStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            monthStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            monthStackView.topAnchor.constraint(equalTo: dayStackView.bottomAnchor, constant: 15),
            monthStackView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    @objc func exitButtonClicked() {
        let alert = UIAlertController(title: "Вы уверены что хотите выйти", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.defaults.removeObject(forKey: "userLogin")
            self.defaults.removeObject(forKey: "userPassword")
            self.defaults.removeObject(forKey: "userAuthorization")
            self.defaults.removeObject(forKey: "useFaceID")
            //self.navigationController?.pushViewController(LogInViewContoller(), animated: true)
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
}
