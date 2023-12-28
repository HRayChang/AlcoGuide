//
//  LoginViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import SnapKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    let loginViewModel = LoginViewModel()
    
    let loginButton = UIButton()
    let googleLoginButton = GIDSignInButton()
    let logo = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginManager.shared.configureGoogleSignIn()
        
        setupLoginViewUI()
        setupConstraints()
    }
    
    private func setupLoginViewUI() {
        
        view.backgroundColor = .black
        
        view.addGradientBackground(colors: [UIColor.black.withAlphaComponent(0.6).cgColor,
                                            UIColor.eminence.withAlphaComponent(0.6).cgColor,
                                            UIColor.steelPink.withAlphaComponent(0.6).cgColor],
                                   startPoint: CGPoint(x: 0, y: 0),
                                   endPoint: CGPoint(x: 1, y: 1))
        
        logo.setupLogo(logo: "Alco.Guide")
        logo.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 700)
        logo.addShimmerAnimation(to: logo)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.borderWidth = 3.0
        loginButton.layer.borderColor = UIColor.lilac.cgColor
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.backgroundColor = UIColor.steelPink.cgColor
        loginButton.isHidden = false
        
        googleLoginButton.colorScheme = .light
        googleLoginButton.style = .wide
        googleLoginButton.alpha = 0.8
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        
        view.addSubview(loginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(logo)
    }
    
    private func setupConstraints() {
        
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
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90)
            
        ])
    }
    
    @objc func loginButtonTapped() {
        
        let tabBarController = TabBarController()
        tabBarController.selectedIndex = 2
        navigationController?.pushViewController(tabBarController, animated: true)
        
    }
    
    @objc func googleSignIn(sender: Any) {
        
        loginViewModel.signInWithGoogle(presentingViewController: self) { [weak self] userInfo, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error signing in with Google: \(error.localizedDescription)")
            } else {
                let tabBarController = TabBarController()
                tabBarController.selectedIndex = 2
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }
    }
}
