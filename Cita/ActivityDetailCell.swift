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

    var delegate: profileSelectedDelegate?
    var user: User! {
        didSet {
            self.nameLabel.text = user.displayName
            
            if let photoUrl = user.photoURL,
                let data = try? Data(contentsOf: photoUrl) {
                self.gravatarImage.image = UIImage(data: data)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        gravatarImage.layer.cornerRadius = 8
        gravatarImage.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(tapTouch))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    func tapTouch(sender: UITapGestureRecognizer) {
        delegate?.profileSelectedDelegate(user: user)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

protocol profileSelectedDelegate {
    func profileSelectedDelegate(user: User)
}
