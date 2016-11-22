//
//  CitasViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class CitasViewController: UIViewController {
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    var pastActivities: [Activity] = []
    var upcomingActivities: [Activity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let now = Date(timeIntervalSinceNow: 0)
        
        // seperate the activities by the date and time now
        if let activities = User.currentUser?.activities {
            for activity in activities {
                if activity.startTime! < now {
                    pastActivities.append(activity)
                } else {
                    upcomingActivities.append(activity)
                }
            }
        }
        
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CitasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? upcomingActivities.count : pastActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailCell", for: indexPath) as! ActivityDetailCell
        /*
        if indexPath.section == 0 {
            cell.nameLabel.text = activity.creator?.displayName
            
            if let photoUrl = activity.creator?.photoURL,
                let data = try? Data(contentsOf: photoUrl) {
                cell.gravatarImage.image = UIImage(data: data)
            }
            
        } else if indexPath.section == 1 {
            print("indexPath.row: \(indexPath.row)")
            let user = activity.attendees?[indexPath.row]
            cell.nameLabel.text = user?.displayName
            
            if let photoUrl = user?.photoURL,
                let data = try? Data(contentsOf: photoUrl) {
                cell.gravatarImage.image = UIImage(data: data)
            }
        }
        */
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)! as UITableViewHeaderFooterView
        if section == 0 {
            header.textLabel?.text = "Upcoming Events"
        } else if section == 1 {
            header.textLabel?.text = "Past Events"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}


