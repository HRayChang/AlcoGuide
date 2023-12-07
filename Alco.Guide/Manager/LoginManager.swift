//
//  LoginManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/7.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class LoginManager {
    
    var userInfo: UserInfo?
    
    static let shared = LoginManager()
    
    private init() {}
    
    func configureGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (UserInfo?, Error?) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            guard let self = self else { return }
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let userGoogleInfo = result?.user,
                  let idToken = userGoogleInfo.idToken?.tokenString
            else {
                completion(nil, NSError(domain: "GoogleSignIn", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing user information after Google Sign-In"]))
                return
            }
            
            guard let email = userGoogleInfo.profile?.email,
                  let givenName = userGoogleInfo.profile?.givenName,
                  let familyName = userGoogleInfo.profile?.familyName,
                  let name = userGoogleInfo.profile?.name,
                  let image = userGoogleInfo.profile?.imageURL(withDimension: 200) else {
                    completion(nil, NSError(domain: "GoogleSignIn", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing user information"]))
                    return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: userGoogleInfo.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let user = authResult?.user {
                    let userUID = user.uid
                    self.userInfo = UserInfo(userUID: userUID, email: email, familyName: familyName, givenName: givenName, name: name, image: image)
                    
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
                    
                    completion(self.userInfo, nil)
                }
            }
        }
    }
}
