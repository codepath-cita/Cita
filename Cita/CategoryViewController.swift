//
//  CategoryViewController.swift
//  Cita
//
//  Created by Stephen Chudleigh on 12/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol CategoryViewDelegate {
    @objc func onCategory(categoryPicker: CategoryViewController, didPickCategory: String)
}
class CategoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CategoryViewDelegate?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // Register cell xib
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressOk(_ sender: UIButton) {
        if let selectedIndex = selectedIndex {
            let category = Activity.categoryNames[selectedIndex]
            delegate?.onCategory(categoryPicker: self, didPickCategory: category)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension CategoryViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        cell.categoryNameLabel.text = name
        cell.iconImage.image = Activity.categoryIcons[name]
        if indexPath.row == selectedIndex {
            cell.bgView.backgroundColor = UIColor.citaGreen
        } else {
            cell.bgView.backgroundColor = UIColor.citaYellow
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print("picked \(selectedIndex)")
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
}
