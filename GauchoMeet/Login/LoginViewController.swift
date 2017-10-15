//
//  LoginController.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 11/1/14.
//  Copyright (c) 2014 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,FBLoginViewDelegate, UITextFieldDelegate{
	
	@IBOutlet weak var loginbutton: UIButton!
	@IBOutlet weak var signupbutton: UIButton!
	@IBOutlet weak var forgotpasswordbutton: UIButton!
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	// Activity indicator
	var container: UIView = UIView()
	var loadingView: UIView = UIView()
	var loginActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
	
	// Facebook login button
	@IBOutlet var fbLoginView : FBLoginView!
	
	let viewTransitionDelegate = TransitionDelegate()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Move up the view when keyboard is presented, add NotificationCenter
		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
		
		// Login button round corner
		loginbutton.layer.cornerRadius = 5
		loginbutton.layer.borderWidth = 1
		loginbutton.layer.borderColor = UIColor.white.cgColor
		// Signup button round corner
		signupbutton.layer.cornerRadius = 5
		signupbutton.layer.borderWidth = 1
		signupbutton.layer.borderColor = UIColor.white.cgColor
		// Hide forget password for initial view
		forgotpasswordbutton.isHidden = true
		
		//self.fbLoginView.delegate = self
		//self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Dismiss keyboard when view will disappear
	override func viewWillDisappear(_ animated: Bool) {
		self.view.endEditing(true)
	}
	
	@IBAction func unwindToLogin(_ segue:UIStoryboardSegue) {
		
	}

	//  MARK: - General login

	
	// Login button behaviors
	@IBAction func loginButton(_ sender: AnyObject) {
		//login
		self.login()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.tag == 0 {
			self.passwordField.becomeFirstResponder()
		}
		if textField.tag == 1 {
			self.passwordField.resignFirstResponder()
			self.login()
		}
		return false
	}
	
	func login() {
		
		var username:NSString = usernameField.text
		var password:NSString = passwordField.text
		if (username.length == 0 || password.length == 0 ) {
			if username.length == 0 {
				usernameField.becomeFirstResponder()
			}
			else if password.length == 0 {
				passwordField.becomeFirstResponder()
			}
			return
		}
		
		self.view.endEditing(true);
		self.showActivityIndicator()
		
		PFUser.logInWithUsername(inBackground: usernameField.text, password:passwordField.text) {
			(user: PFUser!, error: NSError!) -> Void in
			if user != nil {
				// Do stuff after successful login.
				self.loginActivityIndicator.removeFromSuperview()
				self.loadingView.removeFromSuperview()
				self.container.removeFromSuperview()
				//http://makeapppie.com/2014/09/15/swift-swift-programmatic-navigation-view-controllers-in-swift/
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				var mainviewController = storyboard.instantiateViewControllerWithIdentifier("mainView") as MainViewController
				self.presentViewController(mainviewController, animated: false, completion: nil)
			} else {
				// The login failed. Check error to see why.
				self.loginActivityIndicator.removeFromSuperview()
				self.loadingView.removeFromSuperview()
				self.container.removeFromSuperview()
				
				self.forgotpasswordbutton.isHidden = false
				
				let errorString = error.userInfo!["error"] as NSString
				var alertView = UIAlertController(title
					: "Oops! Something went wrong", message: errorString,  preferredStyle:UIAlertControllerStyle.Alert)
				var fixItAction: UIAlertAction = UIAlertAction(title: "I'll fix it", style: .cancel){ action -> Void in
				}
				alertView.addAction(fixItAction)
				self.presentViewController(alertView, animated: true, completion: nil)
			}
		}
	}
	
	func showActivityIndicator(){
		
		container.frame = self.view.frame
		container.center = self.view.center
		container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
		
		// Loading view position and appearance
		loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
		loadingView.center = self.view.center
		loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
		loadingView.clipsToBounds = true
		loadingView.layer.cornerRadius = 10
		
		// Activity indicator position and appearance
		loginActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0);
		loginActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
		loginActivityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
		
		loadingView.addSubview(loginActivityIndicator)
		container.addSubview(loadingView)
		self.view.addSubview(container)
		loginActivityIndicator.startAnimating()
	}
	
	func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
		let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
		let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
		let blue = CGFloat(rgbValue & 0xFF)/256.0
		return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
	}
	
	// MARK: - Animation for SignUpView & ResetPWView
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "ResetPW"){
			let sourceViewController = self as UIViewController
			let destinationViewController = segue.destination as! ResetetPWViewController
			destinationViewController.transitioningDelegate = viewTransitionDelegate
			destinationViewController.modalPresentationStyle = .custom
		}
		if (segue.identifier == "SignUP"){
			let sourceViewController = self as UIViewController
			let destinationViewController = segue.destination as! SignUpViewController
			destinationViewController.transitioningDelegate = viewTransitionDelegate
			destinationViewController.modalPresentationStyle = .custom
		}
	}
	
	
	// MARK: - Facebook Delegate Methods
	
	func loginViewShowingLogged(inUser loginView : FBLoginView!) {
		println("User Logged In")
	}
	
	func loginViewFetchedUserInfo(_ loginView : FBLoginView!, user: FBGraphUser) {
		println("User: \(user)")
		println("User ID: \(user.objectID)")
		println("User Name: \(user.name)")
		var userEmail = user.object(forKey: "email") as! String
		println("User Email: \(userEmail)")
	}
	
	func loginViewShowingLoggedOutUser(_ loginView : FBLoginView!) {
		println("User Logged Out")
	}
	
	func loginView(_ loginView : FBLoginView!, handleError:NSError) {
		println("Error: \(handleError.localizedDescription)")
	}
	
	// MARK: - Dismiss keyboard
	override func touchesBegan(_ touches: NSSet, with event: UIEvent) {
		self.view.endEditing(true)
	}
	
	// MARK: - move UIview up when key board appears
	func keyboardWillShow(_ sender: Notification) {
		self.view.frame.origin.y -= 130
	}
	func keyboardWillHide(_ sender: Notification) {
		self.view.frame.origin.y += 130
	}

}


