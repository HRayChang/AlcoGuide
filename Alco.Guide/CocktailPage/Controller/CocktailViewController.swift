//
//  CocktailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit

class CocktailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cocktailsImages = ["01", "02", "03", "04", "05", "06", "07", "08"]
    
    let cocktailsNames = ["01", "02", "03", "Dunlop03", "The French Negroni05", "Dram Queen06", "Passion Fruit Daiquiri07", "Daiquiri08"]
    
    let backgroundView = UIView()
    let buttonView = ButtonView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.minimumInteritemSpacing = 0
        let width = floor(UIScreen.main.bounds.width / 2 - 20)
        layout.itemSize = CGSize(width: width, height: width * 1.5)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CocktailCollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        
        setupViewUI()
        setupConstraints()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = backgroundView.bounds
//        gradientLayer.colors = [UIColor.black.cgColor, UIColor.eminence.cgColor]
//        gradientLayer.locations = [0.9, 1]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
//    }
    
    func setupViewUI() {
        
        view.backgroundColor = UIColor.black
        
        navigationItem.title = "Wine List"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lilac]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
//        backgroundView.layer.shadowColor = UIColor.eminence.cgColor
//        backgroundView.layer.shadowOpacity = 1
//        backgroundView.layer.shadowRadius = 10.0
//        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        collectionView.backgroundColor = UIColor.clear
        
//        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        layout?.estimatedItemSize = .zero
//        layout?.minimumInteritemSpacing = 0
//        let width = floor(UIScreen.main.bounds.width / 2)
//        layout?.itemSize = CGSize(width: width, height: width)
    }
    
    func setupConstraints() {
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
        view.addSubview(buttonView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cocktailsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as? CocktailCollectionViewCell else {
            fatalError("Unable to dequeue CocktailCollectionViewCell")
        }
        
        let cocktailsImage = cocktailsImages[indexPath.item]
        let cocktailsNames = cocktailsNames[indexPath.item]
          let image = UIImage(named: cocktailsImage)
          let name = cocktailsNames
          cell.configure(with: image, title: name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let selectedCocktailName = cocktailsNames[indexPath.item]
         let detailViewController = CocktailDetailViewController()

         // Present the detail view controller modally
         present(detailViewController, animated: true, completion: nil)
     }
    
}
