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
        
        view.backgroundColor = .black
        
        let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.eminence.withAlphaComponent(0.6).cgColor, UIColor.steelPink.withAlphaComponent(0.6).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

           view.layer.insertSublayer(gradientLayer, at: 0)
        
        logo.text = "Alco.Guide"
        logo.textColor = UIColor.lightPink
        logo.font = UIFont(name: "Georgia", size: 65.0)
        logo.layer.shadowColor = UIColor.lilac.cgColor
        logo.textAlignment = .center
        logo.layer.shadowOpacity = 1
        logo.layer.shadowRadius = 3.0
        logo.layer.shadowOffset = CGSize(width: 0, height: 0)
        logo.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 700)
        
//        let darkTextLabel = UILabel()
//                      darkTextLabel.text = "Alco.Guide"
//                      darkTextLabel.textColor = UIColor(white: 1, alpha: 1)
//                      darkTextLabel.font = UIFont(name: "Georgia", size: 65.0)
//                      darkTextLabel.textAlignment = .center
//                      darkTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1400)
//      
        
//                let darkTextLabel = UILabel()
//                darkTextLabel.text = "Alco.Guide"
//                darkTextLabel.textColor = UIColor(white: 1, alpha: 1)
//                darkTextLabel.font = UIFont.systemFont(ofSize: 80)
//                darkTextLabel.textAlignment = .center
//                darkTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        
//                let shinyTextLabel = UILabel()
//                shinyTextLabel.text = "Alco.Guide"
//        shinyTextLabel.textColor = .steelPink
//                shinyTextLabel.font = UIFont.systemFont(ofSize: 80)
//                shinyTextLabel.textAlignment = .center
//                shinyTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.borderWidth = 3.0
        loginButton.layer.borderColor = UIColor.lilac.cgColor
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.backgroundColor = UIColor.steelPink.cgColor
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.isHidden = true
        
        googleLoginButton.colorScheme = .light
        googleLoginButton.style = .wide
        googleLoginButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        googleLoginButton.alpha = 0.8
        
        view.addSubview(loginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(logo)
//        view.addSubview(shinyTextLabel)
        
        
        let gradient = CAGradientLayer()
        
                gradient.frame = logo.frame
                gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor,UIColor.clear.cgColor]
                gradient.locations = [0.1, 0.5, 0.9]
                let angle = -60 * CGFloat.pi / 180
                gradient.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
                logo.layer.mask = gradient
        
        
                let animation = CABasicAnimation(keyPath: "transform.translation.x")
                animation.duration = 8
                animation.repeatCount = Float.infinity
                animation.autoreverses = false
                animation.fromValue = -view.frame.width - 100
                animation.toValue = view.frame.width + 100
                animation.isRemovedOnCompletion = false
                animation.fillMode = CAMediaTimingFillMode.forwards
        gradient.add(animation, forKey: "shimmerKey")
        
//        logo.translatesAutoresizingMaskIntoConstraints = false
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
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90),
            
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
                    let tabBarController = TabBarController()
                    
                    tabBarController.selectedIndex = 2
                    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    navigationController?.pushViewController(tabBarController, animated: true)
                }
            }
        }
}

//import UIKit
//
//class LoginViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
//        let darkTextLabel = UILabel()
//        darkTextLabel.text = "Shimmer"
//        darkTextLabel.textColor = UIColor(white: 1, alpha: 1)
//        darkTextLabel.font = UIFont.systemFont(ofSize: 80)
//        darkTextLabel.textAlignment = .center
//        darkTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
//        
//        let shinyTextLabel = UILabel()
//        shinyTextLabel.text = "Shimmer"
//        shinyTextLabel.textColor = .white
//        shinyTextLabel.font = UIFont.systemFont(ofSize: 80)
//        shinyTextLabel.textAlignment = .center
//        shinyTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
//        
//        view.addSubview(shinyTextLabel)
//        
//        let gradient = CAGradientLayer()
//        
//        gradient.frame = shinyTextLabel.frame
//        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor,UIColor.clear.cgColor]
//        gradient.locations = [0.0, 0.5, 1.0]
//        let angle = -60 * CGFloat.pi / 180
//        gradient.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
//
//        shinyTextLabel.layer.mask = gradient
//        
//        
//        let animation = CABasicAnimation(keyPath: "transform.translation.x")
//        animation.duration = 2
//        animation.repeatCount = Float.infinity
//        animation.autoreverses = false
//        animation.fromValue = -view.frame.width
//        animation.toValue = view.frame.width
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = CAMediaTimingFillMode.forwards
//
//        gradient.add(animation, forKey: "shimmerKey")
//        
//    }
//
//
//}

