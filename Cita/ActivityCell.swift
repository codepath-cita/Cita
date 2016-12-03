//
//  ActivityCell.swift
//  Cita
//
//  Created by Sara Hender on 11/23/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    let timeFormatter = DateFormatter()
    var delegate: tableDelegate?
    var activity: Activity! {
        didSet {
            timeFormatter.dateStyle = .medium
            timeFormatter.timeStyle = .short
            nameLabel.text = activity.name
            descriptionLabel.text = activity.fullDescription
            
            startTimeLabel.text = Date.niceToRead(from: activity.startTime!, to: activity.endTime!, terse: false)
            //endTimeLabel.text = "To \(ends)"
            
            groupSizeLabel.text = activity.attendeeCountText()
            if let category = activity.category {
                categoryImageView.image = Activity.defaultCategories[category]
            } else {
                categoryImageView.image = Activity.defaultCategories[Activity.other]
            }
            
            if activity.owner {
                iconImageView.image = UIImage(named: "key")
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
