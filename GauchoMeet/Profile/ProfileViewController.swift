//
//  ProfileViewController.swift
//  GauchoMeet
//
//  Created by Geon Lee on 1/25/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

/// Class linked to Profile User Interface on ProfileStoryboard
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userRole: UILabel!
    @IBOutlet weak var userCollege: UILabel!
    @IBOutlet weak var userClass: UILabel!
    @IBOutlet weak var userMajor: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var friendList: UIButton!
    
    /// Person class instance for user's information
    var myPersonProfile: Person!
    /// PFUser variable for current (logged in) user
	var myCurrentUser:PFUser = PFUser.current()
    /// PFUser variable for targeted user
    var myPresentedUser:PFUser = PFUser.current()
    /// PFFile for targeted user's profile image file
    var myProfileImageFile:PFFile!
    var hideAddFriendButton = true
    var hideFriendListButton = false
    
    /// Fetches user's information from Parse and shows them in UI
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addFriendButton.isHidden = hideAddFriendButton
        friendList.isHidden = hideFriendListButton
        
        // Update User Information
		myPersonProfile = Person(username_: (myPresentedUser.username as String), firstName_: (myPresentedUser["first_name"] as? String), lastName_: (myPresentedUser["last_name"] as? String), gender_: (myPresentedUser["gender"] as? String), role_: (myPresentedUser["role"] as? String), gradClass_: (myPresentedUser["class"] as? String), college_: (myPresentedUser["college"] as? String), major_: (myPresentedUser["major"] as? String))
		
		firstName.text = myPersonProfile.firstName
		lastName.text = myPersonProfile.lastName
		userName.text = myPersonProfile.username
		userGender.text = myPersonProfile.gender
		userRole.text = myPersonProfile.role
		userCollege.text = myPersonProfile.college
		userClass.text = myPersonProfile.gradClass
		userMajor.text = myPersonProfile.major
		
		
		// Handle Image
		self.myProfileImageFile = self.myPresentedUser["userImage"] as! PFFile?
		if self.myProfileImageFile != nil {
			self.myProfileImageFile.getDataInBackground{
				(imageData:Data!, error:NSError!)->Void in
				if (error == nil){
					let image:UIImage = UIImage(data: imageData)!
					self.userImage.image = image
				}
				else{
					println("Failed converting data to Image")
				}
			}
		}
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Unwind for navgiation bar cancel button in EditProfileViewController
    @IBAction func unwindCancelToProfile(_ segue:UIStoryboardSegue) {
        
    }
    
    /// Receive/fetch/upload targeted user's information to parse before reloading table view
    @IBAction func unwindSaveToProfile(_ segue:UIStoryboardSegue) {
        // Receive image from EditProfileView
        var editProfileViewController = segue.source as! EditProfileViewController
        editProfileViewController.myPersonEditProfile = myPersonProfile
        myProfileImageFile =  editProfileViewController.myEditProfileImageFile
        
        // Receive Name
        if (editProfileViewController.firstNameTextField.text != nil){
            self.myPersonProfile.firstName = editProfileViewController.firstNameTextField.text
        }
        if (editProfileViewController.lastNameTextField.text != nil){
             self.myPersonProfile.lastName = editProfileViewController.lastNameTextField.text
        }
        
        // Upload to Parse
        self.myPresentedUser["first_name"] = myPersonProfile.firstName
        self.myPresentedUser["last_name"] = myPersonProfile.lastName
        self.myPresentedUser["gender"] = myPersonProfile.gender
        self.myPresentedUser["role"] = myPersonProfile.role
		self.myPresentedUser["college"] = myPersonProfile.college
		self.myPresentedUser["class"] = myPersonProfile.gradClass
		self.myPresentedUser["major"] = myPersonProfile.major
		if self.myProfileImageFile != nil {
			self.myPresentedUser.setObject(myProfileImageFile, forKey: "userImage")
		}
        self.myPresentedUser.saveInBackground{
            (success: Bool, error: NSError!)-> Void in
            if (success){
                // Reload
                self.firstName.text = self.myPersonProfile.firstName
                self.lastName.text = self.myPersonProfile.lastName
                self.userName.text = self.myPersonProfile.username
                self.userGender.text = self.myPersonProfile.gender
                self.userRole.text = self.myPersonProfile.role
                self.userCollege.text = self.myPersonProfile.college
                self.userClass.text = self.myPersonProfile.gradClass
                self.userMajor.text = self.myPersonProfile.major
                
                //--Fetch data from Parse and convert to Image--
				if self.myProfileImageFile != nil {					
					self.myProfileImageFile.getDataInBackground{
						(imageData:Data!, error:NSError!)->Void in
						if (error == nil){
							let image:UIImage = UIImage(data: imageData)!
							self.userImage.image = image
						}
						else{
							println("Failed converting data to Image")
						}
					}
				}
				//--End converting--
				
			}
            else{
                println("Failed uploading")
            }
        }
		
    }
	
	/// Segue preparations for EditProfileViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEditProfile"{
            // Send Person and image (pointer)
            let editProfileViewController = segue.destination as! EditProfileViewController
            editProfileViewController.myPersonEditProfile = myPersonProfile
            editProfileViewController.myEditProfileImageFile = myProfileImageFile
        }
        else if(segue.identifier == "friendsList"){
            
        }

    }
    
    /// Adds the targeted user to friend list
    @IBAction func addFriend(_ sender: UIButton) {
        var friendList:[PFUser]!
        if (myCurrentUser["friend_list"] == nil) {
            friendList = [myPresentedUser] as [PFUser]
            myCurrentUser["friend_list"] = friendList
        }
        else{
            friendList = myCurrentUser["friend_list"] as! [PFUser]
            //Loop
            var isDuplicate = false
            
            for user in friendList {
                if (user.objectId as String == myPresentedUser.objectId as String){
                    println("duplicate")
                    isDuplicate = true
                }
            }
            
            if (isDuplicate == false){
                friendList.append(myPresentedUser)
                println("added")
            }
        }
        
        myCurrentUser.setObject(friendList, forKey: "friend_list")
        
        self.myCurrentUser.saveInBackground{
            (success: Bool, error: NSError!) -> Void in
            if (success){
                println("saved")
            }
        
        }
}

    
}
