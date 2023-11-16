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
        
        cocktailViewController.tabBarItem.image = UIImage(systemName: "heart")
        cocktailViewController.tabBarItem.title = "Heart"
        
        let scheduleViewController = ScheduleViewController()
        
        scheduleViewController.tabBarItem.image = UIImage(systemName: "heart")
        scheduleViewController.tabBarItem.title = "Heart"
        
        let chatViewController = ChatViewController()
        
        chatViewController.tabBarItem.image = UIImage(systemName: "heart")
        chatViewController.tabBarItem.title = "Heart"
        
        let mapHomeViewController = MapHomeViewController()
        
        mapHomeViewController.tabBarItem.image = UIImage(systemName: "heart")
        mapHomeViewController.tabBarItem.title = "Heart"
        
        let personalViewController = PersonalViewController()
        
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
