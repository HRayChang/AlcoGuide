//
//  CocktailDetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/11.
//

import Foundation
import UIKit

class CocktailDetailViewController: UIViewController {
    
    var imageView = UIImageView()
    var name = UILabel()
    var recipe = UILabel()
    var introduction = UILabel()
    
    let text = "Light Rum\n2 ounces\nLime Juice\n1 ounce\nDemerara Sugar Syrup\n3/4 ounce"
    
    
    override func viewDidLoad() {
        setupViewUI()
        setupConstraints()
    }
    
    func setupViewUI() {
        
        view.backgroundColor = UIColor.black
        
        let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.eminence.cgColor, UIColor.steelPink.cgColor,]
        gradientLayer.locations = [0.5, 0.8, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
           view.layer.insertSublayer(gradientLayer, at: 0)
        
        name.text = "Daiquiri"
        name.textColor = .lilac
        name.textAlignment = .left
        name.numberOfLines = 1
        name.font = UIFont(name: "Zapfino", size: 30.0)
        
        let attributedString = NSMutableAttributedString(string: text)

               // 按行分割文本
               let lines = text.components(separatedBy: "\n")

        for (index, line) in lines.enumerated() {
                    var font: UIFont
                    if index % 2 == 0 {
                        // 使用 "New Times Roman" 字体
                        font = UIFont(name: "Bradley Hand", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
                    } else {
                        // 使用系统默认字体
                        
                        font = UIFont(name: "Noteworthy", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
    
                    }

                    // 为每一行设置字体
                    let range = (text as NSString).range(of: line)
                    attributedString.addAttribute(.font, value: font, range: range)

                    // 设置行与行之间的上面间距
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = index % 2 == 0 ? 3.0 : 5
                    attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
                }

               recipe.attributedText = attributedString
        recipe.textColor = .lilac
        recipe.numberOfLines = 0
        recipe.textAlignment = .right
              
        
        imageView.image = UIImage(named: "11")
        imageView.contentMode = .scaleAspectFit

    }
    
    func setupConstraints() {
        
        name.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        recipe.translatesAutoresizingMaskIntoConstraints = false
       
        
        view.addSubview(imageView)
        view.addSubview(name)
        view.addSubview(recipe)
 
        
        NSLayoutConstraint.activate([
            
            name.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            name.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/7),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            recipe.topAnchor.constraint(equalTo: name.bottomAnchor, constant: -20),
         
            recipe.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
