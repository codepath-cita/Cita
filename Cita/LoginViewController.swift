//
//  ViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/7/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var loadingSpinnerAIV: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.isHidden = true
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                self.present(homeViewController, animated: true, completion: nil)
               
            } else { 
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.loginButton.isHidden = false
            }
        }
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        loadingSpinnerAIV.startAnimating()
        self.loginButton.isHidden = true
        
        if error != nil {
            self.loginButton.isHidden = true
            loadingSpinnerAIV.stopAnimating()
        } else if result.isCancelled  {  //handle cancel event
            self.loginButton.isHidden = false
            loadingSpinnerAIV.stopAnimating()
        } else {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                print("User logged in to Firebase ")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

