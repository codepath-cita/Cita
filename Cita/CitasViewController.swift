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
    
    var attendingActivities: [String:Activity] = [:]
    var ownedActivities: [String:Activity] = [:]
    var activities: [Activity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        tableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
 
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
        
        activities = tmp.values.sorted { (a1, a2) -> Bool in
            return a1.startTime! < a2.startTime!
        }
    }
    
    func observeUserActivities() {
        let userActivitiesRef = userRef.child(User.currentUser!.uid!).child("activity_keys")
        userActivitiesRef.observe(.value, with: { snapshot in
            self.attendingActivities.removeAll()
            for child in snapshot.children {
                let item = child as! FIRDataSnapshot
                let key = item.value as! String
                self.activityRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! NSDictionary
                    let activity = Activity(dictionary: dictionary)
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
                    let dictionary = snapshot.value as! NSDictionary
                    let activity = Activity(dictionary: dictionary)
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

extension CitasViewController: UITableViewDelegate, UITableViewDataSource,  UIGestureRecognizerDelegate, tableDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        
        cell.delegate = self
        cell.activity = activities[indexPath.row]
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
    
    func tableDelegate(activity: Activity) {
        print("tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let activityDetailViewController = storyboard.instantiateViewController(withIdentifier: "ActivityDetailViewController") as! ActivityDetailViewController
        activityDetailViewController.activity = activity
        self.navigationController?.pushViewController(activityDetailViewController, animated: true)
    }
}


