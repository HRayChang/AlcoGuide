//
//  PersonalViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit

class ProfileViewController: UIViewController {

    let backgroundView = ConcaveView()
    let nameLabel = UILabel()
    let gameButton = UIButton()
    let sosButton = UIButton()
    let logoutButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBreathingAnimation(to: backgroundView.circleView)
        addShadowColorAnimation(to: backgroundView.circleView)
    }
    
    func setupViewUI() {
        
        nameLabel.text = "Ray Chang"
        nameLabel.textColor = .lilac
        nameLabel.textAlignment = .right
        nameLabel.font = UIFont(name: "Marker Felt Wide", size: 50)
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOpacity = 1
        nameLabel.layer.shadowRadius = 5.0
        nameLabel.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        gameButton.setBackgroundImage(UIImage(named: "poker"), for: .normal)
        sosButton.setBackgroundImage(UIImage(named: "sos"), for: .normal)
        logoutButton.setBackgroundImage(UIImage(named: "logout"), for: .normal)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.steelPink.cgColor, UIColor.eminence.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0, 0.4, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            view.layer.insertSublayer(gradientLayer, at: 0)
        
        backgroundView.backgroundColor = UIColor.clear
        
        backgroundView.frame = CGRect(x: 50, y: 50, width: 200, height: 200)

        
    }
    
    func setupConstraints() {

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        gameButton.translatesAutoresizingMaskIntoConstraints = false
        sosButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        view.addSubview(nameLabel)
        view.addSubview(gameButton)
        view.addSubview(sosButton)
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sosButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sosButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            logoutButton.leadingAnchor.constraint(equalTo: sosButton.trailingAnchor, constant: 40),
            logoutButton.centerYAnchor.constraint(equalTo: sosButton.centerYAnchor),
            
            gameButton.trailingAnchor.constraint(equalTo: sosButton.leadingAnchor, constant: -40),
            gameButton.centerYAnchor.constraint(equalTo: sosButton.centerYAnchor)
            

        ])
    }
    
    func addBreathingAnimation(to view: UIView) {
        let breathingAnimation = CABasicAnimation(keyPath: "shadowRadius")
        breathingAnimation.fromValue = 10
        breathingAnimation.toValue = 30
        breathingAnimation.autoreverses = true
        breathingAnimation.duration = 3
        breathingAnimation.repeatCount = .infinity
        view.layer.add(breathingAnimation, forKey: "breathingAnimation")
    }
    
    func addShadowColorAnimation(to view: UIView) {
        
            let animation = CABasicAnimation(keyPath: "shadowColor")
            animation.fromValue = UIColor.steelPink.cgColor
        animation.toValue = UIColor.lilac.cgColor
            animation.duration = 6.0 // Set the duration of the animation
            animation.autoreverses = true // Make the animation reverse (optional)
            animation.repeatCount = .infinity // Repeat the animation indefinitely (optional)
            
            view.layer.add(animation, forKey: "shadowColorAnimation")
        }
    
}
