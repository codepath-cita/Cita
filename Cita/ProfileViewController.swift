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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        
        if user == nil {
            user = User.currentUser
            logoutButton.titleLabel?.text = "Log Out"
        } else {
            logoutButton.titleLabel?.text = "Email"
        }
        
        userNameLabel.text = user.displayName
        userEmailLabel.text = user.email
        if let photoUrl = user.photoURL,
            let data = try? Data(contentsOf: photoUrl) {
            avatarImageView.image = UIImage(data: data)
        }
        
        logoutButton.layer.cornerRadius = 7
        logoutButton.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        // Signs user out of Firebase
        try! FIRAuth.auth()!.signOut()
        //Signs user out of Facebook
        FBSDKAccessToken.setCurrent(nil)
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
