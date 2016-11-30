//
//  Color.swift
//  Cita
//
//  Created by Sara Hender on 11/29/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class var citaOrange: UIColor {
        return UIColor(colorLiteralRed: (255/255), green: (131/255), blue: (85/255), alpha: 1.0)
    }
    
    class var citaRed: UIColor {
        return UIColor(red:0.80, green:0.21, blue:0.00, alpha:1.0)
    }
}
