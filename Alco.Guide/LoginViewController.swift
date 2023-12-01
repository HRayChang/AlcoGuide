//
//  LoginViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    let loginButton = UIButton()
    let googleLoginButton = GIDSignInButton()
    let logo = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setupLoginViewUI()
    }
    
    func setupLoginViewUI() {
        
        logo.text = "Alco.Guide"
        logo.textColor = UIColor.steelPink
        logo.font = UIFont.systemFont(ofSize: 70)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.borderWidth = 3.0
        loginButton.layer.borderColor = UIColor.lilac.cgColor
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.backgroundColor = UIColor.steelPink.cgColor
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        googleLoginButton.colorScheme = .light
        googleLoginButton.style = .wide
        googleLoginButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        
        view.addSubview(loginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(logo)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            googleLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
        ])
    }
    
    @objc func loginButtonTapped() {
        let tabBarController = TabBarController()
        
        tabBarController.selectedIndex = 2
        
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    @objc func googleSignIn(sender: Any) {
      GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
        guard error == nil else { return }

        // If sign in succeeded, display the app's main content View.
      }
    }
}
