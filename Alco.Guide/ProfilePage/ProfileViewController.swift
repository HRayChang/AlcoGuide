//
//  PersonalViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit

class ProfileViewController: UIViewController {

    let backgroundView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.black
        
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.eminence.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupConstraints() {

        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
    }
}
