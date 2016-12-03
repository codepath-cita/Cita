//
//  ActivityEditController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import GooglePlaces

class ActivityEditController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CategoryViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameInvalidLabel: UILabel!
    @IBOutlet weak var groupSizeField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionInvalidLabel: UILabel!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var peopleView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    
    var startTimePicker: UIDatePicker!
    var durationPicker: UIDatePicker!
    let timeFormatter = DateFormatter()
    
    var location: Location?
    var locationAddress: String?
    var startDate: Date?
    var endDate: Date?
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Activity"
        
        // borders/styling
        addBordersStyles()
        // category/start time/end time
        addSelectors()
        // notifications/observers
        addDelegatesListeners()
        
        // Google Places
//        resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController?.searchResultsUpdater = resultsViewController
//        // Put the search bar in the navigation bar.
//        searchController?.searchBar.sizeToFit()
//        searchController?.searchBar.placeholder = "Enter address to create activity"
//        self.navigationItem.titleView = searchController?.searchBar
//        self.definesPresentationContext = true
//        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    func addBordersStyles() {
        if (locationAddress != nil) {
            locationTextField.text = locationAddress
        }
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        locationView.layer.borderWidth = 1
        locationView.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        startView.layer.borderWidth = 1
        startView.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        endView.layer.borderWidth = 1
        endView.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        peopleView.layer.borderWidth = 1
        peopleView.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
    }
    
    func addSelectors() {
        
        timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .short
        
        startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .dateAndTime
        startTimePicker.minimumDate = 30.minutes.fromNow()
        startTimePicker.minuteInterval = 10
        startTimeTextField.inputView = startTimePicker
        startTimePicker.addTarget(self, action: #selector(setStartTime), for: .valueChanged)
        
        durationPicker = UIDatePicker()
        durationPicker.datePickerMode = .countDownTimer
        durationPicker.minuteInterval = 10
        durationTextField.inputView = durationPicker
        durationPicker.addTarget(self, action: #selector(setEndTime), for: .valueChanged)
    }
    
    func addDelegatesListeners() {
        startTimeTextField.delegate = self
        descriptionTextView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.descriptionView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            //            self.descriptionView.frame.origin.y = self.initialDescriptionViewY
        }
    }
    
    @IBAction func onLocationTap(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
        }
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
        
        durationPicker.date = startTimePicker.date
    }
    
    func setEndTime() {
        let duration = durationPicker.countDownDuration
        let minutes = Int((duration / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int(floor(duration / 3600))
        print("chose duration \(hours):\(minutes)")
        endDate = startTimePicker.date + durationPicker.countDownDuration
        if hours == 0 {
            durationTextField.text = "\(minutes) minutes"
        } else {
            durationTextField.text = "\(hours) hours \(minutes) minutes"
        }
    }
    
    @IBAction func didCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickSave(_ sender: Any) {
        if validateFields() {
            let location = self.location
            let activity = Activity(dictionary: [
                "name": nameTextField.text! as AnyObject,
                "full_description": descriptionTextView.text!,
                "attendees_count": Int(groupSizeField.text!)!,
                "start_time": startDate!.iso8601,
                "end_time": endDate!.iso8601,
                "group_size": Int(groupSizeField.text!)!,
                "location": location!.toString(),
                "address": locationTextField.text!
                ])
            activity.creator = User.currentUser
            activity.attendees = []
            activity.attendeeIDs = []
            activity.save()
            
            let activityKey = "\(startDate!.iso8601DatePart)/\(activity.key!)"

            User.currentUser!.creatorKeys!.append(activityKey)
            User.currentUser!.save()
            
            dismiss(animated: true, completion: nil)
        }
    }

    
    func validateFields() -> Bool {
        var valid = true
        
        // name
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
        
        // description
        if descriptionTextView?.text == nil || descriptionTextView.text!.characters.count < 4 {
            descriptionTextView.layer.borderColor = UIColor.red.cgColor
            descriptionTextView.layer.borderWidth = 1.0
            descriptionTextView.layer.cornerRadius = 5
            descriptionInvalidLabel.isHidden = false
            valid = false
        } else {
            descriptionTextView.layer.borderWidth = 0
            descriptionInvalidLabel.isHidden = true
        }
        
        // category (button)
        if category == nil {
            categoryButton.tintColor = .red
            categoryButton.layer.borderColor = UIColor.red.cgColor
            valid = false
        }

        // starts
        if startDate == nil {
            valid = false
            errorsOnTextField(startTimeTextField)
        } else {
            removeTextFieldErrors(startTimeTextField)
        }
        
        // ends
        if endDate == nil {
            valid = false
            errorsOnTextField(durationTextField)
        } else {
            removeTextFieldErrors(durationTextField)
        }
        
        // party #
        if groupSizeField.text == nil || (Int(groupSizeField.text!) == nil) {
            valid = false
            errorsOnTextField(groupSizeField)
        } else {
            removeTextFieldErrors(groupSizeField)
        }
        
        if location ==  nil {
            valid = false
            errorsOnTextField(locationTextField)
        } else {
            removeTextFieldErrors(locationTextField)
        }
        
        return valid
    }
 
    func onCategory(categoryPicker: CategoryViewController, didPickCategory: String) {
        category = didPickCategory
        let icon = Activity.defaultCategories[category!]
        print("set activity category=\(category)")
        categoryButton.setTitle("", for: .normal)
        categoryButton.imageView?.contentMode = .scaleAspectFit
        categoryButton.setImage(icon, for: .normal)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let categoryVC = segue.destination as! CategoryViewController
        categoryVC.delegate = self
    }
    
    func errorsOnTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.red.cgColor
        textField.borderStyle = .roundedRect
    }
    func removeTextFieldErrors(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.borderStyle = .none
    }
}

extension ActivityEditController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("user chose formatted address: \(place.formattedAddress)")
        self.locationAddress = place.formattedAddress
        self.locationTextField.text = self.locationAddress
        self.location = Location(lat: place.coordinate.latitude, long: place.coordinate.longitude)
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
