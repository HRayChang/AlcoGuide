//
//  MyScheduleDetailButtonTableViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/20.
//

import UIKit

class MyScheduleDetailButtonTableViewCell: UITableViewCell {
    
    var locationName: String?
    
    let addActivityButton = UIButton()
    let addActivityTextField = UITextField()
    let sendButton = UIButton()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMyScheduleDetailButtonTableViewCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMyScheduleDetailButtonTableViewCellUI()
    }
    
    private func setupMyScheduleDetailButtonTableViewCellUI() {
        
        contentView.backgroundColor = UIColor.black
        
        addActivityButton.setTitle("新增活動", for: .normal)
        addActivityButton.setTitleColor(.white, for: .normal)
        addActivityButton.layer.borderColor = UIColor.steelPink.cgColor
        addActivityButton.layer.borderWidth = 5
        addActivityButton.layer.cornerRadius = 10
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: addActivityTextField.frame.height))
        addActivityTextField.leftView = leftPaddingView
        addActivityTextField.leftViewMode = .always
        
        addActivityTextField.placeholder = "Enter text"
        addActivityTextField.textColor = UIColor.white
        addActivityTextField.layer.borderColor = UIColor.steelPink.cgColor
        addActivityTextField.layer.borderWidth = 3
        addActivityTextField.layer.cornerRadius = 10
        addActivityTextField.isHidden = true
        
        sendButton.setTitle("新增", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.borderColor = UIColor.steelPink.cgColor
        sendButton.layer.borderWidth = 5
        sendButton.layer.cornerRadius = 10
        sendButton.isHidden = true
        
        contentView.addSubview(addActivityButton)
        contentView.addSubview(addActivityTextField)
        contentView.addSubview(sendButton)
        
        addActivityButton.translatesAutoresizingMaskIntoConstraints = false
        addActivityTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addActivityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            addActivityButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addActivityButton.widthAnchor.constraint(equalToConstant: 100),
            
            addActivityTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            addActivityTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            addActivityTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addActivityTextField.heightAnchor.constraint(equalTo: sendButton.heightAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            sendButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        addActivityButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        addActivityButton.isHidden = true
        addActivityTextField.isHidden = false
        sendButton.isHidden = false
    }
    
    @objc private func sendButtonTapped() {
        guard let text = addActivityTextField.text, !text.isEmpty else {
            // Handle the case when the textField is empty
            return
        }
        
        // Replace 'YourFirestoreReference' with the actual path to your Firestore data
        let scheduleID = CurrentSchedule.currentScheduleID
        
        DataManager.shared.addActivities(scheduleID: scheduleID!, locationName: locationName!, text: text) { error in
            if let error = error {
                print("Error updating activities in Firestore: \(error)")
            } else {
                print("Activities successfully updated in Firestore")
            }
        }
        // Hide the text field and send button after sending the data
        addActivityButton.isHidden = false
        addActivityTextField.isHidden = true
        sendButton.isHidden = true
        addActivityTextField.text = nil // Clear the text field
    }
}
