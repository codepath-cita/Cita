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
    
    // 51 delta?
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
    
    
    class var citaOrange: UIColor {
        return UIColor(red: (255/255), green: (117/255), blue: (11/255), alpha: 1.0)
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
