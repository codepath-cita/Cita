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
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        var containerLayer: CALayer = CALayer()
        containerLayer.shadowColor = UIColor.black.cgColor
        containerLayer.shadowRadius = 10
        containerLayer.shadowOffset = CGSize(width: 0, height: 5)
        containerLayer.shadowOpacity = 1
        */
        // use the image's layer to mask the image into a circle
        //image.layer.cornerRadius = roundf(image.frame.size.width/2.0);
        //image.layer.masksToBounds = YES;
        
        // add masked image layer into container layer so that it's shadowed
        //[containerLayer addSublayer:image.layer];
        
        // add container including masked image and shadow into view
        //[self.view.layer addSublayer:containerLayer];
        
        
        avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        
        //containerLayer.addSublayer(avatarImageView.layer)
        //self.view.layer.addSublayer(containerLayer)
        
        if user == nil {
            user = User.currentUser
            self.navigationItem.rightBarButtonItem  = logOutButton
        }
        
        userNameLabel.text = user.displayName
        userEmailLabel.text = user.email
        if let photoUrl = user.photoURL,
            let data = try? Data(contentsOf: photoUrl) {
            avatarImageView.image = UIImage(data: data)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogoutButton(_ sender: UIBarButtonItem) {
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
