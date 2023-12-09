//
//  ChatMessageCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/8.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let bubbleBackground = UIView()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet {
            bubbleBackground.layer.shadowColor = chatMessage.userUID == LoginManager.shared.userInfo?.userUID ? UIColor.steelPink.cgColor : UIColor.lightPink.cgColor
            
            messageLabel.text = chatMessage.content
            
            if chatMessage.userUID != LoginManager.shared.userInfo?.userUID {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
//    var isIncoming: Bool! {
//        didSet {
//            bubbleBackground.layer.shadowColor = isIncoming ? UIColor.steelPink.cgColor : UIColor.green.cgColor
//        }
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = .clear
        addSubview(messageLabel)
        messageLabel.backgroundColor = .clear
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .lilac
        messageLabel.font.withSize(18)
        
        bubbleBackground.backgroundColor = .black.withAlphaComponent(0.8)
        bubbleBackground.layer.cornerRadius = 10
        bubbleBackground.layer.shadowColor = UIColor.steelPink.cgColor
        bubbleBackground.layer.shadowOpacity = 1
        bubbleBackground.layer.shadowRadius = 5.0
        bubbleBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackground.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bubbleBackground)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 3/5),
            
            bubbleBackground.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackground.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackground.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackground.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
        ])
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
