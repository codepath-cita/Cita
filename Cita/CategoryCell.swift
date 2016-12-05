//
//  CategoryCell.swift
//  Cita
//
//  Created by Stephen Chudleigh on 12/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSelectedState()
    }

    func setSelectedState() {
        
        if isSelected {
            self.layer.shadowColor = UIColor.citaGreen.cgColor
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 1.0
            self.clipsToBounds = false
            self.layer.masksToBounds = false
            self.bgView.backgroundColor = UIColor.citaLightLightGray
            self.categoryNameLabel.textColor = UIColor.black
            self.iconImage.tintColor = UIColor.black
            self.bgView.layer.borderColor = UIColor.citaDarkGray.cgColor
        } else {
            self.layer.shadowOpacity = 0
            self.layer.shadowRadius = 0
            self.iconImage.tintColor = UIColor.citaLightGray
            self.bgView.backgroundColor = UIColor(red: (250/255), green: (250/255), blue: (250/255), alpha: 1.0 )
            self.categoryNameLabel.textColor = UIColor.citaLightGray
            self.bgView.layer.borderColor = UIColor.citaLightGray.cgColor
        }
        
        
    }
}
