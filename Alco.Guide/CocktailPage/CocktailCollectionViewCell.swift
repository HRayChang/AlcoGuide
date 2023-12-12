//
//  CocktailCollectionViewCell.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/11.
//

import UIKit

class CocktailCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        //        backgroundColor = .black.withAlphaComponent(0.7)
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 10.0
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        titleLabel.textColor = UIColor.lilac
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage?, title: String) {
  
        imageView.image = image
        titleLabel.text = title
    }
}
