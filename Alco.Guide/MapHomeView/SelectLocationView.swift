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
    @objc let searchConvenienceStoreButtonTappedView = UIView()
    @objc let searchBarButtonTappedView = UIView()
    
    var isSearchConvenienceStoreViewHidden: Bool = true {
          didSet {
              searchConvenienceStoreButtonTappedView.isHidden = isSearchConvenienceStoreViewHidden
          }
      }
    
    var isSearchBarViewHidden: Bool = true {
        didSet {
            searchBarButtonTappedView.isHidden = isSearchBarViewHidden
        }
    }
    
    weak var delegate: SelectLocationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectLocationView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSelectLocationView()
    }
    
    // MARK: - Update schedule labels

    
    // MARK: Update schedule labels -
    
    private func setupSelectLocationView() {
        backgroundColor = UIColor.black
        layer.borderColor = UIColor.steelPink.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
        
        middleLine.backgroundColor = UIColor.steelPink
        
        searchConvenienceStoreButtonTappedView.backgroundColor = UIColor.lilac
        searchConvenienceStoreButtonTappedView.layer.cornerRadius = 10
        searchConvenienceStoreButtonTappedView.isHidden = isSearchConvenienceStoreViewHidden
        
        searchBarButtonTappedView.backgroundColor = UIColor.lilac
       searchBarButtonTappedView.layer.cornerRadius = 10
        searchBarButtonTappedView.isHidden = isSearchBarViewHidden
        
        setupButton(searchConvenienceStoreButton, action: #selector(searchConvenienceStoreButtonTapped), backgroundImage: UIImage(named: "basket"))
        setupButton(searchBarButton, action: #selector(searchBarButtonTapped), backgroundImage: UIImage(named: "cocktail"))
      
        searchConvenienceStoreButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        middleLine.translatesAutoresizingMaskIntoConstraints = false
        searchBarButtonTappedView.translatesAutoresizingMaskIntoConstraints = false
        searchConvenienceStoreButtonTappedView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(searchBarButtonTappedView)
        addSubview(searchConvenienceStoreButtonTappedView)
        addSubview(searchConvenienceStoreButton)
        addSubview(searchBarButton)
        addSubview(middleLine)
        
        NSLayoutConstraint.activate([
            
            searchConvenienceStoreButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7),
            searchConvenienceStoreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7),
            searchConvenienceStoreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
            searchConvenienceStoreButton.heightAnchor.constraint(equalTo: searchConvenienceStoreButton.widthAnchor),
            
            searchConvenienceStoreButtonTappedView.topAnchor.constraint(equalTo: middleLine.centerYAnchor, constant: 5),
            searchConvenienceStoreButtonTappedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            searchConvenienceStoreButtonTappedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            searchConvenienceStoreButtonTappedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),

            searchBarButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30),
            searchBarButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7),
            searchBarButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7),
            searchBarButton.heightAnchor.constraint(equalTo: searchBarButton.widthAnchor),
            
            searchBarButtonTappedView.bottomAnchor.constraint(equalTo: middleLine.centerYAnchor, constant: -5),
            searchBarButtonTappedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            searchBarButtonTappedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            searchBarButtonTappedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            
            middleLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            middleLine.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            middleLine.widthAnchor.constraint(equalTo: self.widthAnchor),
            middleLine.heightAnchor.constraint(equalToConstant: 3)
            
        ])
    }
    
    private func setupButton(_ button: UIButton, action: Selector, backgroundImage: UIImage?) {
        button.setBackgroundImage(backgroundImage, for: .normal)

        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc private func searchConvenienceStoreButtonTapped() {
        
        isSearchConvenienceStoreViewHidden = !(isSearchConvenienceStoreViewHidden)
        
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
