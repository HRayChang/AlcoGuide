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
        cocktailViewController.tabBarItem.image = UIImage(systemName: "wineglass")
        cocktailViewController.tabBarItem.selectedImage = UIImage(systemName: "face.smiling")
        cocktailViewController.tabBarItem.title = "Alcohol"
        

        let scheduleViewController = createNavigationController(with: MyScheduleViewController())
        scheduleViewController.tabBarItem.image = UIImage(systemName: "list.bullet")
        scheduleViewController.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.indent")
        scheduleViewController.tabBarItem.title = "Schedule"

        let chatViewController = createNavigationController(with: ChatViewController())
        chatViewController.tabBarItem.image = UIImage(systemName: "message")
        chatViewController.tabBarItem.selectedImage = UIImage(systemName: "ellipsis.message.fill")
        chatViewController.tabBarItem.title = "Message"

        let mapHomeViewController = createNavigationController(with: MapHomeViewController())
        mapHomeViewController.tabBarItem.image = UIImage(systemName: "map")
        mapHomeViewController.tabBarItem.selectedImage = UIImage(systemName: "ellipsis")
        mapHomeViewController.tabBarItem.title = "Map"

        let personalViewController = createNavigationController(with: ProfileViewController())
        personalViewController.tabBarItem.image = UIImage(systemName: "person")
        personalViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        personalViewController.tabBarItem.title = "Profile"

        viewControllers = [chatViewController,
                           scheduleViewController,
                           mapHomeViewController,
                           cocktailViewController,
                           personalViewController]

        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.steelPink], for: .selected)
        appearance.scrollEdgeAppearance?.selectionIndicatorTintColor = UIColor.steelPink
        tabBar.tintColor = .steelPink
        appearance.badgeColor = tabBar.tintColor
    }

    private func createNavigationController(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
}
