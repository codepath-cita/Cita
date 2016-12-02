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
        return UIColor(colorLiteralRed: (255/255), green: (117/255), blue: (11/255), alpha: 1.0)
    }
    
    class var citaRed: UIColor {
        return UIColor(red: (191/255), green: (49/255), blue: (0/255), alpha: 1.0)
    }
    
    class var citaYellow: UIColor {
        return UIColor(red: (245/255), green: (187/255), blue: (0/255), alpha: 1.0)
    }
    
    class var citaDarkYellow: UIColor {
        return UIColor(red: (236/255), green: (159/255), blue: (5/255), alpha: 1.0)
    }
    
    class var citaGreen: UIColor {
        return UIColor(red: (142/255), green: (166/255), blue: (4/255), alpha: 1.0)
    }
}
