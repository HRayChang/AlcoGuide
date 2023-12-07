//
//  SelectScheduleView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit

protocol SelectScheduleViewDelegate: AnyObject {
    func showAddNewScheduleView()
    func showJoinScheduleView()
    func showMyScheduleView()
}

class SelectScheduleView: UIView {
    
    weak var delegate: SelectScheduleViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectScheduleView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSelectScheduleView()
    }

    private func setupSelectScheduleView() {
        backgroundColor = UIColor.black
        layer.borderColor = UIColor.steelPink.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 30
        isHidden = true

        let newScheduleButton = createButton(title: "新增行程", action: #selector(showAddNewScheduleView))
        let addScheduleButton = createButton(title: "加入行程", action: #selector(showJoinScheduleView))
        let myScheduleButton = createButton(title: "我的行程", action: #selector(showMyScheduleView))

        newScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        addScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        myScheduleButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(newScheduleButton)
        addSubview(addScheduleButton)
        addSubview(myScheduleButton)

        NSLayoutConstraint.activate([
            newScheduleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            newScheduleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            newScheduleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -70),
            newScheduleButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/7),
            
            addScheduleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            addScheduleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            addScheduleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addScheduleButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/7),
            
            myScheduleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            myScheduleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            myScheduleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 70),
            myScheduleButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/7)
        ])
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.layer.borderColor = UIColor.steelPink.cgColor
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 20
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func showAddNewScheduleView() {
        delegate?.showAddNewScheduleView()
    }

    @objc private func showJoinScheduleView() {
        delegate?.showJoinScheduleView()
    }

    @objc private func showMyScheduleView() {
        delegate?.showMyScheduleView()
    }
}
