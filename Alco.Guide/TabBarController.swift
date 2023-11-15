//
//  TabBarController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        let cocktailViewController = CocktailViewController()
        let cocktailController = UINavigationController(rootViewController: cocktailViewController)
        
        cocktailController.tabBarItem.image = UIImage(systemName: "heart")
        cocktailController.tabBarItem.title = "Heart"
        
        let scheduleViewController = ScheduleViewController()
        let scheduleController = UINavigationController(rootViewController: scheduleViewController)
        
        scheduleController.tabBarItem.image = UIImage(systemName: "heart")
        scheduleController.tabBarItem.title = "Heart"
        
        let chatViewController = ChatViewController()
        let chatController = UINavigationController(rootViewController: chatViewController)
        
        chatController.tabBarItem.image = UIImage(systemName: "heart")
        chatController.tabBarItem.title = "Heart"
        
        let mapHomeViewController = MapHomeViewController()
        let mapHomeController = UINavigationController(rootViewController: mapHomeViewController)
        
        mapHomeController.tabBarItem.image = UIImage(systemName: "heart")
        mapHomeController.tabBarItem.title = "Heart"
        
        let personalViewController = PersonalViewController()
        let personalController = UINavigationController(rootViewController: personalViewController)
        
        personalController.tabBarItem.image = UIImage(systemName: "heart")
        personalController.tabBarItem.title = "Heart"
        
        viewControllers = [chatController, scheduleController, mapHomeController, cocktailController, personalController]
        
        let appearance = UITabBarItem.appearance()

        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.green], for: .selected)
    }
}
