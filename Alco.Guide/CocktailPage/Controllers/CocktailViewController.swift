//
//  CocktailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import CoreHaptics
import AVFoundation

class CocktailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ButtonViewDelegate {
    
    var selectedCategory: [String: String] = [:]
    var shakerView = ShakeView()
    var shakerButton = UIButton()
    
    var hapticEngine: CHHapticEngine?
    var audioPlayer: AVAudioPlayer?
    
    let classicCocktails = ["Tom Collins": "01", "Manhattan": "02", "Negroni": "03", "Dunlop": "04", "The French Negroni": "05", "Dram Queen": "06", "Passion Fruit Daiquiri": "07", "Daiquiri": "08"]
    
    let modernCocktails = ["Tropical Fusion": "17",
                           "FORMANSA": "16",
                           "Honey Lemon Gin": "15",
                           "Bonny Tea": "14",
                           "Don Whiskey": "13",
                           "Purple Dream": "12"]
    
    var isClassicCocktail: Bool = true
    
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
        buttonView.delegate = self
        
        collectionView.register(CocktailCollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        
        setupViewUI()
        setupConstraints()
        
        selectedCategory = classicCocktails
        collectionView.reloadData()
        
        self.becomeFirstResponder()
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        switch isClassicCocktail {
        case true:
            backgroundView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        case false:
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = backgroundView.bounds
            gradientLayer.colors = [UIColor.black.cgColor, /*UIColor.black.cgColor,  UIColor.steelPink.cgColor,*/ UIColor.eminence.cgColor, UIColor.black.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
         
        }
        
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    func setupViewUI() {
        
        //        view.backgroundColor = .black
        
        navigationItem.title = "Wine List"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lilac]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //        backgroundView.layer.shadowColor = UIColor.eminence.cgColor
        //        backgroundView.layer.shadowOpacity = 1
        //        backgroundView.layer.shadowRadius = 10.0
        //        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        
        shakerView.isHidden = true
        
        shakerButton.layer.cornerRadius = view.frame.size.width/20
        shakerButton.setTitle("?", for: .normal)
        shakerButton.setTitleColor(.steelPink, for: .normal)
        shakerButton.backgroundColor = .black
        shakerButton.layer.shadowColor = UIColor.steelPink.cgColor
        shakerButton.layer.shadowOpacity = 1
        shakerButton.layer.shadowRadius = 3.0
        shakerButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        shakerButton.addTarget(self, action: #selector(shakerButtonTapped), for: .touchUpInside)
        addBreathingAnimation(to: shakerButton)
        
        //        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        //        layout?.estimatedItemSize = .zero
        //        layout?.minimumInteritemSpacing = 0
        //        let width = floor(UIScreen.main.bounds.width / 2)
        //        layout?.itemSize = CGSize(width: width, height: width)
    }
    
    func setupConstraints() {
        
        let cellSpace = (UIScreen.main.bounds.width - floor(UIScreen.main.bounds.width / 2 - 20)*2)/3
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        shakerView.translatesAutoresizingMaskIntoConstraints = false
        shakerButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
        view.addSubview(buttonView)
        view.addSubview(shakerView)
        view.addSubview(shakerButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: cellSpace),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -cellSpace),
            
            shakerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -100),
            shakerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            shakerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shakerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            shakerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/10),
            shakerButton.heightAnchor.constraint(equalTo: shakerButton.widthAnchor),
            shakerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            shakerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as? CocktailCollectionViewCell else {
            fatalError("Unable to dequeue CocktailCollectionViewCell")
        }
        
        let cocktailsArray = Array(selectedCategory.keys)
        let cocktailsNames = cocktailsArray[indexPath.item]
        let cocktailsImages = selectedCategory[cocktailsNames] ?? ""
        let image = UIImage(named: cocktailsImages)
        let name = cocktailsNames
        cell.configure(with: image, title: name)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
     
        
        switch isClassicCocktail {
        case true:
            cell.layer.shadowColor = UIColor.black.cgColor
           
        case false:
            cell.layer.shadowColor = UIColor.steelPink.cgColor
            
        }
   
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = CocktailDetailViewController()
        
