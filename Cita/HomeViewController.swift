//
//  HomeViewController.swift
//  Cita
//
//  Created by SGLMR on 14/11/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.avatarImageView.layer.cornerRadius = self.avatarImageView.layer.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid;  // The user's ID, unique to the Firebase project.

            userNameLabel.text = name
            let data = try! Data(contentsOf: photoUrl!)
            avatarImageView.image = UIImage(data: data)
            
        } else {
            // No user is signed in.
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        // Signs user out of Firebase
        try! FIRAuth.auth()!.signOut()
        
        //Signs user out of Facebook
        FBSDKAccessToken.setCurrent(nil)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginViewController , animated: true, completion: nil)
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
