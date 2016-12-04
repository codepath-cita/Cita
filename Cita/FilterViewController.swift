//
//  FilterViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    @objc optional func filterViewController(filterViewController: FilterViewController, filter: Filter)
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startsAfterTextField: UITextField!
    @IBOutlet weak var startsBeforeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
    var startsAfterText: String?
    var startsAfterPicker: UIDatePicker!
    var startsBeforeText: String?
    var startsBeforePicker: UIDatePicker!
    let timeFormatter = DateFormatter()
    
    weak var delegate: FilterViewControllerDelegate?
    
    var filter: Filter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true;
        
        // Register cell xib
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        
        timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .short
        
        startsAfterPicker = UIDatePicker()
        startsAfterPicker.date = filter.dateRange.earliest
        startsAfterPicker.datePickerMode = .dateAndTime
        startsAfterPicker.minimumDate = 30.minutes.fromNow()
        startsAfterPicker.minuteInterval = 10
        startsAfterTextField.inputView = startsAfterPicker
        startsAfterPicker.addTarget(self, action: #selector(setStartAfterTime), for: .valueChanged)
        
        startsBeforePicker = UIDatePicker()
        startsBeforePicker.date = filter.dateRange.latest
        startsBeforePicker.datePickerMode = .dateAndTime
        startsBeforePicker.minimumDate = 30.minutes.fromNow()
        startsBeforePicker.minuteInterval = 10
        startsBeforeTextField.inputView = startsBeforePicker
        startsBeforePicker.addTarget(self, action: #selector(setStartBeforeTime), for: .valueChanged)
        updateDateText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        delegate?.filterViewController?(filterViewController: self, filter: self.filter)
    }
    
    func setStartAfterTime() {
        let dateRange = DateRange(earliest: startsAfterPicker.date, latest: filter.dateRange.latest)
        filter.dateRange = dateRange
        updateDateText()
    }
    
    func setStartBeforeTime() {
        let dateRange = DateRange(earliest: filter.dateRange.earliest, latest: startsBeforePicker.date)
        filter.dateRange = dateRange
        updateDateText()
    }
    
    func updateDateText() {
        startsAfterText = timeFormatter.string(from: filter.dateRange.earliest)
        startsAfterTextField.text = startsAfterText
        startsBeforeText = timeFormatter.string(from: filter.dateRange.latest)
        startsBeforeTextField.text = startsBeforeText
    }
}
extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Activity.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        // Configure the cell
        let name = Activity.categoryNames[indexPath.row]
        let selected = filter.categories.index(of: name)
        cell.categoryNameLabel.text = name
        cell.iconImage.image = Activity.defaultCategories[name]
        if selected != nil {
            cell.isSelected = (selected != nil)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        }
        cell.setSelectedState()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !collectionView.cellForItem(at: indexPath)!.isSelected
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return collectionView.cellForItem(at: indexPath)!.isSelected
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        cell.setSelectedState()
        let selected = Activity.categoryNames[indexPath.row]
        print("picked \(selected)")
        if filter.categories.index(of: selected)==nil {
            filter.categories.append(selected)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        cell.setSelectedState()
        let selected = Activity.categoryNames[indexPath.row]
        print("removed \(selected)")
        if let index = filter.categories.index(of: selected) {
            filter.categories.remove(at: index)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
}
