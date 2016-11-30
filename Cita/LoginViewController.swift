//
//  ViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/7/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

protocol LoginEventObserver {
    func setLoginState(_ loggedIn: Bool)
}

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var loadingSpinnerAIV: UIActivityIndicatorView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.layer.cornerRadius = 8
        logoImageView.clipsToBounds = true
        logoImageView.isHidden = true
        loginButton.isHidden = true
        loginButton.readPermissions = User.facebookProfileKeys
        loginButton.delegate = self
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        loadingSpinnerAIV.startAnimating()
        loginButton.isHidden = true
        logoImageView.isHidden = true
        
        if error != nil {
            setLoginState(false, error: error)
        } else if result.isCancelled  {  //handle cancel event
            setLoginState(false, error: nil)
        } else { // got oauth token
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (firUser, error) in
                if let firUser = firUser {
                    // we need to fetch the firebase user
                    //firUser.
                    //let user = User(user: firUser)
                    User.currentUser = User.userCache[firUser.uid]//user
                    print(User.currentUser as Any)
                } else {
                    self.setLoginState(false, error: error)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        setLoginState(false, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setLoginState(_ loggedIn: Bool, error: Error?) {
//        guard loginButton != nil else { return }
        
        loginButton.isHidden = loggedIn
        logoImageView.isHidden = loggedIn
        loginErrorLabel.isHidden = true
        loadingSpinnerAIV.stopAnimating()
        if let error = error {
            loginErrorLabel.text = "Login failed: \(error.localizedDescription)"
        }
    }
}

