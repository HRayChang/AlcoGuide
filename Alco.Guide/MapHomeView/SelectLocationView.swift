//
//  SelectLocationView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/16.
//

import UIKit

protocol SelectLocationViewDelegate: AnyObject {
    func convenienceStoreButtonTapped()
    func barButtonTapped()
    func bothButtonTapped()
}

class SelectLocationView: UIView {

    let scheduleLabel = UILabel()
    let scheduleIDLabel = UILabel()
    let searchConvenienceStoreButton = UIButton()
    let searchBarButton = UIButton()
    let searchBothButton = UIButton()
    
    weak var delegate: SelectLocationViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectLocationView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSelectLocationView()
    }

    private func setupSelectLocationView() {
        backgroundColor = UIColor.black
        layer.borderColor = UIColor.steelPink.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 30
        isHidden = true

        scheduleLabel.textColor = UIColor.white

        scheduleIDLabel.textColor = UIColor.white

        setupButton(searchConvenienceStoreButton, title: "超商", action: #selector(convenienceStoreButtonTapped))
        setupButton(searchBarButton, title: "酒吧", action: #selector(barButtonTapped))
        setupButton(searchBothButton, title: "Both", action: #selector(bothButtonTapped))

        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleIDLabel.translatesAutoresizingMaskIntoConstraints = false
        searchConvenienceStoreButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        searchBothButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scheduleLabel)
        addSubview(scheduleIDLabel)
        addSubview(searchConvenienceStoreButton)
        addSubview(searchBarButton)
        addSubview(searchBothButton)

        NSLayoutConstraint.activate([
            scheduleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchConvenienceStoreButton.trailingAnchor.constraint(equalTo: searchBarButton.leadingAnchor, constant: -10),
            searchConvenienceStoreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchConvenienceStoreButton.widthAnchor.constraint(equalToConstant: 80),
            searchConvenienceStoreButton.heightAnchor.constraint(equalToConstant: 50),
            searchBarButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchBarButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBarButton.widthAnchor.constraint(equalToConstant: 80),
            searchBarButton.heightAnchor.constraint(equalToConstant: 50),
            searchBothButton.leadingAnchor.constraint(equalTo: searchBarButton.trailingAnchor, constant: 10),
            searchBothButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBothButton.widthAnchor.constraint(equalToConstant: 80),
            searchBothButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupButton(_ button: UIButton, title: String, action: Selector) {
        button.backgroundColor = UIColor.black
        button.layer.borderColor = UIColor.steelPink.cgColor
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 20
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc private func convenienceStoreButtonTapped() {
          delegate?.convenienceStoreButtonTapped()
      }

      @objc private func barButtonTapped() {
          delegate?.barButtonTapped()
      }

      @objc private func bothButtonTapped() {
          delegate?.bothButtonTapped()
      }
}
