//
//  CitasTableViewCell.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/23/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class CitasTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startsLabel: UILabel!
    
    let timeFormatter = DateFormatter()
    var activity: Activity! {
        didSet {
            timeFormatter.dateStyle = .medium
            timeFormatter.timeStyle = .short
            let starts = timeFormatter.string(from: activity.startTime!)
            let ends = timeFormatter.string(from: activity.endTime!)
            nameLabel.text = activity.name
            startsLabel.text = "Starts \(starts)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
