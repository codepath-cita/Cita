//
//  CitaButton.swift
//  Cita
//
//  Created by Sara Hender on 12/5/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class CitaButton: UIButton {

    func style(borderColor: UIColor, backgroundColor: UIColor) {
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 1
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = borderColor.cgColor
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor.cgColor
    }
    
    func animate(completion: @escaping () -> Void) {
        self.layer.shadowOpacity = 1
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            
            self?.frame = CGRect(x: (self?.frame.origin.x)! + 2, y: (self?.frame.origin.y)! + 2, width: (self?.frame.width)! - 5, height: (self?.frame.height)! - 5)
            
            }, completion: { success in
                
                self.layer.shadowOpacity = 0
                self.frame = CGRect(x: (self.frame.origin.x) - 2, y: (self.frame.origin.y) - 2, width: (self.frame.width) + 5, height: (self.frame.height) + 5)
                
                // run closure here
                completion()
                
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.layer.shadowOpacity = 0
                    }, completion: { success in
                        self.layer.shadowOpacity = 0
                })
        })
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print(#function)
    }
    
    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print(#function)
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print(#function)
    }
}

