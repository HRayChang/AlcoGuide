//
//  UIColor+Extension.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit

extension UIColor {
    static var lilac: UIColor {
        return UIColor(hex: 0xD3B7D8)
    }
    
    static var steelPink: UIColor {
        return UIColor(hex: 0xC40DC4) //  C40DC4  A13E97
    }
    
    static var eminence: UIColor {
        return UIColor(hex: 0x632A7E)
    }
    
    static var valentino: UIColor {
        return UIColor(hex: 0x280E3B)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
