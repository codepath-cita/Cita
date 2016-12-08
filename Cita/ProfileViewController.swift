//
//  ProfileViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/9/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth
import Foundation
import MessageUI

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var logoutButton: CitaButton!
    @IBOutlet weak var lastLoginLabel: UILabel!
    @IBOutlet weak var activitiesCreatedCountLabel: UILabel!
    @IBOutlet weak var activitiesCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    var profileCurrentUser: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.shadowColor = UIColor.black.cgColor
        avatarImageView.layer.shadowRadius = 2
        avatarImageView.layer.shadowOpacity = 1
        avatarImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        logoutButton.style(borderColor: UIColor.citaDarkYellow, backgroundColor: UIColor.citaYellow)
        
        if user == nil {
            user = User.currentUser
            logoutButton.setTitle("Log Out", for: .normal)
        } else {
            logoutButton.setTitle("Email", for: .normal)
            profileCurrentUser = false
        }
        
        userNameLabel.text = user.displayName
        userEmailLabel.text = user.email
        if let photoUrl = user.photoURL,
            let data = try? Data(contentsOf: photoUrl) {
            avatarImageView.image = UIImage(data: data)
        }
        
        lastLoginLabel.text = "Last login: " + (user.lastLogin ?? "")
        
        activitiesCreatedCountLabel.text = String(describing: user.creatorKeys!.count)
        activitiesCountLabel.text = String(describing: user.activityKeys!.count)
        user.fetchInterests() {
            collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        logoutButton.animate {
            if self.profileCurrentUser == true {
                // Signs user out of Firebase
                try! FIRAuth.auth()!.signOut()
                //Signs user out of Facebook
                FBSDKAccessToken.setCurrent(nil)
            } else {
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([user.email!])
        mailComposerVC.setSubject("Sending you an in-app e-mail about this activity...")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        /*
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")*/
        
        sendMailErrorAlert.show(self, sender: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.interests?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        
        // Configure the cell
        let name = user.interests![indexPath.row] as! String
        cell.nameLabel.text = name
        cell.iconImageView.image = Activity.categoryIcons[name]
        
        return cell
    }

}
