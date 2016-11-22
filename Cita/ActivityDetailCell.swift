//
//  ActivityDetailCell.swift
//  Cita
//
//  Created by Sara Hender on 11/21/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ActivityDetailCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var gravatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
