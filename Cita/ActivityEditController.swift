//
//  ActivityEditController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ActivityEditController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameInvalidLabel: UILabel!
    @IBOutlet weak var groupSizeField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionInvalidLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    var markerLocation: Location!
    
    var startTimePicker: UIDatePicker!
    var endTimePicker: UIDatePicker!
    
    let timeFormatter = DateFormatter()
    var startDate: Date?
    var endDate: Date?
//    var initialDescriptionViewY: CGFloat!
    var offset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Activity"
        
        startTimeTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in
//            self.descriptionView.frame.origin.y = self.initialDescriptionViewY + self.offset
            self.descriptionView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in
//            self.descriptionView.frame.origin.y = self.initialDescriptionViewY
        }
        
        timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .short

        // make UITextView style match UITextField
        descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5
        
        startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .dateAndTime
        startTimeTextField.inputView = startTimePicker
        startTimePicker.addTarget(self, action: #selector(setStartTime), for: .valueChanged)
        
        endTimePicker = UIDatePicker()
        endTimeTextField.inputView = endTimePicker
        endTimePicker.addTarget(self, action: #selector(setEndTime), for: .valueChanged)
        
//        initialDescriptionViewY = descriptionView.frame.origin.y
        offset = -68
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
    }
    
    func setStartTime() {
        let timeText = timeFormatter.string(from: startTimePicker.date)
        print("chose start time \(timeText)")
        startDate = startTimePicker.date
        startTimeTextField.text = timeText
        
        // yay our event can't end before it started
        endTimePicker.date = startTimePicker.date
    }
    
    func setEndTime() {
        let timeText = timeFormatter.string(from: endTimePicker.date)
        print("chose end time \(timeText)")
        endDate = endTimePicker.date
        endTimeTextField.text = timeText
    }
    
    @IBAction func didCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickSave(_ sender: Any) {
        if validateFields() {
            let location = self.markerLocation
            let activity = Activity(dictionary: [
                "name": nameTextField.text! as AnyObject,
                "full_description": descriptionTextView.text!,
                "attendees_count": Int(groupSizeField.text!)!,
                "start_time": startDate!.iso8601,
                "end_time": endDate!.iso8601,
                "group_size": Int(groupSizeField.text!)!,
                "location": location!.toString()
                ])
            activity.creator = User.currentUser
            activity.attendees = []
            activity.attendeeIDs = []
            activity.save()
            dismiss(animated: true, completion: nil)
        }
    }

    
    func validateFields() -> Bool {
        var valid = true
        
        if nameTextField?.text == nil || nameTextField.text!.characters.count < 4 {
            nameTextField.layer.borderWidth = 1.0
            nameTextField.layer.cornerRadius = 5
            nameTextField.layer.borderColor = UIColor.red.cgColor
            nameInvalidLabel.isHidden = false
            valid = false
        } else {
            nameTextField.layer.borderWidth = 0
            nameInvalidLabel.isHidden = true
        }
        
        if descriptionTextView?.text == nil || descriptionTextView.text!.characters.count < 4 {
            descriptionTextView.layer.borderColor = UIColor.red.cgColor
            descriptionInvalidLabel.isHidden = false
            valid = false
        }
        
        if startDate == nil {
            startTimeTextField.layer.borderWidth = 1.0
            startTimeTextField.layer.cornerRadius = 5
            startTimeTextField.layer.borderColor = UIColor.red.cgColor
            valid = false
        } else {
            startTimeTextField.layer.borderWidth = 0
        }
        
        if endDate == nil {
            endTimeTextField.layer.borderWidth = 1.0
            endTimeTextField.layer.cornerRadius = 5
            endTimeTextField.layer.borderColor = UIColor.red.cgColor
            valid = false
        } else {
            endTimeTextField.layer.borderWidth = 0
        }
        
        if groupSizeField.text == nil || (Int(groupSizeField.text!) == nil) {
            groupSizeField.layer.borderWidth = 1.0
            groupSizeField.layer.cornerRadius = 5
            groupSizeField.layer.borderColor = UIColor.red.cgColor
            valid = false
        } else {
            groupSizeField.layer.borderWidth = 0
        }
        
        return valid
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
