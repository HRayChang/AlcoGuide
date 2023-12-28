//
//  CocktailDetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/11.
//

import Foundation
import UIKit

class CocktailDetailViewController: UIViewController {
    
    var isClassicCocktail: Bool?
    
    var imageView = UIImageView()
    var name = UILabel()
    var recipe = UILabel()
    var introduction = UILabel()
    var ingredientBackground = UIView()
    var plusLabel = UILabel()
    var imageOne = UIImageView()
    var imageTwo = UIImageView()
    
    var labelOne = UILabel()
    var labelTwo = UILabel()
    
    var selectedCocktailData: [String: String] = [:]
    
    let text = "Light Rum\n2 ounces\nLime Juice\n1 ounce\nDemerara Sugar Syrup\n3/4 ounce"
    
    
    override func viewDidLoad() {
        setupViewUI()
        setupConstraints()
    }
    
    func setupViewUI() {
        
        view.backgroundColor = UIColor.black

        name.text = selectedCocktailData.keys.first
        name.textColor = .lilac
        name.textAlignment = .left
        name.numberOfLines = 0
        
        plusLabel.text = ":"
        plusLabel.textColor = .lilac
        plusLabel.font = UIFont(name: "Bradley Hand", size: 50.0)
        plusLabel.textAlignment = .center
        
        labelOne.text = "1"
        labelOne.textColor = .lilac
        labelOne.font = UIFont(name: "Bradley Hand", size: 35.0)
        labelOne.textAlignment = .center
        
        labelTwo.text = "2"
        labelTwo.textColor = .lilac
        labelTwo.font = UIFont(name: "Bradley Hand", size: 35.0)
        labelTwo.textAlignment = .center
        
        imageOne.image = UIImage(named: "whiskey")
        imageOne.contentMode = .scaleAspectFit
        
        imageTwo.image = UIImage(named: "tea")
        imageTwo.contentMode = .scaleAspectFit
        
        ingredientBackground.backgroundColor = .black.withAlphaComponent(0.8)
        ingredientBackground.layer.cornerRadius = 10
        
        ingredientBackground.layer.shadowColor = UIColor.steelPink.cgColor
        ingredientBackground.layer.shadowOpacity = 1
        ingredientBackground.layer.shadowRadius = 10.0
        ingredientBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        
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
                
                font = UIFont(name: "Noteworthy", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
                
            }
            
            // 为每一行设置字体
            let range = (text as NSString).range(of: line)
            attributedString.addAttribute(.font, value: font, range: range)
            
            // 设置行与行之间的上面间距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = index % 2 == 0 ? 2 : 0
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        recipe.attributedText = attributedString
        recipe.textColor = .lilac
        recipe.numberOfLines = 0
        recipe.textAlignment = .right
        
        
        imageView.image = UIImage(named: selectedCocktailData.values.first ?? "")
        
        switch isClassicCocktail! {
        case true:
            recipe.isHidden = false
            imageView.contentMode = .scaleAspectFill
            name.font = UIFont(name: "Zapfino", size: 30.0)
        case false:
                    let gradientLayer = CAGradientLayer()
                       gradientLayer.frame = view.bounds
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.eminence.cgColor]
//                    gradientLayer.locations = [0.6, 1]
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
                       view.layer.insertSublayer(gradientLayer, at: 0)
            
            recipe.isHidden = true
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            name.font = UIFont(name: "Bradley Hand", size: 50.0)
            
            name.layer.shadowColor = UIColor.steelPink.cgColor
            name.layer.shadowOpacity = 1
            name.layer.shadowRadius = 10.0
            name.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
        
    }
    
    func setupConstraints() {
        
        
        name.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        recipe.translatesAutoresizingMaskIntoConstraints = false
        ingredientBackground.translatesAutoresizingMaskIntoConstraints = false
        plusLabel.translatesAutoresizingMaskIntoConstraints = false
        imageOne.translatesAutoresizingMaskIntoConstraints = false
        imageTwo.translatesAutoresizingMaskIntoConstraints = false
        labelOne.translatesAutoresizingMaskIntoConstraints = false
        labelTwo.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(name)
        view.addSubview(recipe)
        view.addSubview(ingredientBackground)
      
        
        switch isClassicCocktail! {
        case true:
            NSLayoutConstraint.activate([
                name.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                name.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/7),
                name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                name.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                recipe.topAnchor.constraint(equalTo: name.bottomAnchor, constant: -20),
                recipe.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                recipe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                imageView.topAnchor.constraint(equalTo: name.bottomAnchor),
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        case false:
            view.addSubview(imageOne)
            view.addSubview(imageTwo)
            view.addSubview(plusLabel)
            view.addSubview(labelOne)
            view.addSubview(labelTwo)
            NSLayoutConstraint.activate([
                name.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                name.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/7),
                name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                name.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                imageView.topAnchor.constraint(equalTo: name.bottomAnchor),
                imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                
                ingredientBackground.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
                ingredientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
                ingredientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                ingredientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                plusLabel.centerXAnchor.constraint(equalTo: ingredientBackground.centerXAnchor),
                plusLabel.centerYAnchor.constraint(equalTo: ingredientBackground.centerYAnchor),
                plusLabel.heightAnchor.constraint(equalTo: ingredientBackground.heightAnchor, multiplier: 1/3),
                plusLabel.widthAnchor.constraint(equalTo: plusLabel.heightAnchor),
                
                imageOne.topAnchor.constraint(equalTo: ingredientBackground.topAnchor, constant: 10),
                imageOne.bottomAnchor.constraint(equalTo: labelOne.topAnchor),
                imageOne.trailingAnchor.constraint(equalTo: plusLabel.leadingAnchor),
                imageOne.leadingAnchor.constraint(equalTo: ingredientBackground.leadingAnchor),
                
                imageTwo.topAnchor.constraint(equalTo: ingredientBackground.topAnchor),
                imageTwo.bottomAnchor.constraint(equalTo: labelTwo.topAnchor),
                imageTwo.leadingAnchor.constraint(equalTo: plusLabel.trailingAnchor),
                imageTwo.trailingAnchor.constraint(equalTo: ingredientBackground.trailingAnchor),
                
                labelOne.centerXAnchor.constraint(equalTo: imageOne.centerXAnchor),
                labelOne.bottomAnchor.constraint(equalTo: ingredientBackground.bottomAnchor, constant: -10),
                labelOne.heightAnchor.constraint(equalTo: ingredientBackground.heightAnchor, multiplier: 1/6),
                
                labelTwo.centerXAnchor.constraint(equalTo: imageTwo.centerXAnchor),
                labelTwo.bottomAnchor.constraint(equalTo: ingredientBackground.bottomAnchor, constant: -10),
                labelTwo.heightAnchor.constraint(equalTo: ingredientBackground.heightAnchor, multiplier: 1/6)
            ])
        }
    }
}
