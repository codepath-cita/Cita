//
//  ListViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var activities: [Activity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160

        tableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
        
        
        if Activity.currentActivities != nil {
            activities = Activity.currentActivities
            tableView.reloadData()
        }
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: Activity.activitiesUpdated),
            object: nil, queue: OperationQueue.main) {
                (notification: Notification) in
                self.activities = Activity.currentActivities
                self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, tableDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        cell.activity = activities?[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableDelegate(activity: Activity) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let activityDetailViewController = storyboard.instantiateViewController(withIdentifier: "ActivityDetailViewController") as! ActivityDetailViewController
        activityDetailViewController.activity = activity
        self.navigationController?.pushViewController(activityDetailViewController, animated: true)
    }
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! ActivityCell
        let indexPath = tableView.indexPath(for: cell)
        let activity = activities?[(indexPath?.row)!]
        let activityDetailViewController = segue.destination as! ActivityDetailViewController
        activityDetailViewController.activity = activity
    }
*/ 
}
