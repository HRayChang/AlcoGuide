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
//        let cocktailController = UINavigationController(rootViewController: cocktailViewController)
        
        cocktailViewController.tabBarItem.image = UIImage(systemName: "heart")
        cocktailViewController.tabBarItem.title = "Heart"
        
        let scheduleViewController = ScheduleViewController()
//        let scheduleController = UINavigationController(rootViewController: scheduleViewController)
        
        scheduleViewController.tabBarItem.image = UIImage(systemName: "heart")
        scheduleViewController.tabBarItem.title = "Heart"
        
        let chatViewController = ChatViewController()
//        let chatController = UINavigationController(rootViewController: chatViewController)
        
        chatViewController.tabBarItem.image = UIImage(systemName: "heart")
        chatViewController.tabBarItem.title = "Heart"
        
        let mapHomeViewController = MapHomeViewController()
//        let mapHomeController = UINavigationController(rootViewController: mapHomeViewController)
        
        mapHomeViewController.tabBarItem.image = UIImage(systemName: "heart")
        mapHomeViewController.tabBarItem.title = "Heart"
        
        let personalViewController = PersonalViewController()
//        let personalController = UINavigationController(rootViewController: personalViewController)
        
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
}