        let cocktailsArray = Array(selectedCategory.keys)
        let selectedCocktailName = cocktailsArray[indexPath.item]
        
        guard let selectedCocktailData = selectedCategory[selectedCocktailName] else {
            // Handle the case where the selected cocktail data is not found
            print("Error: Selected cocktail data not found")
            return
        }
        
        let selectedCocktailDictionary: [String: String] = [selectedCocktailName: selectedCocktailData]
        
        detailViewController.isClassicCocktail = isClassicCocktail
        detailViewController.selectedCocktailData = selectedCocktailDictionary
        // Present the detail view controller modally

        switch isClassicCocktail {
        case true:
            present(detailViewController, animated: true, completion: nil)
        case false:
            if let sheetPresentationController = detailViewController.sheetPresentationController {
                sheetPresentationController.largestUndimmedDetentIdentifier = .medium
                sheetPresentationController.detents = [
                    .custom(resolver: { context in
                        context.maximumDetentValue * 0.95
                    }),
                ]
            }
            present(detailViewController, animated: true, completion: nil)
        }
    }
    
    @objc func shakerButtonTapped() {
        shakerView.isHidden = false
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if shakerView.isHidden == true {
            return
        }
        
        if motion == .motionShake {
            print("Why are you shaking me?")
            
            shake(to: shakerView.shakerImageView)
            vibrate(duration: 1.5)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let detailViewController = CocktailDetailViewController()
       
                
                let selectedCocktailDictionary: [String: String] = ["Daiquiri": "08"]
            
                detailViewController.isClassicCocktail = self.isClassicCocktail
                detailViewController.selectedCocktailData = selectedCocktailDictionary
                // Present the detail view controller modally
                self.present(detailViewController, animated: true, completion: nil)
                self.shakerView.isHidden = true
            }
        }
    }
    
    func addBreathingAnimation(to view: UIView) {
        let breathingAnimation = CABasicAnimation(keyPath: "shadowRadius")
        breathingAnimation.fromValue = 5
        breathingAnimation.toValue = 20
        breathingAnimation.autoreverses = true
        breathingAnimation.duration = 1
        breathingAnimation.repeatCount = .infinity
        view.layer.add(breathingAnimation, forKey: "breathingAnimation")
    }
    
    func shake(to view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.2
        animation.repeatCount = 3
        animation.autoreverses = true
        
        let fromPoint = CGPoint(x: shakerView.center.x, y: shakerView.center.y - 100)
        let toPoint = CGPoint(x: shakerView.center.x, y: shakerView.center.y + 200)
        
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.toValue = NSValue(cgPoint: toPoint)
        
        view.layer.add(animation, forKey: "position")
    }
    
    func vibrate(duration: TimeInterval) {
        // Check if the device supports haptic feedback
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        playShakeSound()
        DispatchQueue.global().async {
            do {
                // Create the haptic engine
                let hapticEngine = try CHHapticEngine()
                try hapticEngine.start()
                
                // Create a continuous haptic event
                let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                                    parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                                                                 CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)],
                                                    relativeTime: 0,
                                                    duration: TimeInterval(Float(duration)))
                
                // Create a haptic pattern
                let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
                
                // Create a haptic player
                let player = try hapticEngine.makePlayer(with: pattern)
                
                // Start and stop the player to play the haptic pattern
                try player.start(atTime: 0)
                usleep(useconds_t(duration * 1_000_000))
                try player.stop(atTime: 0)
            } catch {
                print("Error creating haptic feedback: \(error.localizedDescription)")
            }
        }
    }
    func playShakeSound() {
        guard let url = Bundle.main.url(forResource: "shakesound", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func buttonView(_ buttonView: ButtonView, didSelectCategory category: String) {
        if category == "classic" {
            selectedCategory = classicCocktails
            isClassicCocktail = true
        } else if category == "modern" {
            selectedCategory = modernCocktails
            isClassicCocktail = false
        }
        
        collectionView.reloadData()
    }
    
   
}
