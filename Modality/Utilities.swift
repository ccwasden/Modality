//
//  Utilities.swift
//  DialogManager
//
//  Created by Chase Wasden on 9/26/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import Foundation





extension UIColor {
    
    func mixLighter (_ amount: CGFloat = 0.25) -> UIColor {
        return mixWithColor(UIColor.white, amount: amount)
    }
    
    func mixDarker (_ amount: CGFloat = 0.25) -> UIColor {
        return mixWithColor(UIColor.black, amount: amount)
    }
    
    func mixWithColor(_ color: UIColor, amount: CGFloat = 0.25) -> UIColor {
        var r1     : CGFloat = 0
        var g1     : CGFloat = 0
        var b1     : CGFloat = 0
        var alpha1 : CGFloat = 0
        var r2     : CGFloat = 0
        var g2     : CGFloat = 0
        var b2     : CGFloat = 0
        var alpha2 : CGFloat = 0
        
        self.getRed (&r1, green: &g1, blue: &b1, alpha: &alpha1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &alpha2)
        return UIColor( red:r1*(1.0-amount)+r2*amount,
                        green:g1*(1.0-amount)+g2*amount,
                        blue:b1*(1.0-amount)+b2*amount,
                        alpha: alpha1 )
    }
}

extension UIImage {
    static func fromColor(_ color: UIColor, size:CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension NSAttributedString {
    convenience init(string:String, font:UIFont, color:UIColor? = nil, attributes:[String:AnyObject]? = nil) {
        var attr = [String:AnyObject]()
        if let a = attributes {
            for (k,v) in a {
                attr[k] = v
            }
        }
        if let c = color {
            attr[NSForegroundColorAttributeName] = c
        }
        attr[NSFontAttributeName] = font
        
        self.init(string:string, attributes:attr)
    }
}
