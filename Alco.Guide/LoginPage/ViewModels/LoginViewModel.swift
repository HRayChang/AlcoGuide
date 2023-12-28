//
//  LoginViewModel.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/25.
//

import Foundation
import GoogleSignIn

class LoginViewModel {
    func configureGoogleSignIn() {
        LoginManager.shared.configureGoogleSignIn()
    }

    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (User?, Error?) -> Void) {
        LoginManager.shared.signInWithGoogle(presentingViewController: presentingViewController, completion: completion)
    }
}
