//
//  UILabel+Extension.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/25.
//

import UIKit

extension UILabel {
    func setupLogo(logo: String) {
        self.text = logo
        self.textColor = UIColor.lightPink
        self.font = UIFont(name: "Georgia", size: 65.0)
        self.layer.shadowColor = UIColor.lilac.cgColor
        self.textAlignment = .center
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
