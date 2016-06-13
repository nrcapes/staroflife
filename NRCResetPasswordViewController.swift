//
//  NRCResetPasswordViewController.swift
//  EMS Timers Professional
//
//  Created by Nelson Capes on 6/12/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

import UIKit
import CoreData
class NRCResetPasswordViewController: UIViewController, UITextFieldDelegate{
    var managedObjectContext: NSManagedObjectContext? = nil
    let MyKeychainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var createInfoLabel: UITextField!
    @IBOutlet weak var passwordcopy: UITextField!
    @IBOutlet weak var reset: UIButton!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == password || textField == passwordcopy) {
            animateViewMoving(true, moveValue: 90)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if  (textField == password || textField == passwordcopy) {
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
       // view.backgroundColor = UIColor(white: 0x255/255, alpha: 1.0)
    }
    
    func checkLogin(password: String ) -> Bool {
        if password == MyKeychainWrapper.myObjectForKey("v_Data") as? String  {
            return true
        } else {
            return false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPassword.delegate = self;
        self.password.delegate = self;
        self.passwordcopy.delegate = self;
        
        currentPassword.resignFirstResponder()
        password.resignFirstResponder()
        passwordcopy.resignFirstResponder()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
       // view.backgroundColor = UIColor(white: 0x255/255, alpha: 1.0)
        
        
        //set the background color to blue-green
        self.view.backgroundColor = UIColor(
            red: 0x00/255,
            green: 0x7d/255,
            blue: 0x96/255,
            alpha: 1.0)
        
        
    }
    
    // MARK: - Action for checking username/password
    @IBAction func resetAction(sender: AnyObject) {
    
        
        if checkLogin(currentPassword.text!) {
            
            if password.text != passwordcopy.text{
                let alertView = UIAlertController(title: "Login problem" ,
                                                  message: "Passwords don't match!" as String,
                                                  preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Re-enter", style:.Default, handler:nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated:true, completion:nil)
                return;
            }else{
            
            
            MyKeychainWrapper.mySetObject(password.text, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            performSegueWithIdentifier("toLogin", sender: self)}
            
            
            
        } else
        {
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong password." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Press any key to return", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            self.performSegueWithIdentifier("toLogin", sender: self)
        }
    
        
        }
}

            
        
    
    
    
    


