//
//  ActivityCell.swift
//  Cita
//
//  Created by Sara Hender on 11/23/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    @IBOutlet weak var peopleImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var updatesLabel: UILabel!

    let timeFormatter = DateFormatter()
    var delegate: tableDelegate?
    var activity: Activity! {
        didSet {
            // Displays update label only if activity contained in eventUpdates array
            updatesLabel.isHidden = true
            let eventUpdates = User.currentUser?.eventUpdates
            if eventUpdates?.contains(activity.userActivityKey) == true {
                updatesLabel.isHidden = false
            }

            nameLabel.text = activity.name
            //descriptionLabel.text = activity.fullDescription
            startTimeLabel.text = Date.niceToRead(from: activity.startTime!, to: activity.endTime!, terse: false)
            categoryImage.image = activity.iconImage()
            groupSizeLabel.text = String(describing: activity.groupSize!)
            addressLabel.text = activity.address
            peopleImage.image = peopleImage.image!.withRenderingMode(.alwaysTemplate)
            peopleImage.tintColor = UIColor.citaDarkGray
            
            if activity.owner {
                iconImageView.image = UIImage(named: "key")
                iconImageView.image = iconImageView.image!.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.citaYellow
                
            } else {
                iconImageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(tapTouch))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
//        updatesLabel.isHidden = true
        updatesLabel.layer.cornerRadius = 5
        updatesLabel.clipsToBounds = true
    }
    
    func tapTouch(sender: UITapGestureRecognizer) {
        delegate?.tableDelegate(activity: activity)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

protocol tableDelegate {
    func tableDelegate(activity: Activity)
}
