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

    let timeFormatter = DateFormatter()
    var delegate: tableDelegate?
    var activity: Activity! {
        didSet {
            timeFormatter.dateStyle = .medium
            timeFormatter.timeStyle = .short
            let starts = timeFormatter.string(from: activity.startTime!)
            let ends = timeFormatter.string(from: activity.endTime!)
            nameLabel.text = activity.name
            descriptionLabel.text = activity.fullDescription
            startTimeLabel.text = "From \(starts)"
            endTimeLabel.text = "To \(ends)"
            groupSizeLabel.text = "\(activity.attendeeIDs?.count ?? 1) of \(activity.groupSize ?? 2) spots taken"
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
