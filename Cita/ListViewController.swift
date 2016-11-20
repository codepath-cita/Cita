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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        cell.activity = activities?[indexPath.row]
        return cell
    }
    
}
