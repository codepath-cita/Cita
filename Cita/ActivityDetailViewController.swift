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
    
    @IBOutlet weak var categoryIconImage: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
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

        if let category = activity.category {
            categoryNameLabel.text = category
            categoryIconImage.image = Activity.defaultCategories[category]
        } else {
            let category = Activity.other
            categoryNameLabel.text = category
            categoryIconImage.image = Activity.defaultCategories[category]
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .short
        
        startTimeLabel.text = Date.niceToRead(from: activity.startTime!, to: activity.endTime!, terse: false)
        addressLabel.text = activity.address
        
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
        joinButton.backgroundColor = UIColor.citaGreen
        joinButton.layer.borderWidth = 1
        joinButton.layer.borderColor = UIColor.citaDarkGray.cgColor

        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)

        // hide empty cells
        tableView.tableFooterView = UIView()
        
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
            let _ = self.navigationController?.popViewController(animated: true)
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
            joinButton.backgroundColor = UIColor.citaYellow
            joinButton.layer.borderColor = UIColor.citaDarkYellow.cgColor
            joinButton.setTitle("Leave Activity", for: .normal)
        } else {
            joinButton.backgroundColor = UIColor.citaGreen
            joinButton.layer.borderColor = UIColor.citaDarkGray.cgColor
            joinButton.setTitle("Join Activity", for: .normal)
        }
    }
    
     /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension ActivityDetailViewController: UITableViewDelegate, UITableViewDataSource, profileSelectedDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (activity.attendees?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailCell", for: indexPath) as! ActivityDetailCell
        
        if indexPath.section == 0 {
            cell.user = User.userCache[(activity.creator?.uid)!]
        } else if indexPath.section == 1 {
            if nil != activity.attendees {
                cell.user = User.userCache[(activity.attendees?[indexPath.row].uid)!]
            }
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
/*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var returnedView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)) //set these values as necessary
        returnedView.backgroundColor = UIColor.citaYellow
        
        var label = UILabel(frame: CGRect(x: 16, y: 4, width: self.view.frame.width - 15, height: 46))
        label.text = "Hello World!"
        returnedView.addSubview(label)
        
        return returnedView
    }
 */
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)! as UITableViewHeaderFooterView

        header.textLabel?.textAlignment = .center
        header.textLabel?.textColor = UIColor.black
                
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
    
    func profileSelectedDelegate(user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController.user = user
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
}
