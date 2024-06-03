//
//  PartnerTabBarController.swift
//  salesManager
//
//  Created by Роман Кокорев on 10.01.2024.
//

import UIKit

class PartnerTabBarController: UITabBarController {
    
    let defaults = UserDefaults.standard
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        view.backgroundColor = .systemBackground
    }
        
    func setupTabBar() {
        let partnersViewController = createNavController(viewController: PartnersViewController(), itemName: "Партнеры", ItemImage: "person.2.fill")
        let statisticViewController = createNavController(viewController: StatisticViewController(), itemName: "Статистика", ItemImage: "list.bullet.clipboard")
        let coldClientsViewController = createNavController(viewController: ColdClientsViewController(), itemName: "Холодные клиенты", ItemImage: "person.2.wave.2.fill")
        viewControllers = [partnersViewController, statisticViewController, coldClientsViewController]
    }
        
    func createNavController(viewController: UIViewController, itemName: String, ItemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: ItemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0))  ,tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = item
        return navigationController
    }
}
