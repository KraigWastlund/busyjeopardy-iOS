//
//  Colors.swift
//  BusyBusy
//
//  Created by Kraig Wastlund on 6/2/17.
//  Copyright © 2017 busybusy. All rights reserved.
//

import UIKit

class BSYColor: UIColor {
    
    @inline(__always)
    private static func busyColor(hex: String, backingColor: UIColor) -> UIColor {
        if let color = UIColor(fromHexString: hex) {
            return color
        }
        
        return backingColor
    }
    
    @objc static var c1: UIColor {
        return self.busyColor(hex: "30aeef", backingColor: .blue)
    }
    
    @objc static var c2: UIColor {
        return self.busyColor(hex: "2d3e50", backingColor: .blue)
    }
    
    @objc static var c3: UIColor {
        return self.busyColor(hex: "8e8e8e", backingColor: .blue)
    }
    
    @objc static var c4: UIColor {
        return self.busyColor(hex: "859aa6", backingColor: .blue)
    }
    
    @objc static var c5: UIColor {
        return self.busyColor(hex: "cccccc", backingColor: .gray)
    }
    
    @objc static var c6: UIColor {
        return self.busyColor(hex: "fcfcfc", backingColor: .white)
    }
    
    @objc static var c7: UIColor {
        return self.busyColor(hex: "ffffff", backingColor: .white)
    }
    
    @objc static var c8: UIColor {
        return self.busyColor(hex: "ffc107", backingColor: .yellow)
    }
    
    @objc static var c9: UIColor {
        return self.busyColor(hex: "7c8589", backingColor: .blue)
    }
    
    @objc static var c10: UIColor {
        return self.busyColor(hex: "384d60", backingColor: .blue)
    }
    
    @objc static var c11: UIColor {
        return self.busyColor(hex: "d65151", backingColor: .red)
    }
    
    @objc static var c12: UIColor {
        return self.busyColor(hex: "f7f7f7", backingColor: .white)
    }
    
    @objc static var c13: UIColor {
        return self.busyColor(hex: "a9b5bf", backingColor: .blue)
    }
    
    @objc static var c14: UIColor {
        return self.busyColor(hex: "dae6ed", backingColor: .blue)
    }
    
    @objc static var c15: UIColor {
        return self.busyColor(hex: "eeeeee", backingColor: .white)
    }
    
    @objc static var c16: UIColor {
        return self.busyColor(hex: "efc950", backingColor: .yellow)
    }
    
    @objc static var c17: UIColor {
        return self.busyColor(hex: "538FD6", backingColor: .blue)
    }
    
    @objc static var c18: UIColor {
        return self.busyColor(hex: "E0E7EC", backingColor: .blue)
    }
    
    @objc static var c20: UIColor {
        return self.busyColor(hex: "60C4B3", backingColor: .blue)
    }
    
    @objc static var c21: UIColor {
        return self.busyColor(hex: "53ACD2", backingColor: .blue)
    }
    
    @objc static var c22: UIColor {
        return self.busyColor(hex: "9365AB", backingColor: .blue)
    }
    
    @objc static var c23: UIColor {
        return self.busyColor(hex: "A38F84", backingColor: .blue)
    }
    
    @objc static var c24: UIColor {
        return self.busyColor(hex: "486878", backingColor: .blue)
    }
    
    @objc static var c25: UIColor {
        return self.busyColor(hex: "8AABC5", backingColor: .blue)
    }
}

extension UIColor {
    
    convenience init?(fromHexString hexString: String) {
        guard let hex = hexString.hex else {
            self.init(hex: 0)
            return
        }
        self.init(hex: hex)
    }
    
    convenience init(hex: Int) {
        if hex == 0 {
            self.init(white: 0, alpha: 0)
        } else {
            self.init(hex: hex, a: 1.0)
        }
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
}

extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}
