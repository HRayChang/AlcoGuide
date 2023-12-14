//
//  ButtonView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/11.
//

import Foundation
import UIKit

class ButtonView: UIView {
    
    let classicCocktailsButton = UIButton()
    let modernCocktailsButton = UIButton()
    let selectedButtonLine = UIView()
    let buttonLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectLocationView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSelectLocationView() {
        backgroundColor = UIColor.clear
        
        selectedButtonLine.backgroundColor = UIColor.steelPink
        selectedButtonLine.layer.shadowColor = UIColor.steelPink.cgColor
        selectedButtonLine.layer.shadowOpacity = 1
        selectedButtonLine.layer.shadowRadius = 3
        selectedButtonLine.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        buttonLine.backgroundColor = UIColor.eminence.withAlphaComponent(0.7)
        
        classicCocktailsButton.backgroundColor = .clear
        classicCocktailsButton.setTitle("Classic", for: .normal)
        classicCocktailsButton.setTitleColor(.steelPink, for: .normal)
        
        modernCocktailsButton.backgroundColor = .clear
        modernCocktailsButton.setTitle("Modern", for: .normal)
        modernCocktailsButton.setTitleColor(.eminence, for: .normal)
        
//        classicCocktailsButton.addTarget(self, action: #selector(classicCocktailsButtonTapped), for: .touchUpInside)
//        modernCocktailsButton.addTarget(self, action: #selector(modernCocktailsButtonTapped), for: .touchUpInside)

        
        selectedButtonLine.translatesAutoresizingMaskIntoConstraints = false
        buttonLine.translatesAutoresizingMaskIntoConstraints = false
        classicCocktailsButton.translatesAutoresizingMaskIntoConstraints = false
        modernCocktailsButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(selectedButtonLine)
        addSubview(buttonLine)
        addSubview(classicCocktailsButton)
        addSubview(modernCocktailsButton)
        
        NSLayoutConstraint.activate([
            classicCocktailsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            classicCocktailsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            classicCocktailsButton.trailingAnchor.constraint(equalTo: self.centerXAnchor),
            
            modernCocktailsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            modernCocktailsButton.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            modernCocktailsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            selectedButtonLine.bottomAnchor.constraint(equalTo: classicCocktailsButton.bottomAnchor),
            selectedButtonLine.widthAnchor.constraint(equalTo: classicCocktailsButton.widthAnchor),
            selectedButtonLine.heightAnchor.constraint(equalToConstant: 3),
            
            buttonLine.bottomAnchor.constraint(equalTo: classicCocktailsButton.bottomAnchor),
            buttonLine.widthAnchor.constraint(equalTo: self.widthAnchor),
            buttonLine.heightAnchor.constraint(equalToConstant: 3),
        ])
    }
    
}
