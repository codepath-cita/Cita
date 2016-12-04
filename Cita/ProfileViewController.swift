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
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var lastLoginLabel: UILabel!
    @IBOutlet weak var activitiesCreatedCountLabel: UILabel!
    @IBOutlet weak var activitiesCountLabel: UILabel!
    
    var user: User!
    var profileCurrentUser: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.shadowColor = UIColor.black.cgColor
        avatarImageView.layer.shadowRadius = 2
        avatarImageView.layer.shadowOpacity = 1
        avatarImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        logoutButton.backgroundColor = UIColor.citaYellow
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.citaDarkYellow.cgColor
        
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
        
        logoutButton.layer.cornerRadius = 7
        logoutButton.clipsToBounds = true
        logoutButton.backgroundColor = UIColor.citaYellow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        if profileCurrentUser == true {
            // Signs user out of Firebase
            try! FIRAuth.auth()!.signOut()
            //Signs user out of Facebook
            FBSDKAccessToken.setCurrent(nil)
        } else {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
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
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismiss(animated: true, completion: nil)
        
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
