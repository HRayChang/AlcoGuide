//
//  UIView+Extension.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/25.
//

import UIKit

extension UIView {
    func addGradientBackground(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func addShimmerAnimation(to label: UILabel) {
        let gradient = CAGradientLayer()
        gradient.frame = label.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.1, 0.5, 0.9]
        let angle = -60 * CGFloat.pi / 180
        gradient.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        label.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 8
        animation.repeatCount = Float.infinity
        animation.autoreverses = false
        animation.fromValue = -frame.width - 100
        animation.toValue = frame.width + 100
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        gradient.add(animation, forKey: "shimmerKey")
    }
}
