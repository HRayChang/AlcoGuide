//
//  TabBarController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cocktailViewController = createNavigationController(with: CocktailViewController())
        cocktailViewController.tabBarItem.image = UIImage(systemName: "heart")
        cocktailViewController.tabBarItem.title = "Heart"

        let scheduleViewController = createNavigationController(with: MyScheduleViewController())
        scheduleViewController.tabBarItem.image = UIImage(systemName: "heart")
        scheduleViewController.tabBarItem.title = "Heart"

        let chatViewController = createNavigationController(with: ChatViewController())
        chatViewController.tabBarItem.image = UIImage(systemName: "heart")
        chatViewController.tabBarItem.title = "Heart"

        let mapHomeViewController = createNavigationController(with: MapHomeViewController())
        mapHomeViewController.tabBarItem.image = UIImage(systemName: "heart")
        mapHomeViewController.tabBarItem.title = "Heart"

        let personalViewController = createNavigationController(with: PersonalViewController())
        personalViewController.tabBarItem.image = UIImage(systemName: "heart")
        personalViewController.tabBarItem.title = "Heart"

        viewControllers = [chatViewController,
                           scheduleViewController,
                           mapHomeViewController,
                           cocktailViewController,
                           personalViewController]

        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.green], for: .selected)
    }

    private func createNavigationController(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)

        return navigationController
    }
}
