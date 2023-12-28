//
//  shakeView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/14.
//

import Foundation
import UIKit
import CoreMotion

class ShakeView: UIView {
    
    let shakerImageView = UIImageView()
    let shakeLabel = UILabel()
    
    let motionManager = CMMotionManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        startMotionUpdates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopMotionUpdates()
    }
    
    
    func setupView() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        shakerImageView.contentMode = .scaleAspectFit
        shakerImageView.image = UIImage(named: "shaker")
        
        shakeLabel.text = "SHAKE IT"
        shakeLabel.textAlignment = .center
        shakeLabel.textColor = .steelPink
        shakeLabel.font = UIFont(name: "Marker Felt Wide", size: 90)
        shakeLabel.layer.shadowColor = UIColor.steelPink.cgColor
        shakeLabel.layer.shadowOpacity = 1
        shakeLabel.layer.shadowRadius = 10.0
        shakeLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        addBreathingAnimation(to: shakeLabel)
        
        shakerImageView.translatesAutoresizingMaskIntoConstraints = false
        shakeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(shakeLabel)
        addSubview(shakerImageView)
        
        NSLayoutConstraint.activate([
            shakerImageView.topAnchor.constraint(equalTo: self.topAnchor),
            shakerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            shakerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shakerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            shakeLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -200),
            shakeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shakeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            
        ])
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
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                guard let self = self, let motion = motion else { return }
                self.handleMotionUpdate(motion)
            }
        }
    }
    
    func handleMotionUpdate(_ motion: CMDeviceMotion) {
        let gravity = motion.gravity
        let gravityX = gravity.x
        let gravityY = gravity.y
        let angle = atan2(gravityY, gravityX)
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .unknown
        
        var transform = CGAffineTransform.identity
        
        switch orientation {
        case .portrait:
            transform = CGAffineTransform(translationX: 0, y: gravityY * 100)
        case .portraitUpsideDown:
            transform = CGAffineTransform(translationX: 0, y: -gravityY * 100)
        default:
            break
        }
        
        UIView.animate(withDuration: 0.1) {
            self.shakeLabel.transform = transform
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopGyroUpdates()
    }
    
}
