//
//  ForgetPWViewController.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 12/30/14.
//  Copyright (c) 2014 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

class ResetetPWViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newpasswordbutton: UIButton!
    @IBOutlet weak var resetPasswordNavigationbar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailAddress.delegate = self
        newpasswordbutton.layer.cornerRadius = 5
        newpasswordbutton.layer.borderWidth = 1
        newpasswordbutton.layer.borderColor = UIColor.white.cgColor
        resetPasswordNavigationbar.backgroundColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    // MARK: - RequestPW
    
    @IBOutlet var emailAddress: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.requestNewPWBG()
        return false
    }
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var loginActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBAction func requestNewPW(_ sender: UIButton) {
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
        //        loadingView.addSubview(loadingLabel)
        
        var email:NSString = emailAddress.text
        if (email.length != 0 ) {
            container.addSubview(loadingView)
            self.view.addSubview(container)
            loginActivityIndicator.startAnimating()
        }
        
        self.requestNewPWBG()
    }
    
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func requestNewPWBG() {
        var email:NSString = emailAddress.text
        if (email.length == 0 ) {
            var alertView = UIAlertController(title
                : "Please enter your email", message: nil,  preferredStyle:UIAlertControllerStyle.alert)
            var dismissAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel){ action -> Void in
            }
            alertView.addAction(dismissAction)
            self.present(alertView, animated: true, completion: nil)
            emailAddress.becomeFirstResponder()
            return
        }
        PFUser.requestPasswordResetForEmailInBackground( email, {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Tell user that the emails has been sent
                var alertView = UIAlertController(title
                    : "Hooray! The email has been sent.", message: "Check your inbox (or junk sometimes) and don't forget your password again! LOL",  preferredStyle:UIAlertControllerStyle.Alert)
                var OKAction: UIAlertAction = UIAlertAction(title: "No problem!", style: .Cancel){ action -> Void in
                    // jump back to loginview
                    self.view.endEditing(true)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                // Show the errorString somewhere and let the user try again.
                var alertView = UIAlertController(title
                    : "Oops! Something went wrong", message: errorString,  preferredStyle:UIAlertControllerStyle.Alert)
                var fixItAction: UIAlertAction = UIAlertAction(title: "I'll fix it", style: .Cancel){ action -> Void in
                }
                alertView.addAction(fixItAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                self.container.removeFromSuperview()
                self.loadingView.removeFromSuperview()
                self.loginActivityIndicator.stopAnimating()
                
                return;
            }
        })
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Dismiss keyboard
    override func touchesBegan(_ touches: NSSet, with event: UIEvent) {
        self.view.endEditing(true)
    }
}
