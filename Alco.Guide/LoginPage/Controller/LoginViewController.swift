//
//  LoginViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    let loginButton = UIButton()
    let googleLoginButton = GIDSignInButton()
    let logo = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        LoginManager.shared.configureGoogleSignIn()
        setupLoginViewUI()
    }
    
    func setupLoginViewUI() {
        
        let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.eminence.cgColor, UIColor.steelPink.cgColor, UIColor.lilac.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

           view.layer.insertSublayer(gradientLayer, at: 0)
        
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
            googleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
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
            LoginManager.shared.signInWithGoogle(presentingViewController: self) { [weak self] userInfo, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error signing in with Google: \(error.localizedDescription)")
                    // Handle the error as needed
                } else  {
                    // Continue with any additional logic after successful login
                    let tabBarController = TabBarController()
                    
                    tabBarController.selectedIndex = 2
                    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    navigationController?.pushViewController(tabBarController, animated: true)
                }
            }
        }
}
