/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData
import LocalAuthentication
import Security

class LoginViewController: UIViewController {
  
  var managedObjectContext: NSManagedObjectContext? = nil
  
  let usernameKey = "batman"
  let passwordKey = "Hello Bruce!"
  
  let MyKeychainWrapper = KeychainWrapper()
  let createLoginButtonTag = 0
  let loginButtonTag = 1
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var touchIDButton: UIButton!
  @IBOutlet weak var onepasswordSigninButton: UIButton!
  
  var context = LAContext()
  
  let MyOnePassword = OnePasswordExtension()
  var has1PasswordLogin: Bool = false
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var createInfoLabel: UILabel!  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1.
    let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
    
    // 2.
    if hasLogin {
      loginButton.setTitle("Login", forState: UIControlState.Normal)
      loginButton.tag = loginButtonTag
      createInfoLabel.hidden = true
      onepasswordSigninButton.enabled = true
    } else {
      loginButton.setTitle("Create", forState: UIControlState.Normal)
      loginButton.tag = createLoginButtonTag
      createInfoLabel.hidden = false
      onepasswordSigninButton.enabled = false
    }
    
    // 3.
    if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
      usernameTextField.text = storedUsername as String
    }
    
    touchIDButton.hidden = true
    
    if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) {
      touchIDButton.hidden = false
    }
    
    onepasswordSigninButton.hidden = true
    let has1Password = NSUserDefaults.standardUserDefaults().boolForKey("has1PassLogin")
    
    if MyOnePassword.isAppExtensionAvailable() {
      onepasswordSigninButton.hidden = false
      if has1Password {
        onepasswordSigninButton.setImage(UIImage(named: "onepassword-button") , forState: .Normal)
      } else {
        onepasswordSigninButton.setImage(UIImage(named: "onepassword-button-green") , forState: .Normal)
      }
    }
  }
  
  // MARK: - Action for checking username/password
  @IBAction func loginAction(sender: AnyObject) {
    
    // 1.
    if (usernameTextField.text == "" || passwordTextField.text == "") {
      let alertView = UIAlertController(title: "Login Problem",
        message: "Wrong username or password." as String, preferredStyle:.Alert)
      let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
      alertView.addAction(okAction)
      self.presentViewController(alertView, animated: true, completion: nil)
      return;
    }
    
    // 2.
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    
    // 3.
    if sender.tag == createLoginButtonTag {
      
      // 4.
      let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
      if hasLoginKey == false {
        NSUserDefaults.standardUserDefaults().setValue(self.usernameTextField.text, forKey: "username")
      }
      
      // 5.
      MyKeychainWrapper.mySetObject(passwordTextField.text, forKey:kSecValueData)
      MyKeychainWrapper.writeToKeychain()
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
      NSUserDefaults.standardUserDefaults().synchronize()
      loginButton.tag = loginButtonTag
      
      performSegueWithIdentifier("dismissLogin", sender: self)
    } else if sender.tag == loginButtonTag {
      // 6.
      if checkLogin(usernameTextField.text!, password: passwordTextField.text!) {
        performSegueWithIdentifier("dismissLogin", sender: self)
      } else {
        // 7.
        let alertView = UIAlertController(title: "Login Problem",
          message: "Wrong username or password." as String, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
      }
    }
  }
  
  func saveLoginTo1Password(sender: AnyObject) {
    // 1.
    // TODO the username & pass should be unwrapped?
    // Here we should test whether the username and passowrd are not nil.
    // They should be equal to what's currently in the two textfields
    // later they will be checked against the credentials in the Keychain
    let newLoginDetails : NSDictionary = [
      AppExtensionTitleKey: "Touch Me In",
      AppExtensionUsernameKey: self.usernameTextField.text!,
      AppExtensionPasswordKey: self.passwordTextField.text!,
      AppExtensionNotesKey: "Saved with the TouchMeIn app",
      AppExtensionSectionTitleKey: "Touch Me In app",
    ]
    
    // 2.
    let passwordGenerationOptions : NSDictionary = [
      AppExtensionGeneratedPasswordMinLengthKey: "6",
      AppExtensionGeneratedPasswordMaxLengthKey: "50"
    ]
    
    // 3.
    MyOnePassword.storeLoginForURLString("TouchMeIn.Login",
      loginDetails: newLoginDetails as! [String : String],
      passwordGenerationOptions: passwordGenerationOptions as! [String : String],
      forViewController: self, sender: sender) { (loginDict : [NSObject : AnyObject]!,
        error : NSError!) -> Void in
        
        // 4.
        if loginDict == nil {
          if error.code != AppExtensionErrorCodeCancelledByUser {
            print("Error invoking 1Password App Extension for find login: \(error)")
          }
          return
        }
        
        // 5.
        let foundUsername = loginDict["username"] as! String
        let foundPassword = loginDict["password"] as! String
        
        // 6.
        if self.checkLogin(foundUsername, password: foundPassword) {
          
          self.performSegueWithIdentifier("dismissLogin", sender: self)
          
        } else {
          
          // 7.
          let alertView = UIAlertController(title: "Error", message: "The info in 1Password is incorrect" as String, preferredStyle:.Alert)
          let okAction = UIAlertAction(title: "Darn!", style: .Default, handler: nil)
          alertView.addAction(okAction)
          self.presentViewController(alertView, animated: true, completion: nil)
          
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("username") != nil {
          NSUserDefaults.standardUserDefaults().setValue(self.usernameTextField.text, forKey: "username")
        }
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "has1PassLogin")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  // MARK: - Login with 1Password
  @IBAction func findLoginFrom1Password(sender: AnyObject) {
    
    MyOnePassword.findLoginForURLString( "TouchMeIn.Login",
      forViewController: self,
      sender: sender,
      completion: { (loginDict : [NSObject: AnyObject]!, error : NSError!) -> Void in
        
        // 1.
        if loginDict == nil {
          if error.code != AppExtensionErrorCodeCancelledByUser {
            print("Error invoking 1Password App Extension for find login: \(error)")
          }
          return
        }
        
        // 2.
        if NSUserDefaults.standardUserDefaults().objectForKey("username") == nil {
          NSUserDefaults.standardUserDefaults().setValue(loginDict[AppExtensionUsernameKey],
            forKey: "username")
          NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        // 3.
        let foundUsername = loginDict["username"] as! String
        let foundPassword = loginDict["password"] as! String
        
        if self.checkLogin(foundUsername, password: foundPassword) {
          
          self.performSegueWithIdentifier("dismissLogin", sender: self)
          
        } else {
          
          let alertView = UIAlertController(title: "Error",
            message: "The info in 1Password is incorrect" as String, preferredStyle:.Alert)
          let okAction = UIAlertAction(title: "Darn!", style: .Default, handler: nil)
          alertView.addAction(okAction)
          self.presentViewController(alertView, animated: true, completion: nil)
        }
        
    })
  }

  
  // MARK: - Login with TouchID
  
  @IBAction func touchIDLoginAction() {
    // 1.
    if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:nil) {
      
      // 2.
      context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
        localizedReason: "Logging in with Touch ID",
        reply: { (success : Bool, error : NSError? ) -> Void in
          
          // 3.
          dispatch_async(dispatch_get_main_queue(), {
            if success {
              self.performSegueWithIdentifier("dismissLogin", sender: self)
            }
            
            if error != nil {
              
              var message : NSString
              var showAlert : Bool
              
              // 4.
              switch(error!.code) {
              case LAError.AuthenticationFailed.rawValue:
                message = "There was a problem verifying your identity."
                showAlert = true
                break;
              case LAError.UserCancel.rawValue:
                message = "You pressed cancel."
                showAlert = true
                break;
              case LAError.UserFallback.rawValue:
                message = "You pressed password."
                showAlert = true
                break;
              default:
                showAlert = true
                message = "Touch ID may not be configured"
                break;
              }
              
              let alertView = UIAlertController(title: "Error",
                message: message as String, preferredStyle:.Alert)
              let okAction = UIAlertAction(title: "Darn!", style: .Default, handler: nil)
              alertView.addAction(okAction)
              if showAlert {
                self.presentViewController(alertView, animated: true, completion: nil)
              }
              
            }
          })
          
      })
    } else {
      // 5.
      let alertView = UIAlertController(title: "Error",
        message: "Touch ID not available" as String, preferredStyle:.Alert)
      let okAction = UIAlertAction(title: "Darn!", style: .Default, handler: nil)
      alertView.addAction(okAction)
      self.presentViewController(alertView, animated: true, completion: nil)
      
    }
    
  }
  
  @IBAction func canUse1Password(sender: AnyObject) {
    if NSUserDefaults.standardUserDefaults().objectForKey("has1PassLogin") != nil {
      self.findLoginFrom1Password(self)
    } else {
      self.saveLoginTo1Password(self)
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
