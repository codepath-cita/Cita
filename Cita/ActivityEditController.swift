//
//  ActivityEditController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import GooglePlaces

class ActivityEditController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var containerCollectionView: UIView!
    @IBOutlet weak var descriptionIcon: UIImageView!
    @IBOutlet weak var groupSizeIcon: UIImageView!
    @IBOutlet weak var durationIcon: UIImageView!
    @IBOutlet weak var startIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var activityNameIcon: UIImageView!
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
    @IBOutlet weak var createButton: CitaButton!
    
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
        
        // styling
        addStyles()
        
        // start time/duration
        addSelectors()
        
        // notifications/observers
        addDelegatesListeners()
        
        // Register cell xib
        categoryCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.allowsMultipleSelection = false;
        categoryCollection.allowsSelection = true;
        categoryCollection.layer.cornerRadius = 7
        categoryCollection.clipsToBounds = true
        
        let screenWidth = self.view.frame.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        layout.itemSize = CGSize(width: screenWidth/3 - 16, height: 28)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        categoryCollection!.collectionViewLayout = layout
        
        createButton.style(borderColor: UIColor.citaDarkGray, backgroundColor: UIColor.citaGreen)
        
        nameTextField.returnKeyType = .done
        groupSizeField.returnKeyType = .done
        startTimeTextField.returnKeyType = .done
        durationTextField.returnKeyType = .done
        descriptionTextView.returnKeyType = .done
    }
    override func viewWillAppear(_ animated: Bool) {
        categoryCollection.selectItem(at: categoryCollection.indexPathForItem(at: CGPoint(x:0,y:0)), animated: false, scrollPosition: UICollectionViewScrollPosition.top)
    }
    
    func addStyles() {
        if (locationAddress != nil) {
            locationTextField.text = locationAddress
        }
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = UIColor.citaLightLightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 5
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderColor = UIColor.white.cgColor
        nameTextField.textColor = UIColor.citaLightGray
        activityNameIcon.image = activityNameIcon.image!.withRenderingMode(.alwaysTemplate)
        activityNameIcon.tintColor = UIColor.citaLightGray
        
        locationView.layer.borderWidth = 1
        locationView.layer.borderColor = UIColor.citaLightLightGray.cgColor
        locationTextField.layer.borderWidth = 1.0
        locationTextField.layer.cornerRadius = 5
        locationTextField.borderStyle = .roundedRect
        locationTextField.layer.borderColor = UIColor.white.cgColor
        locationTextField.textColor = UIColor.citaLightGray
        locationIcon.image = locationIcon.image!.withRenderingMode(.alwaysTemplate)
        locationIcon.tintColor = UIColor.citaLightGray
        
        startView.layer.borderWidth = 1
        startView.layer.borderColor = UIColor.citaLightLightGray.cgColor
        startTimeTextField.layer.borderWidth = 1.0
        startTimeTextField.layer.cornerRadius = 5
        startTimeTextField.borderStyle = .roundedRect
        startTimeTextField.layer.borderColor = UIColor.white.cgColor
        startTimeTextField.textColor = UIColor.citaLightGray
        startIcon.image = startIcon.image!.withRenderingMode(.alwaysTemplate)
        startIcon.tintColor = UIColor.citaLightGray
        
        endView.layer.borderWidth = 1
        endView.layer.borderColor = UIColor.citaLightLightGray.cgColor
        durationTextField.layer.borderWidth = 1.0
        durationTextField.layer.cornerRadius = 5
        durationTextField.borderStyle = .roundedRect
        durationTextField.layer.borderColor = UIColor.white.cgColor
        durationTextField.textColor = UIColor.citaLightGray
        durationIcon.image = durationIcon.image!.withRenderingMode(.alwaysTemplate)
        durationIcon.tintColor = UIColor.citaLightGray
        
        peopleView.layer.borderWidth = 1
        peopleView.layer.borderColor = UIColor.citaLightLightGray.cgColor
        groupSizeField.layer.borderWidth = 1.0
        groupSizeField.layer.cornerRadius = 5
        groupSizeField.borderStyle = .roundedRect
        groupSizeField.layer.borderColor = UIColor.white.cgColor
        groupSizeField.textColor = UIColor.citaLightGray
        groupSizeIcon.image = groupSizeIcon.image!.withRenderingMode(.alwaysTemplate)
        groupSizeIcon.tintColor = UIColor.citaLightGray
        
        descriptionView.layer.borderWidth = 1
        descriptionView.layer.borderColor = UIColor.citaLightLightGray.cgColor
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.citaLightGray
        descriptionTextView.layer.borderColor = UIColor.white.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5
        descriptionIcon.image = descriptionIcon.image!.withRenderingMode(.alwaysTemplate)
        descriptionIcon.tintColor = UIColor.citaLightGray
        
        categoryCollection.layer.borderWidth = 1
        categoryCollection.layer.borderColor = UIColor.white.cgColor
        containerCollectionView.layer.borderWidth = 1
        containerCollectionView.layer.borderColor = UIColor.citaLightLightGray.cgColor
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
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.descriptionView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            // nothing to do here
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
        print(#function)
        if textView.textColor == UIColor.citaLightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(#function)
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.citaLightGray
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
        createButton.animate {
             if self.validateFields() {
                self.endDate = self.startDate! + self.countdownDuration!
                let activity = Activity(dictionary: [:])
                activity.name = self.nameTextField.text!
                activity.category = Activity.categoryNames[self.selectedIndex!]
                activity.fullDescription = self.descriptionTextView.text!
                activity.groupSize = Int(self.groupSizeField.text!)
                activity.startTime = self.startDate!
                activity.endTime = self.endDate!
                activity.countdownDuration = self.countdownDuration!
                activity.location = self.location!
                activity.address = self.locationTextField.text!
                activity.creator = User.currentUser
                activity.attendees = []
                activity.attendeeIDs = []
                activity.save()
                
                let activityKey = "\(self.startDate!.iso8601DatePart)/\(activity.key!)"
                
                User.currentUser!.creatorKeys!.append(activityKey)
                if User.currentUser!.interests?.index(of: self.category!) == nil {
                    User.currentUser!.interests?.append(self.category!)
                }
                User.currentUser!.save()
                
                print("trying to dismiss")
                
                let _ = self.navigationController?.popViewController(animated: true)
             }
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
            descriptionInvalidLabel.isHidden = false
            valid = false
        } else {
            descriptionTextView.layer.borderColor = UIColor.white.cgColor
            descriptionInvalidLabel.isHidden = true
        }
        
        // category 
        if selectedIndex == nil {
            categoryCollection.layer.borderColor = UIColor.red.cgColor
            valid = false
        } else {
            categoryCollection.layer.borderColor = UIColor.white.cgColor
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

    func errorsOnTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.red.cgColor
    }
    func removeTextFieldErrors(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
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
        cell.categoryNameLabel.textColor = UIColor.citaLightGray
        
        cell.iconImage.image = Activity.categoryIcons[name]
        cell.iconImage.image = cell.iconImage.image!.withRenderingMode(.alwaysTemplate)
        cell.iconImage.tintColor = UIColor.citaLightGray
        
        cell.bgView.backgroundColor = UIColor(red: (250/255), green: (250/255), blue: (250/255), alpha: 1.0 )
        cell.bgView.layer.cornerRadius = 5
        cell.bgView.clipsToBounds = true
        cell.bgView.layer.borderWidth = 1
        cell.bgView.layer.borderColor = UIColor.citaLightGray.cgColor
        
        if indexPath.row == selectedIndex {
            cell.layer.shadowColor = UIColor.citaGreen.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowOpacity = 1
            cell.layer.shadowRadius = 1.0
            cell.clipsToBounds = false
            cell.layer.masksToBounds = false
            cell.bgView.backgroundColor = UIColor.citaLightLightGray
            cell.categoryNameLabel.textColor = UIColor.black
            cell.iconImage.tintColor = UIColor.black
            cell.bgView.layer.borderColor = UIColor.citaDarkGray.cgColor
        } else {
            cell.layer.shadowOpacity = 0
            cell.layer.shadowRadius = 0
        }
        
        return cell
    }
    
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

