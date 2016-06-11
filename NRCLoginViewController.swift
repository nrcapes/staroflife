//
//  NRCLoginViewController.swift
//  EMS Timers Professional
//
//  Created by Nelson Capes on 6/8/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

import UIKit
import CoreData
class NRCLoginViewController: UIViewController, UITextFieldDelegate{
    var managedObjectContext: NSManagedObjectContext? = nil
    let MyKeychainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var createInfoLabel: UILabel!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == password {
            animateViewMoving(true, moveValue: 90)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if  textField == password {
            animateViewMoving(false, moveValue: 90)
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        view.backgroundColor = UIColor(white: 0x255/255, alpha: 1.0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.delegate = self;
        self.password.delegate = self;
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        view.backgroundColor = UIColor(white: 0x255/255, alpha: 1.0)
        
        
        //set the background color to blue-green
        view.backgroundColor = UIColor(
            red: 0x00/255,
            green: 0x7d/255,
            blue: 0x96/255,
            alpha: 1.0)
        
        // 1.
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        
        // 2.
        if hasLogin {
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            loginButton.tag = loginButtonTag
            createInfoLabel.hidden = true
        } else {
            loginButton.setTitle("Create", forState: UIControlState.Normal)
            loginButton.tag = createLoginButtonTag
            createInfoLabel.hidden = false
        }
        
        // 3.
        if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
            username.text = storedUsername as String
        }
    }
    
    // MARK: - Action for checking username/password
    @IBAction func loginAction(sender: AnyObject) {
        
        // 1.
        if (username.text == "" || password.text == "") {
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong username or password." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Re-enter", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return;
        }
        
        // 2.
        username.resignFirstResponder()
        password.resignFirstResponder()
        
        // 3.
        if sender.tag == createLoginButtonTag {
            
            // 4.
            let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
            if hasLoginKey == false {
                NSUserDefaults.standardUserDefaults().setValue(self.username.text, forKey: "username")
            }
            
            // 5.
            MyKeychainWrapper.mySetObject(password.text, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            loginButton.tag = loginButtonTag
            
            performSegueWithIdentifier("unwindFromLogin:", sender: self)
        } else if sender.tag == loginButtonTag {
            // 6.
            if checkLogin(username.text!, password: password.text!) {
                performSegueWithIdentifier("unwindFromLogin:", sender: self)
            } else {
                // 7.
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password." as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "Re-enter", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func checkLogin(username: String, password: String ) -> Bool {
        if password == MyKeychainWrapper.myObjectForKey("v_Data") as? String &&
            username == NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
            return true
        } else {
            return false
        }
    }
    
}


