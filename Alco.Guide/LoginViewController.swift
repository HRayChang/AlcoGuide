//
//  LoginViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setupLoginButton()
    }
    
    func setupLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.borderWidth = 3.0
        loginButton.layer.borderColor = UIColor.lilac.cgColor
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.backgroundColor = UIColor.steelPink.cgColor
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3)
        ])
    }
    
    @objc func loginButtonTapped() {
        let tabBarController = TabBarController()
        
        tabBarController.selectedIndex = 2
        
        navigationController?.pushViewController(tabBarController, animated: true)
    }
}
