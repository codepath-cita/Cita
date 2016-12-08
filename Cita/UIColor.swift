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

    class var facebookBlue: UIColor {
        return UIColor(red: (59/255), green: (89/255), blue: (152/255), alpha: 1.0)
    }

    class var citaBrightRed: UIColor {
        return UIColor(red: (218/255), green: (31/255), blue: (16/255), alpha: 1.0)
    }
    
    
    // 51 delta? 50 shades of gray...
    class var citaLightLightGray: UIColor {
        return UIColor(red: (230/255), green: (230/255), blue: (230/255), alpha: 1.0)
    }

    class var citaLightGray: UIColor {
        return UIColor(red: (179/255), green: (179/255), blue: (179/255), alpha: 1.0)
    }
    
    class var citaGray: UIColor {
        return UIColor(red: (128/255), green: (128/255), blue: (128/255), alpha: 1.0)
    }
    
    class var citaDarkGray: UIColor {
        return UIColor(red: (102/255), green: (102/255), blue: (102/255), alpha: 1.0)
    }
    
    class var citaDarkDarkGray: UIColor {
        return UIColor(red: (51/255), green: (51/255), blue: (51/255), alpha: 1.0)
    }
    // end of grays
    
    class var citaOrange: UIColor {
        return UIColor(red: (255/255), green: (131/255), blue: (85/255), alpha: 1.0)
    }
    
    class var citaRed: UIColor {
        return UIColor(red: (191/255), green: (49/255), blue: (0/255), alpha: 1.0)
    }
    
    class var citaYellow: UIColor {
        return UIColor(red: (250/255), green: (224/255), blue: (12/255), alpha: 1.0)
    }
    
    class var citaDarkYellow: UIColor {
        return UIColor(red: (236/255), green: (159/255), blue: (5/255), alpha: 1.0)
    }
    
    class var citaGreen: UIColor {
        return UIColor(red: (87/255), green: (178/255), blue: (30/255), alpha: 1.0)
    }
    
    class var citaBlue: UIColor {
        return UIColor(red: (89/255), green: (155/255), blue: (244/255), alpha: 1.0)
    }
}
