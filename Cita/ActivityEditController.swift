//
//  ActivityEditController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import GooglePlaces
/*
@objc protocol CategoryViewDelegate {
    @objc func onCategory(categoryPicker: CategoryViewController, didPickCategory: String)
}
*/
class ActivityEditController: UIViewController, UITextFieldDelegate, UITextViewDelegate /*CategoryViewDelegate*/ {
    
    @IBOutlet weak var categoryCollection: UICollectionView!
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
    
    @IBOutlet weak var createButton: UIButton!
    
    //weak var delegate: CategoryViewDelegate?
    var selectedIndex: Int?
    
    var startTimePicker: UIDatePicker!
    var durationPicker: UIDatePicker!
    let timeFormatter = DateFormatter()
    
    var location: Location?
    var locationAddress: String?
    var startDate: Date?
    var endDate: Date?
    var countdownDuration: Double?
    var durationText: String?
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Activity"
        
        // borders/styling
        addBordersStyles()
        // start time/duration
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
        

        
        // Register cell xib
        categoryCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self

        categoryCollection.allowsMultipleSelection = false;
        categoryCollection.allowsSelection = true;
        
        createButton.clipsToBounds = true
        createButton.layer.cornerRadius = 7
        
        nameTextField.returnKeyType = .done
        groupSizeField.returnKeyType = .done
        startTimeTextField.returnKeyType = .done
        durationTextField.returnKeyType = .done
        descriptionTextView.returnKeyType = .done
    }
    override func viewWillAppear(_ animated: Bool) {
        categoryCollection.selectItem(at: categoryCollection.indexPathForItem(at: CGPoint(x:0,y:0)), animated: false, scrollPosition: UICollectionViewScrollPosition.top)
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
        durationPicker.addTarget(self, action: #selector(setDuration), for: .valueChanged)
    }
    
    func addDelegatesListeners() {
        nameTextField.delegate = self
        locationTextField.delegate = self
        startTimeTextField.delegate = self
        durationTextField.delegate = self
        groupSizeField.delegate = self
        descriptionTextView.delegate = self
        
        /*
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        */
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.descriptionView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            //            self.descriptionView.frame.origin.y = self.initialDescriptionViewY
        }
    }
    
    @IBAction func onLocationTap(_ sender: Any) {
        print(#function)
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        print(#function)
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        print(#function)
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
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
        if textField.layer.borderColor == UIColor.red.cgColor {
            removeTextFieldErrors(textField)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        self.view.endEditing(true)
        return false
        
        //return true if we're a textarea
        //return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        print(#function)
    }
    
    func setStartTime() {
        let timeText = timeFormatter.string(from: startTimePicker.date)
        print("chose start time \(timeText)")
        startDate = startTimePicker.date
        startTimeTextField.text = timeText
    }
    
    func setDuration() {
        countdownDuration = durationPicker.countDownDuration
        durationTextField.text = Activity.durationText(countdownDuration!)
    }
    
    @IBAction func didCancel(_ sender: Any) {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonAction(_ sender: Any) {
        print(#function)
        if validateFields() {
            endDate = startDate! + countdownDuration!
            let activity = Activity(dictionary: [:])
            activity.name = nameTextField.text!
            activity.category = Activity.categoryNames[selectedIndex!]
            activity.fullDescription = descriptionTextView.text!
            activity.groupSize = Int(groupSizeField.text!)
            activity.startTime = startDate!
            activity.endTime = endDate!
            activity.countdownDuration = countdownDuration!
            activity.location = location!
            activity.address = locationTextField.text!
            activity.creator = User.currentUser
            activity.attendees = []
            activity.attendeeIDs = []
            activity.save()
            
            let activityKey = "\(startDate!.iso8601DatePart)/\(activity.key!)"
            
            User.currentUser!.creatorKeys!.append(activityKey)
            User.currentUser!.save()
            
            print("trying to dismiss")
            
            navigationController?.popViewController(animated: true)
            
            //dismiss(animated: true, completion: nil)
        }
        else {
            print("invalid fields")
        }
    }
    
    func validateFields() -> Bool {
        print(#function)
        var valid = true
        
        // name
        if nameTextField?.text == nil || nameTextField.text!.characters.count < 4 {
            valid = false
            errorsOnTextField(nameTextField)
            nameInvalidLabel.isHidden = false
        } else {
            removeTextFieldErrors(nameTextField)
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
        if selectedIndex == nil {
            categoryCollection.layer.borderWidth = 1
            categoryCollection.layer.borderColor = UIColor.red.cgColor
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
        if countdownDuration == nil {
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
        print(#function)
        category = didPickCategory
        let icon = Activity.defaultCategories[category!]
        print("set activity category=\(category)")
        categoryButton.setTitle("", for: .normal)
        categoryButton.imageView?.contentMode = .scaleAspectFit
        categoryButton.setImage(icon, for: .normal)
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

extension ActivityEditController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(#function)
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        // #warning Incomplete implementation, return the number of items
        return Activity.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        // Configure the cell
        let name = Activity.categoryNames[indexPath.row]
        cell.categoryNameLabel.text = name
        cell.iconImage.image = Activity.defaultCategories[name]
        cell.bgView.backgroundColor = UIColor.lightGray
        //cell.bgView.layer.borderColor = UIColor.gray.cgColor
        //cell.bgView.layer.borderWidth = 2
        cell.bgView.layer.cornerRadius = 5
        cell.bgView.clipsToBounds = true
        
        if indexPath.row == selectedIndex {
            cell.bgView.backgroundColor = UIColor.citaGreen
        } else {
            
        }
        
        return cell
    }
    /*
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("Selected cell number: \(indexPath.row)")
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print("picked \(selectedIndex)")
        collectionView.reloadData()
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(#function)
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        print(#function)
        return 1
    }
}

