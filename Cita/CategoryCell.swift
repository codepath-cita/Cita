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
    
    let yellow = UIColor(colorLiteralRed: 242/255.0, green: 204/255.0, blue: 50/255.0, alpha: 50)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.backgroundColor = yellow
    }

}
