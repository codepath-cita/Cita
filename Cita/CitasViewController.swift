//
//  CitasViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CitasViewController: UIViewController {
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    let userRef = FIRDatabase.database().reference(withPath: User.dbRoot)
    let activityRef = FIRDatabase.database().reference(withPath: Activity.dbRoot)
    
    var activities: [String:Activity] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        observeUserActivities()
    }
    
    func observeUserActivities() {
        let userActivitiesRef = userRef.child(User.currentUser!.uid!).child("activity_keys")
        userActivitiesRef.observe(.value, with: { snapshot in
            for child in snapshot.children {
                let item = child as! FIRDataSnapshot
                let key = item.value as! String
                self.activityRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! NSDictionary
                    let activity = Activity(dictionary: dictionary)
                    self.activities[key] = activity
                    self.tableView.reloadData()
                })
            }
        })
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
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitasTableViewCell", for: indexPath) as! CitasTableViewCell
        let activitiesByStartTime = activities.values.sorted { (a1, a2) -> Bool in
            return a1.startTime! > a2.startTime!
        }
        cell.activity = activitiesByStartTime[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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


