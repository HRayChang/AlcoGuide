//
//  ChatViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SendTextViewDelegate, MessageManagerDelegate, UITextFieldDelegate {

    let backgroundView = UIView()
    let chatTableView = UITableView()
    let sendTextView = SendTextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        chatTableView.delegate = self
        chatTableView.dataSource = self

        sendTextView.delegate = self
        MessageManager.shared.delegate = self
        sendTextView.textField.delegate = self

        IQKeyboardManager.shared.enable = true
        
        chatTableView.register(ChatMessageCell.self, forCellReuseIdentifier: "id")

        setupChatViewUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MessageManager.shared.messagesObserver()
        chatTableView.reloadData()
        navigationItem.title = DataManager.CurrentSchedule.currentScheduleName ?? "Message"
        tabBarController?.tabBar.backgroundColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundView.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.eminence.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//        tabBarController?.tabBar.backgroundColor = .clear
//    }

    func setupChatViewUI() {
        
         view.backgroundColor = UIColor.black
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lilac]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        chatTableView.backgroundColor = .clear
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        chatTableView.transform = CGAffineTransform(rotationAngle: (-.pi))
    }

    func setupConstraints() {
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        sendTextView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        view.addSubview(chatTableView)
        view.addSubview(sendTextView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: sendTextView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: sendTextView.topAnchor),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            sendTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sendTextView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
//        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
//        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
        setNeedsStatusBarAppearanceUpdate()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MessageManager.shared.chatMessages.count
    }
    
    class DateHeaderLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .eminence
            textColor = .lilac
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let width = originalContentSize.width + 30
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: width, height: height)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerLabel = DateHeaderLabel()
        let headerView = UIView()
        
        headerView.transform = CGAffineTransform(rotationAngle: (-.pi))
        
        if let firstMessageInSection = MessageManager.shared.chatMessages[section].first {
            let
            dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: firstMessageInSection.time)
            
            headerLabel.text = dateString
                headerLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
            headerView.layer.shadowColor = UIColor.steelPink.cgColor
            headerView.layer.shadowOpacity = 1
            headerView.layer.shadowRadius = 5.0
            headerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            headerView.addSubview(headerLabel)
            
            NSLayoutConstraint.activate([
                headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageManager.shared.chatMessages[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as? ChatMessageCell else {
            return UITableViewCell()
        }
        
        cell.transform = CGAffineTransform(rotationAngle: (-.pi))
        
        let chatMessage = MessageManager.shared.chatMessages[indexPath.section][indexPath.row]
        
//        cell.messageLabel.text = chatMessage.text
//        cell.isIncoming = chatMessage.isIncoming
        
        cell.chatMessage = chatMessage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       

    }
    
    func didTapSendButton(withText text: String) {
        
//        tabBarController?.tabBar.isHidden = false
        
        let newMessage: ChatMessage = {
            let userName = LoginManager.shared.userInfo?.name ?? ""
            let userUID = LoginManager.shared.userInfo?.userUID ?? ""
            let userImage = LoginManager.shared.userInfo?.image
            let time = Date()

            return ChatMessage(content: text, userName: userName, userUID: userUID, userImage: userImage!, time: time)
        }()
        
        MessageManager.shared.sendMessage(newMessage: newMessage)
        
//        if MessageManager.shared.chatMessages.isEmpty {
//            MessageManager.shared.chatMessages.append([ChatMessage]())
//        }
//
//        MessageManager.shared.chatMessages[0].insert(newMessage, at: 0)
        
//        chatTableView.beginUpdates()
//        
//        if chatTableView.numberOfSections == 0 {
//            chatTableView.insertSections(IndexSet(integer: 0), with: .none)
//        }
//        
//        let indexPath = IndexPath(row: 0, section: 0)
//        
//        chatTableView.insertRows(at: [indexPath], with: .automatic)
//        chatTableView.endUpdates()

       
    }
    
    func messageManager(_ manager: MessageManager, didAddNewMessage newMessage: ChatMessage) {
//             Call your updateTableView function or perform any actions needed when a new message is added
//        chatTableView.beginUpdates()
//
//               if MessageManager.shared.chatMessages.isEmpty {
//                   MessageManager.shared.chatMessages.append([ChatMessage]())
//                   chatTableView.insertSections(IndexSet(integer: 0), with: .none)
//               }
//
//               MessageManager.shared.chatMessages[0].insert(newMessage, at: 0)
//
//               let indexPath = IndexPath(row: 0, section: 0)
//               chatTableView.insertRows(at: [indexPath], with: .automatic)
//
//               chatTableView.endUpdates()
        chatTableView.reloadData()
        }

    func textFieldDidBeginEditing(_ textField: UITextField) {
           // Hide the tab bar when the text field begins editing
           tabBarController?.tabBar.isHidden = true
        backgroundView.isHidden = true
        
       }

       // Add the textFieldDidEndEditing method if needed
       func textFieldDidEndEditing(_ textField: UITextField) {
           // Show the tab bar when the text field ends editing
           tabBarController?.tabBar.isHidden = false
           backgroundView.isHidden = false
       }
    
}

