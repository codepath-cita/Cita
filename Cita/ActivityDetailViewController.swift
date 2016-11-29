//
//  ActivityDetailViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    
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
    
    var activity: Activity!
    var currentUserAttending = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityNameLabel.text = activity.name
        descriptionLabel.text = activity.fullDescription
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .short
        let starts = timeFormatter.string(from: activity.startTime!)
        let ends = timeFormatter.string(from: activity.endTime!)
        
        startTimeLabel.text = "From \(starts)"
        endTimeLabel.text = "To \(ends)"
        
        addressLabel1.text = activity.address?.street1
        addressLabel2.text = activity.address?.street2
        cityLabel.text = activity.address?.city
        zipcodeLabel.text = activity.address?.zip
        
        if let creatorID = activity.creatorID {
            activity.creator = User.userCache[creatorID]
        }
        if activity.attendeeIDs != nil {
            activity.attendees = []
            for attendeeID in activity.attendeeIDs! {
                if attendeeID == User.currentUser?.uid {
                    currentUserAttending = true
                }
                if let user = User.userCache[attendeeID] {
                    activity.attendees?.append(user)
                } else {
                    print("user missing! \(attendeeID)")
                }
            }
        }
        
        joinButton.layer.cornerRadius = 7
        joinButton.clipsToBounds = true
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        setJoinButton(attending: currentUserAttending)
    }
    
    @IBAction func joinActivityButtonPress(_ sender: Any) {
        if activity.isRegistrationFull() && !currentUserAttending {
            showRegistrationFullAlert()
            return
        }
        
        var alertTitle = "Get Ready!"
        if currentUserAttending {
            alertTitle = "Awww :("
        }
        var alertMessage = "Thank you for joining this event, we  hope you have a lot of fun!!"
        if currentUserAttending {
            alertMessage = "Sorry to see you go. Press Cancel if you are still interested."
        }
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if self.currentUserAttending {
                self.activity.removeUser(user: User.currentUser!)
            } else {
                self.activity.registerUser(user: User.currentUser!)
            }
            self.currentUserAttending = !self.currentUserAttending
            self.setJoinButton(attending: self.currentUserAttending)
            self.navigationController?.popViewController(animated: true)
        }

        let CANCELAction = UIAlertAction(title: "CANCEL", style: .default) { (action) in
            // => DO NOTHING
        }
        
        alertController.addAction(CANCELAction)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
    
    func showRegistrationFullAlert() {
        let alertTitle = "No Spots Left!"
        let alertMessage = "Sorry but this event is full, check back later to see if any spots open."
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
//            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setJoinButton(attending: Bool) {
        if attending {
            joinButton.backgroundColor = .red
            joinButton.setTitle("Leave Activity", for: .normal)
        } else {
            joinButton.backgroundColor = UIColor(red:0.20, green:0.62, blue:0.06, alpha:1.0)
            joinButton.setTitle("Join Activity", for: .normal)
        }

    }
    
     /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension ActivityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return section == 0 ? 1 : (activity.attendees?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailCell", for: indexPath) as! ActivityDetailCell
        
        if indexPath.section == 0 {
            cell.nameLabel.text = activity.creator?.displayName
            
            if let photoUrl = activity.creator?.photoURL,
                let data = try? Data(contentsOf: photoUrl) {
                cell.gravatarImage.image = UIImage(data: data)
            }
            
        } else if indexPath.section == 1 {
            print("indexPath.row: \(indexPath.row)")
            if nil != activity.attendees {
                let user = activity.attendees?[indexPath.row]
                cell.nameLabel.text = user?.displayName
                
                if let photoUrl = user?.photoURL,
                    let data = try? Data(contentsOf: photoUrl) {
                    cell.gravatarImage.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)! as UITableViewHeaderFooterView
        if section == 0 {
            header.textLabel?.text = "Organizer"
        } else if section == 1 {
            header.textLabel?.text = "Attendees"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
