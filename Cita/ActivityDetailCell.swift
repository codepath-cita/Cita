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
            /*
            timeFormatter.dateStyle = .medium
            timeFormatter.timeStyle = .short
            let starts = timeFormatter.string(from: activity.startTime!)
            let ends = timeFormatter.string(from: activity.endTime!)
            nameLabel.text = activity.name
            descriptionLabel.text = activity.fullDescription
            startTimeLabel.text = "From \(starts)"
            endTimeLabel.text = "To \(ends)"
            groupSizeLabel.text = activity.attendeeCountText()
            if activity.owner {
                iconImageView.image = UIImage(named: "key")
            } else {
                iconImageView.image = nil
            }*/
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
