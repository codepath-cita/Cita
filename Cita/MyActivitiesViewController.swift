//
//  MyActivitiesViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyActivitiesViewController: UIViewController {
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    let ActivityCellIdentifier = "ActivityCell"
    
    let userRef = FIRDatabase.database().reference(withPath: User.dbRoot)
    let activityRef = FIRDatabase.database().reference(withPath: Activity.dbRoot)
    
    var attendingActivities: [String:Activity] = [:]
    var ownedActivities: [String:Activity] = [:]
    var activities: [Activity] = []
    var pastActivities: [Activity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        tableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: ActivityCellIdentifier)
 
        // hide empty cells
        tableView.tableFooterView = UIView()
        
        observeUserActivities()
        observeOwnedActivities()
    }
    
    func organizeActivities() {
        
        var tmp = ownedActivities
        
        for key in attendingActivities.keys {
            tmp[key] = attendingActivities[key]
        }
        
        let tmp2 = tmp.values.sorted { (a1, a2) -> Bool in
            return a1.startTime! < a2.startTime!
        }
        
        let time = Date.init(timeIntervalSinceNow: 0)
        
        pastActivities = []
        activities = []
        
        for activity in tmp2 {
            if activity.startTime! < time {
                pastActivities.insert(activity, at: 0)
            } else {
                activities.append(activity)
            }
        }
        
        //print( activities[0].startTime! < Date.init(timeIntervalSinceNow: 0))
        //print(Date.init(timeIntervalSinceNow: 0))
    }
    
    func observeUserActivities() {
        let userActivitiesRef = userRef.child(User.currentUser!.uid!).child("activity_keys")
        userActivitiesRef.observe(.value, with: { snapshot in
            self.attendingActivities.removeAll()
            for child in snapshot.children {
                let item = child as! FIRDataSnapshot
                let key = item.value as! String
                self.activityRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let activity = Activity(snapshot: snapshot)
                    self.attendingActivities[key] = activity
                    self.organizeActivities()
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func observeOwnedActivities() {
        let userActivitiesRef = userRef.child(User.currentUser!.uid!).child("creator_keys")
        userActivitiesRef.observe(.value, with: { snapshot in
            self.ownedActivities.removeAll()
            for child in snapshot.children {
                let item = child as! FIRDataSnapshot
                let key = item.value as! String
                self.activityRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let activity = Activity(snapshot: snapshot)
                    activity.owner = true
                    self.ownedActivities[key] = activity
                    self.organizeActivities()
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

extension MyActivitiesViewController: UITableViewDelegate, UITableViewDataSource,  UIGestureRecognizerDelegate, tableDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return activities.count
        } else {
            return pastActivities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCellIdentifier, for: indexPath) as! ActivityCell
        if indexPath.section == 0 {
            cell.activity = activities[indexPath.row]
        }
        else {
            cell.activity = pastActivities[indexPath.row]
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)! as UITableViewHeaderFooterView
        header.textLabel?.textAlignment = .center
        header.textLabel?.textColor = UIColor.black
        
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
    
    func tableDelegate(activity: Activity) {
        print("tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let activityDetailViewController = storyboard.instantiateViewController(withIdentifier: "ActivityDetailViewController") as! ActivityDetailViewController
        activityDetailViewController.activity = activity
        self.navigationController?.pushViewController(activityDetailViewController, animated: true)
    }
}


