//
//  ChatViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit

class ChatViewController: UIViewController {

    let chatTableView = UITableView()
    let sendTextView = SendTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setupChatViewUI()
        setupConstraints()
    }

    func setupChatViewUI() {
        
        let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.eminence.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

           chatTableView.layer.insertSublayer(gradientLayer, at: 0)
        
        chatTableView.backgroundColor = .black
    }
    
    func setupConstraints() {
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        sendTextView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(chatTableView)
        view.addSubview(sendTextView)
        
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: sendTextView.topAnchor),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sendTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sendTextView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }

}
