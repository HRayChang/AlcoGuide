//
//  SelectLocationView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/30.
//

import UIKit

protocol SelectLocationViewDelegate: AnyObject {
    func locationButtonTapped(type: LocationType)
}

enum LocationType {
    case convenienceStore
    case bar
    case both
    case none
}

class SelectLocationView: UIView {
    
    let searchConvenienceStoreButton = UIButton()
    let searchBarButton = UIButton()
    let middleLine = UIView()
    
    var isSearchConvenienceStoreViewHidden: Bool = true
    
    var isSearchBarViewHidden: Bool = true
    
    weak var delegate: SelectLocationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectLocationView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update schedule labels

    
    // MARK: Update schedule labels -
    
    private func setupSelectLocationView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.borderColor = UIColor.steelPink.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        
        middleLine.backgroundColor = UIColor.steelPink
        
        searchConvenienceStoreButton.layer.shadowColor = UIColor.lilac.cgColor
        searchConvenienceStoreButton.layer.shadowRadius = 5
        searchConvenienceStoreButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        searchBarButton.layer.shadowColor = UIColor.lilac.cgColor
        searchBarButton.layer.shadowRadius = 5
        searchBarButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        setupButton(searchConvenienceStoreButton, action: #selector(searchConvenienceStoreButtonTapped), backgroundImage: UIImage(named: "basket"))
        setupButton(searchBarButton, action: #selector(searchBarButtonTapped), backgroundImage: UIImage(named: "cocktail"))
      
        searchConvenienceStoreButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        middleLine.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(searchConvenienceStoreButton)
        addSubview(searchBarButton)
        addSubview(middleLine)
        
        NSLayoutConstraint.activate([
            
            searchConvenienceStoreButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7),
            searchConvenienceStoreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7),
            searchConvenienceStoreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
            searchConvenienceStoreButton.heightAnchor.constraint(equalTo: searchConvenienceStoreButton.widthAnchor),

            searchBarButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30),
            searchBarButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7),
            searchBarButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7),
            searchBarButton.heightAnchor.constraint(equalTo: searchBarButton.widthAnchor),
            
            middleLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            middleLine.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            middleLine.widthAnchor.constraint(equalTo: self.widthAnchor),
            middleLine.heightAnchor.constraint(equalToConstant: 1)
            
        ])
    }
    
    private func setupButton(_ button: UIButton, action: Selector, backgroundImage: UIImage?) {
        button.setBackgroundImage(backgroundImage, for: .normal)

        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc private func searchConvenienceStoreButtonTapped() {
        
        isSearchConvenienceStoreViewHidden = !(isSearchConvenienceStoreViewHidden)
        
        if isSearchConvenienceStoreViewHidden == false {
            searchConvenienceStoreButton.layer.shadowOpacity = 1
        } else {
            searchConvenienceStoreButton.layer.shadowOpacity = 0
        }
        
        var locationType: LocationType
        
        switch isSearchConvenienceStoreViewHidden {
        case true:
            switch isSearchBarViewHidden {
            case true:
                locationType = .none
            case false:
                locationType = .bar
            }
        case false:
            switch isSearchBarViewHidden {
            case true:
                locationType = .convenienceStore
            case false:
                locationType = .both
            }
        }
      
        delegate?.locationButtonTapped(type: locationType)
    }
    
    @objc private func searchBarButtonTapped() {
        
        isSearchBarViewHidden = !(isSearchBarViewHidden)
        
        if isSearchBarViewHidden == false {
            searchBarButton.layer.shadowOpacity = 1
        } else {
            searchBarButton.layer.shadowOpacity = 0
        }
        
       
        
        var locationType: LocationType
        
        switch isSearchBarViewHidden {
        case true:
            switch isSearchConvenienceStoreViewHidden {
            case true:
                locationType = .none
            case false:
                locationType = .convenienceStore
            }
        case false:
            switch isSearchConvenienceStoreViewHidden {
            case true:
                locationType = .bar
            case false:
                locationType = .both
            }
        }
        delegate?.locationButtonTapped(type: locationType)
    }
    
 
}
