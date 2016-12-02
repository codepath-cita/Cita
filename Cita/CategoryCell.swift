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
            bgView.backgroundColor = UIColor.citaGreen
        } else {
            bgView.backgroundColor = UIColor.citaYellow
        }
    }
}
