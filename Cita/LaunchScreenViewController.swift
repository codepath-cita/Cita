//
//  LaunchScreenViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/29/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
//import Twinkle

class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var citaLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundFilterView: UIView!
    @IBOutlet weak var twinkleView: UIView!
    
    let animation = CABasicAnimation(keyPath: "bounds.size.width")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.backgroundFilterView.backgroundColor = UIColor(red: 0.0, green: 255.0 , blue: 255.0, alpha: 1.0)
        
        self.citaLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.citaLabel.layer.shadowOpacity = 0
        self.citaLabel.layer.shadowRadius = 5
        self.citaLabel.layer.shadowColor = UIColor.red.cgColor
        //self.citaLabel.layer.shadowOpacity = 1
        
        //logoImageView.tintColor = UIColor.red
        
        self.logoImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.logoImageView.layer.shadowOpacity = 0
        self.logoImageView.layer.shadowRadius = 5
        self.logoImageView.layer.shadowColor = UIColor.red.cgColor
        
        /*
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        self.citaLabel.layer.add(animation, forKey: "shadowOpacity")
        self.logoImageView.layer.add(animation, forKey: "shadowOpacity")
*/

        
        
        /*
        view.twinkle()
        view.twinkle()
        view.twinkle()
    
        var timer = Timer.init(timeInterval: 3, repeats: true, block: { timer in
            Twinkle.twinkle(self.backgroundFilterView)
        })
        */
        let _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);

        
        //Twinkle.twinkle(logoImageView)
        //Twinkle.twinkle(citaLabel)
    }

    func update(){
        Twinkle.twinkle(twinkleView)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
/*
        DispatchQueue(label: "com.queue.Serial").async(execute: {
            self.performAnimation()
        })
        */
    }
    
    func performAnimation() {
        

        UIView.animate(withDuration: 10.0, delay: 0.5, options: [ .repeat , .autoreverse],animations: {
            self.backgroundFilterView.alpha = 0.8
            //self.citaLabel.layer.shadowOpacity = 1
        }, completion: nil)
        
    }
    /*
    override func viewDidAppear(_ animated: Bool) {
        
        
        DispatchQueue.global().async (execute: {
            self.performAnimation()
            
        })

    }

    func performAnimation(){
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.citaLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.citaLabel.layer.shadowOpacity = 1
            self.citaLabel.layer.shadowRadius = 5
            self.citaLabel.layer.shadowColor = UIColor.yellow.cgColor
            
        }, completion: nil)
    }
    */
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
