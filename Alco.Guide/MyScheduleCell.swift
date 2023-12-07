//
//  MyScheduleCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import UIKit

//class MyScheduleCell: UITableViewCell {
//
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.white
//        label.font = UIFont.systemFont(ofSize: 16)
//        return label
//    }()
//
//    // 在初始化方法中設定 cell 的 UI
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCellUI()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupCellUI() {
//        // 添加你的 UI 元素到 cell 上
//        addSubview(titleLabel)
//
//        // 設定 UI 元素的 constraints，這裡使用了 NSLayoutConstraint 的 Anchor
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
//        ])
//    }
//
//    func configure(withTitle title: String) {
//        // 設定 cell 的內容
//        titleLabel.text = title
//    }
//}
