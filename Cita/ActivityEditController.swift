//
//  ActivityEditController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ActivityEditController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberOfAttendeesField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var newTagField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickSave(_ sender: UIButton) {
        let location = Location(string: "37.77,-122.42")
        let activity = Activity(dictionary: [
            "name": nameTextField.text ?? "Fun at \(location.toString())",
            "description": descriptionTextView.text ?? "Join me!",
            "attendees_count": Int(numberOfAttendeesField.text!) ?? 2,
            "start_time": "2016-11-19T02:35:41+00:00",
            "end_time": "2016-11-19T06:35:41+00:00",
            "location": location.toString()
        ])
        activity.save()
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
