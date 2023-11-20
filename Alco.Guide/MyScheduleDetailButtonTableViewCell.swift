//
//  MyScheduleDetailButtonTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/20.
//

import UIKit

class MyScheduleDetailButtonTableViewCell: UITableViewCell {
    
    var locationName: String?

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap me", for: .normal)
        return button
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter text"
        textField.isHidden = true
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.isHidden = true
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(button)
        contentView.addSubview(textField)
        contentView.addSubview(sendButton)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            sendButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sendButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        button.isHidden = true
        textField.isHidden = false
        sendButton.isHidden = false
    }
    
    @objc private func sendButtonTapped() {
         guard let text = textField.text, !text.isEmpty else {
             // Handle the case when the textField is empty
             return
         }

         // Replace 'YourFirestoreReference' with the actual path to your Firestore data
        let scheduleID = CurrentSchedule.currentScheduleID
         
        LocationDataManager.shared.addActivities(scheduleID: scheduleID!, locationName: locationName!, text: text) { error in
            if let error = error {
                print("Error updating activities in Firestore: \(error)")
            } else {
                print("Activities successfully updated in Firestore")
            }
        }
         // Hide the text field and send button after sending the data
         button.isHidden = false
         textField.isHidden = true
         sendButton.isHidden = true
         textField.text = nil // Clear the text field
     }
}
