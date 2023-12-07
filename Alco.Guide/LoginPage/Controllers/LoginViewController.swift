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
    
    var userInfo: UserInfo?
    
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
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("Google Sign-In Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let userGoogleInfo = result?.user,
                  let idToken = userGoogleInfo.idToken?.tokenString
            else {
                print("Missing user information after Google Sign-In")
                return
            }
            
            guard let email = userGoogleInfo.profile?.email,
                  let givenName = userGoogleInfo.profile?.givenName,
                  let familyName = userGoogleInfo.profile?.familyName,
                  let name = userGoogleInfo.profile?.name,
                  let image = userGoogleInfo.profile?.imageURL(withDimension: 200) else { return }
            
            userInfo?.email = email
            userInfo?.familyName = familyName
            userInfo?.givenName = givenName
            userInfo?.image = image
            userInfo?.name = name
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: userGoogleInfo.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                
                if let error = error {
                    print("Firebase Authentication Error: \(error.localizedDescription)")
                    return
                }
                
                if let user = authResult?.user {
                    print("Firebase Authentication Successful for user: \(user.uid)")
                    
                    let userUID = user.uid
                    
                    self.userInfo?.userUID = userUID
                    
                    if let isNewUser = authResult?.additionalUserInfo?.isNewUser, isNewUser {
                        print("New user registered")
      
                        let userData: [String: Any] = [
                            "userUID": userUID,
                            "email": email,
                            "givenName": givenName,
                            "familyName": familyName,
                            "name": name,
                            "image": "\(image)"
                        ]
                         Firestore.firestore().collection("Users").document(user.uid).setData(userData)
                    } else {
                        print("Existing user signed in")
                    }
                
                    let tabBarController = TabBarController()
                    tabBarController.selectedIndex = 2
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                }
            }
        }
    }
    
}
