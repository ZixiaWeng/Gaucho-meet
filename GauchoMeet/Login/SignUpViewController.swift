//
//  SignUpViewController.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 12/28/14.
//  Copyright (c) 2014 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var passWord2: UITextField!
    @IBOutlet weak var userGroup: UISegmentedControl!
    
    @IBOutlet weak var signupbutton: UIButton!
    @IBOutlet weak var profilePictureAddbuttton: UIButton!
    @IBOutlet weak var loginViewSignupTabbar: UINavigationBar!
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var loginActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var userGroups = ["stu", "fct"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupbutton.layer.cornerRadius = 5
        signupbutton.layer.borderWidth = 1
        signupbutton.layer.borderColor = UIColor.white.cgColor
        loginViewSignupTabbar.backgroundColor = UIColor.white
        
        // Delegates
        userName.delegate = self
        emailField.delegate = self
        passWord.delegate = self
        passWord2.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    
    
    // MARK: - TextField behaviors
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag:NSInteger = textField.tag + 1
        if nextTag == 4 {
            textField.resignFirstResponder()
            return true
        }
        let nextResponder = textField.superview!.viewWithTag(nextTag)! as UIResponder
        nextResponder.becomeFirstResponder()
        
        return false
    }
    
    // MARK: - Sign Up
    @IBAction func SignupButton(_ sender: AnyObject) {
        //activity view
        var loadingView: UIView = UIView()
        var loadingLabel: UILabel!
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loginActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0);
        loginActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loginActivityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        loadingView.addSubview(loginActivityIndicator)
        var username:NSString = userName.text
        var password:NSString = passWord.text
        var passwordAgain:NSString = passWord2.text
        var email:NSString = emailField.text
        
        if (username.length != 0 || password.length != 0 || passwordAgain.length != 0 || email.length != 0) {
            container.addSubview(loadingView)
            self.view.addSubview(container)
            loginActivityIndicator.startAnimating()
        }
        
        //sign up
        
        var usergroup:NSString = userGroups[userGroup.selectedSegmentIndex] as NSString
        var errorText:NSString = "Please"
        var anyBlank:NSString = " fill all the fields"
        var passwordMismatch:NSString = " enter the same password twice"
        
        var textError = false
        
        if (username.length == 0 || email.length == 0 || password.length == 0 || passwordAgain.length == 0) {
            textError = true;
            if username.length == 0 {
                userName.becomeFirstResponder()
            }
            else if email.length == 0 {
                emailField.becomeFirstResponder()
            }
            else if password.length == 0 {
                passWord.becomeFirstResponder()
            }
            else if passwordAgain.length == 0 {
                passWord2.becomeFirstResponder()
            }
            
            errorText = errorText.appending(anyBlank as String) as (String) as NSString
            
        } else if(!password.isEqual(to: passwordAgain as String)){
            textError = true;
            errorText = errorText.appending(passwordMismatch as String) as (String) as NSString
            passWord.becomeFirstResponder()
        }
        
        if textError {
            // new API for iOS 8, does no support iOS 7
            var alertView = UIAlertController(title
                : "Error", message: errorText as String,  preferredStyle:UIAlertControllerStyle.alert)
            var dismissAction: UIAlertAction = UIAlertAction(title: "I'll fix it", style: .cancel){ action -> Void in
            }
            alertView.addAction(dismissAction)
            self.present(alertView, animated: true, completion: nil)
            self.container.removeFromSuperview()
            self.loadingView.removeFromSuperview()
            self.loginActivityIndicator.stopAnimating()
            return
        }
        
        // Sign up
        
        var user = PFUser()
        user.username = username as String!
        user.password = password as String!
        user.email = email as String!
        
        // other fields can be set just like with PFObject
        user["group"] = usergroup
		user["first_name"] = ""
		user["last_name"] = ""
		user["gender"] = ""
		user["role"] = ""
		user["college"] = ""
		user["class"] = ""
		user["major"] = ""
		
        user.signUpInBackground {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                PFUser.logOut()
                self.dismiss(animated: true, completion: nil)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                // Show the errorString somewhere and let the user try again.
                var alertView = UIAlertController(title
                    : "Oops! Something went wrong", message: errorString,  preferredStyle:UIAlertControllerStyle.Alert)
                var fixItAction: UIAlertAction = UIAlertAction(title: "I'll fix it", style: .cancel){ action -> Void in
                }
                alertView.addAction(fixItAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                self.container.removeFromSuperview()
                self.loadingView.removeFromSuperview()
                self.loginActivityIndicator.stopAnimating()
                return;
            }
        }
        
    }
    
    
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    // MARK: - Dismiss keyboard
    override func touchesBegan(_ touches: NSSet, with event: UIEvent) {
        self.view.endEditing(true)
    }
}
