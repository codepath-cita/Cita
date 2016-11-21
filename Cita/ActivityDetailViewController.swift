//
//  ActivityDetailViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    var activity: Activity!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var addressLabel1: UILabel!
    @IBOutlet weak var addressLabel2: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityNameLabel.text = activity.name
        
        descriptionLabel.text = activity.fullDescription
        
        startTimeLabel.text = activity.startTime?.description
        endTimeLabel.text = activity.endTime?.description
        
        addressLabel1.text = activity.address?.street1
        addressLabel2.text = activity.address?.street2
        cityLabel.text = activity.address?.city
        zipcodeLabel.text = activity.address?.zip
        
        joinButton.layer.cornerRadius = 7
        joinButton.clipsToBounds = true
    }
    
    @IBAction func joinActivityButtonPress(_ sender: Any) {
        let alertController = UIAlertController(title: "Congratulations!!!!", message: "Thank you for joining this event, we  hope you have a lot of fun!!", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
            // write to database
            // segue back
        }

        let CANCELAction = UIAlertAction(title: "CANCEL", style: .default) { (action) in
            // handle response here. => DO NOTHING
        }
        
        alertController.addAction(CANCELAction)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

     /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
