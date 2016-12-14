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
    @IBOutlet weak var createInfoLabel: UITextField!
    @IBOutlet weak var passwordcopy: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == password || textField == passwordcopy) {
            animateViewMoving(true, moveValue: 90)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  (textField == password || textField == passwordcopy) {
            animateViewMoving(false, moveValue: 90)
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
    
    func checkLogin(_ username: String, password: String ) -> Bool {
        if password == MyKeychainWrapper.myObject(forKey: "v_Data") as? String &&
            username == UserDefaults.standard.value(forKey: "username") as? String {
            return true
        } else {
            return false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.delegate = self;
        self.password.delegate = self;
        self.passwordcopy.delegate = self;
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
       // view.backgroundColor = UIColor(white: 0x255/255, alpha: 1.0)
        
        
        //set the background color to blue-green
        self.view.backgroundColor = UIColor(
            red: 0x00/255,
            green: 0x7d/255,
            blue: 0x96/255,
            alpha: 1.0)
        
        // 1.
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        // 2.
        if hasLogin {
            loginButton.setTitle("Login", for: UIControlState())
            loginButton.tag = loginButtonTag
            createInfoLabel.isHidden = true
            passwordcopy.isHidden = true
        } else {
            loginButton.setTitle("Create", for: UIControlState())
            loginButton.tag = createLoginButtonTag
            createInfoLabel.isHidden = false
            passwordcopy.isHidden = false
        }
        
        // 3.
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            username.text = storedUsername as String
        }
    }
    
    
    
    @IBAction func resetPassword(_ sender: AnyObject) {
        
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if hasLoginKey == false {
            
            let alertView = UIAlertController(title: "Login Problem", message: "You have not set your user name and password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Press any key", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
            return
        }else{
            self.performSegue(withIdentifier: "reset", sender: self)
        }
    }
    
    
    // MARK: - Action for checking username/password
    @IBAction func loginAction(_ sender: AnyObject) {
    
        
        // 1.
        username.resignFirstResponder()
        password.resignFirstResponder()
        passwordcopy.resignFirstResponder()
        
        // 2.n
        
        if sender.tag == createLoginButtonTag{
            
            
            if (username.text == "" || password.text == "" || passwordcopy.text == "") {
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password." as String, preferredStyle:.alert)
                let okAction = UIAlertAction(title: "Re-enter", style: .default, handler: nil)
                alertView.addAction(okAction)
                self.present(alertView, animated: true, completion: nil)
                return;
            }
            
            if password.text != passwordcopy.text{
                let alertView = UIAlertController(title: "Login problem" ,
                                                  message: "Passwords don't match!" as String,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Re-enter", style:.default, handler:nil)
                alertView.addAction(okAction)
                self.present(alertView, animated:true, completion:nil)
                return;
            }



            // 4.
            
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if hasLoginKey == false {
                UserDefaults.standard.setValue(self.username.text, forKey: "username")
            }
            
            
            
            
            // 5.
            MyKeychainWrapper.mySetObject(password.text, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            UserDefaults.standard.synchronize()
            loginButton.tag = loginButtonTag
            
            performSegue(withIdentifier: "unwindFromLogin:", sender: self)
        
        
        }else if sender.tag == loginButtonTag {
                
                    if (username.text == "" || password.text == "") {
                        let alertView = UIAlertController(title: "Login Problem",
                                                          message: "Wrong username or password." as String, preferredStyle:.alert)
                        let okAction = UIAlertAction(title: "Re-enter", style: .default, handler: nil)
                        alertView.addAction(okAction)
                        self.present(alertView, animated: true, completion: nil)
                        return;
                    }
            
            
                else{
                    if checkLogin(username.text!, password: password.text!) {
                    performSegue(withIdentifier: "unwindFromLogin:", sender: self)
                    } else
                        {
                        let alertView = UIAlertController(title: "Login Problem",
                                                      message: "Wrong username or password." as String, preferredStyle:.alert)
                        let okAction = UIAlertAction(title: "Re-enter", style: .default, handler: nil)
                        alertView.addAction(okAction)
                        self.present(alertView, animated: true, completion: nil)
                }
                }
            }
        }
    @IBAction func unwindFromReset(_ sender: UIStoryboardSegue)
    {
        password.text = MyKeychainWrapper.myObject(forKey: "v_Data") as? String
        performSegue(withIdentifier: "unwindFromLogin:", sender: self)
    }
}
        

            
        
    
    
    
    


