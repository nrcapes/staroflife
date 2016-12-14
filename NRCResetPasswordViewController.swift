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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == password || textField == passwordcopy) {
            animateViewMoving(true, moveValue: 70)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  (textField == password || textField == passwordcopy) {
            animateViewMoving(false, moveValue: 70)
        }
    }
    
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       // view.backgroundColor = UIColor(white: 0x255/255, alpha: 1.0)
    }
    
    func checkLogin(_ password: String ) -> Bool {
        if password == MyKeychainWrapper.myObject(forKey: "v_Data") as? String  {
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
    @IBAction func resetAction(_ sender: AnyObject) {
    
        
        if checkLogin(currentPassword.text!) {
            
            if password.text != passwordcopy.text{
                let alertView = UIAlertController(title: "Login problem" ,
                                                  message: "Passwords don't match!" as String,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Re-enter", style:.default, handler:nil)
                alertView.addAction(okAction)
                self.present(alertView, animated:true, completion:nil)
                return;
            }else{
            
            
            MyKeychainWrapper.mySetObject(password.text, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
                
            currentPassword.textColor = UIColor(red: 0x255/255, green: 0, blue: 0, alpha: 1.0)
            password.textColor = UIColor(red: 0, green: 0x200/255, blue: 0x55/255, alpha: 1.0)
            passwordcopy.textColor = UIColor(red: 0, green: 0x200/255, blue: 0x55/255, alpha: 1.0)
            }
        } else
        {
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong password." as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Press any key to return", style: .default, handler:nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
        }
        }
    
    
    @IBAction func finished(_ sender: AnyObject) {
      self.performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    
}

            
        
    
    
    
    


