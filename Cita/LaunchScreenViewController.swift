//
//  LaunchScreenViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/29/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

protocol LoginEventObserver {
    func setLoginState(_ loggedIn: Bool)
}

class LaunchScreenViewController: UIViewController {

    var launchView: UIView!
    var backgroundImageView: UIImageView! {get {return launchView.viewWithTag(1) as! UIImageView}}
    var backgroundFilterView: UIView! {get {return launchView.viewWithTag(2)!}}
    var containerView: UIView! {get {return launchView.viewWithTag(3)!}}
    var logoImageView: UIImageView! {get {return launchView.viewWithTag(4) as! UIImageView}}
    var logoNoFaceImageView: UIImageView! {get {return launchView.viewWithTag(10) as! UIImageView}}
    
    var citaLabel: UILabel! {get {return launchView.viewWithTag(5) as! UILabel}}
    var twinkleView: UIView! {get {return launchView.viewWithTag(6)!}}

    // login stuff
    var loadingSpinnerAIV: UIActivityIndicatorView! {get {return launchView.viewWithTag(7) as! UIActivityIndicatorView}}
    var buttonView: UIView! {get {return launchView.viewWithTag(8)}}
    var loginButton: FBSDKLoginButton!
    var loginErrorLabel: UILabel! {get {return launchView.viewWithTag(9) as! UILabel}}
    
    let animation = CABasicAnimation(keyPath: "bounds.size.width")

    required init() {
        super.init(nibName: nil, bundle: nil)
        print(#function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(#function)
    }

    override func loadView() {
        print(#function)
        
        var views:[Any] = Bundle.main.loadNibNamed("LaunchView", owner: self, options: nil)!
        launchView = views[0] as! UIView
        print("here are my view: \(views.count)")
        view = launchView
        //launchView.center = self.view.center
        //launchView.frame = self.view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoNoFaceImageView.image = logoNoFaceImageView.image!.withRenderingMode(.alwaysTemplate)
        self.logoNoFaceImageView.alpha = 0.0
        
        print(#function)
        var views:[Any] = Bundle.main.loadNibNamed("LoginButton", owner: self, options: nil)!
        loginButton = views[0] as! FBSDKLoginButton
        loginButton.frame = buttonView.bounds
        buttonView.addSubview(loginButton)
        loginButton.layer.cornerRadius = 4
        loginButton.clipsToBounds = true
        //loginButton.isHidden = false
        
        print("Current user \(User.currentUser)")
        
        loginButton.readPermissions = User.facebookProfileKeys
        loginButton.delegate = self
        
        self.citaLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.citaLabel.layer.shadowOpacity = 0
        self.citaLabel.layer.shadowRadius = 5
        self.citaLabel.layer.shadowColor = UIColor.red.cgColor
        
        self.logoImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.logoImageView.layer.shadowOpacity = 0
        self.logoImageView.layer.shadowRadius = 5
        self.logoImageView.layer.shadowColor = UIColor.red.cgColor
     
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        self.citaLabel.layer.add(animation, forKey: "shadowOpacity")
        self.logoImageView.layer.add(animation, forKey: "shadowOpacity")
        self.citaLabel.layer.shadowOpacity = 1
        self.logoImageView.layer.shadowOpacity = 1
        
        let _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);

        if (User.currentUser != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
        
    }

    func update(){
        Twinkle.twinkle(twinkleView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear loginButton.isHidden \(loginButton.isHidden)")
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        print("viewDidAppear loginButton.isHidden \(loginButton.isHidden)")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension LaunchScreenViewController: FBSDKLoginButtonDelegate {

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print(#function)
        loadingSpinnerAIV.startAnimating()

        self.logoNoFaceImageView.tintColor = UIColor.citaOrange
        self.buttonView.alpha = 1
        self.citaLabel.alpha = 0
        UIView.animate(withDuration: 1.0, animations: {
            self.buttonView.alpha = 0
            self.citaLabel.alpha = 1
        })
        self.buttonView.alpha = 0
        self.citaLabel.alpha = 1
        self.buttonView.isHidden = true
        self.citaLabel.isHidden = false
        
        if error != nil {
            setLoginState(false, error: error)
        } else if result.isCancelled  {  //handle cancel event
            setLoginState(false, error: nil)
        } else { // got oauth token
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (firUser, error) in
                if let firUser = firUser {
                    // we need to fetch the firebase user
                    if let user = User.userCache[firUser.uid] {
                        User.currentUser = user
                        User.currentUser?.lastLogin = Date(timeIntervalSinceNow: 0).string()
                        User.currentUser?.save()
                    } else {
                        print("logged in but userCache missing")
                    }
                } else {
                    self.setLoginState(false, error: error)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print(#function)
        setLoginState(false, error: nil)
    }    
    
    func setLoginState(_ loggedIn: Bool, error: Error?) {
        print(#function)
        print("loggedIn: \(loggedIn)")

        loadingSpinnerAIV.stopAnimating()
        loginErrorLabel.isHidden = true
        self.buttonView.isHidden = loggedIn
        //self.logoImageView.isHidden = loggedIn
        self.citaLabel.isHidden = !loggedIn
        
        self.logoNoFaceImageView.alpha = 0.0
        self.buttonView.alpha = 0
        
        UIView.animate(withDuration: 1.0, animations: {
            self.logoNoFaceImageView.alpha = 1.0
            self.logoNoFaceImageView.tintColor = UIColor.facebookBlue

            self.buttonView.alpha = 1
        })
        
        if let error = error {
            loginErrorLabel.text = "Login failed: \(error.localizedDescription)"
            loginErrorLabel.isHidden = false
        }
        print("setLoginState loginButton.isHidden \(loginButton.isHidden)")

    }
}
