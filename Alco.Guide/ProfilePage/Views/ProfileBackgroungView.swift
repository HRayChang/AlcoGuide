//
//  ProfileBackgroungView.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/12.
//

import UIKit

class ConcaveView: UIView {
    
    let circleView = UIImageView()
    var breathingAnimationCount = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewUI()
        startBreathingAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath()
        
        // Calculate dynamic control points for vertical movement
        let controlPoint1Y = 450 + sin(CGFloat(breathingAnimationCount) * 0.1) * -100
        let controlPoint2Y = 300 + sin(CGFloat(breathingAnimationCount) * 0.1) * 100
        
        // Left top corner
        path.move(to: CGPoint(x: 0, y: 280))
        
        path.addCurve(to: CGPoint(x: rect.width, y: 300),
                      controlPoint1: CGPoint(x: rect.width/3, y: controlPoint1Y),
                      controlPoint2: CGPoint(x: rect.width * 2/3, y: controlPoint2Y))
        
        // Bottom edge
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()
        
        // Set fill color
        UIColor.black.withAlphaComponent(0.4).setFill()
        path.fill()
    }
    
    func setupViewUI() {
        let circleRadius: CGFloat = 80.0
        circleView.layer.cornerRadius = circleRadius
        circleView.image = UIImage(named: "ray")
        circleView.contentMode = .scaleAspectFill
        circleView.alpha = 1
        
        circleView.layer.shadowOpacity = 1
        circleView.layer.shadowRadius = 10.0
        circleView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circleView)
        
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -60),
            circleView.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            circleView.widthAnchor.constraint(equalToConstant: circleRadius * 2),
            circleView.heightAnchor.constraint(equalToConstant: circleRadius * 2)
        ])
    }
    
    func startBreathingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.breathingAnimationCount += 1
            self.setNeedsDisplay()
        }
    }
}
