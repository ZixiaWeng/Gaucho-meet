//
//  EditProfileViewController.swift
//  GauchoMeet
//
//  Created by Geon Lee on 1/25/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

/// Class linked to Edit Profile User Interface on ProfileStoryboard
class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var editProfileTableView: UITableView!
	@IBOutlet weak var genderSelection: UISegmentedControl!
	@IBOutlet weak var roleSelection: UISegmentedControl!
	@IBOutlet weak var editProfileImage: UIImageView!
	@IBOutlet weak var firstNameLabel: UILabel!
	@IBOutlet weak var lastNameLabel: UILabel!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var firstNameTextField: UITextField!
    
	
    /// Person class instance for user's information that points to myPersonProfile from ProfileViewController
	var myPersonEditProfile: Person!
    /// Info class array that holds editable information on table view
	var arrayOfInfo: [Info] = []
    /// PFUser variable for targeted user
	var myUser = PFUser.current()
    /// PFFile for targeted user's profile image file
	var myEditProfileImageFile:PFFile!
	
	/// Fetches user's editable information from Parse and shows them in UI
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		//
		// -Static View Set up-
		
		// Name
		firstNameLabel.text = myPersonEditProfile.firstName
		lastNameLabel.text = myPersonEditProfile.lastName
		
		// Gender
		if(myPersonEditProfile.gender == "Male"){
			genderSelection.selectedSegmentIndex = 0
			
		}
		else if(myPersonEditProfile.gender == "Female"){
			genderSelection.selectedSegmentIndex = 1
		}
		else{
			println("Unexpected Gender: check gender")
		}
		// Role
		if(myPersonEditProfile.role == "Student"){
			roleSelection.selectedSegmentIndex = 0
		}
		else if(myPersonEditProfile.role == "Faculty"){
			roleSelection.selectedSegmentIndex = 1
		}
		else{
			println("Unexpected Role: check role")
		}
		
		//
		// -Table View Set up-
		//
		var classInfo = Info(leftInfo_: "Class", rightInfo_: myPersonEditProfile.gradClass?)
		var collegeInfo = Info(leftInfo_: "College", rightInfo_: myPersonEditProfile.college?)
		var majorInfo = Info(leftInfo_: "Major", rightInfo_: myPersonEditProfile.major?)
		arrayOfInfo.append(classInfo)
		arrayOfInfo.append(collegeInfo)
		arrayOfInfo.append(majorInfo)
		
		//
		// -Image Set up-
		// Fetch and Convert
		if self.myEditProfileImageFile != nil {
			self.myEditProfileImageFile.getDataInBackground{
				(imageData:Data!, error:NSError!)->Void in
				if (error == nil){
					let image:UIImage = UIImage(data: imageData)!
					self.editProfileImage.image = image
				}
				else{
					println("Failed converting data to Image")
				}
			}
		}
		
		// Remove unused cells
		self.editProfileTableView.tableFooterView = UIView()
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	/// Unwind from DetailViewController
	@IBAction func unwindToEditProfile(_ segue:UIStoryboardSegue) {
        //Disable Keyboard
        self.view.endEditing(true)
	}
	
	
	//
	// Building table view
	//
    /// Provides the number of rows to build
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrayOfInfo.count
	}
	
    /// Builds a dynamic table view of editable user information
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
		// Set up array
		arrayOfInfo = []
		var classInfo = Info(leftInfo_: "Class", rightInfo_: myPersonEditProfile.gradClass?)
		var collegeInfo = Info(leftInfo_: "College", rightInfo_: myPersonEditProfile.college?)
		var majorInfo = Info(leftInfo_: "Major", rightInfo_: myPersonEditProfile.major?)
		arrayOfInfo.append(classInfo)
		arrayOfInfo.append(collegeInfo)
		arrayOfInfo.append(majorInfo)
		
		let cell: RightDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "rightDetailCell") as! RightDetailTableViewCell
		
		var info: Info = arrayOfInfo[(indexPath as NSIndexPath).row]
		
		cell.setRightDetailCell(info.leftInfo, rightDetail_: info.rightInfo)
		
		return cell
	}
	
	
	//
	// Preparation for Segue
	//
    // Segue preparation for DetailViewController
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Disable Keyboard
        self.view.endEditing(true)
        
		if segue.identifier == "unwindToEditProfile" {
			
		}
		else if segue.identifier == "showProfileDetail"{
			
			let index = editProfileTableView.indexPathForSelectedRow?.row
			var info: Info = arrayOfInfo[index!]
			let detailViewController = segue.destination as! DetailViewController
			detailViewController.typeOfDetail = arrayOfInfo[index!].leftInfo
			
			// Send Person (pointer)
			detailViewController.myPersonDetailProfile = myPersonEditProfile
		}
		
	}
	
	
	//
	// Image Handlers
	//
    /// Opens up image selection: user's photos
	@IBAction func imageSelection(_ sender: UIButton) {
		// Add Photo
		let imagePicker:UIImagePickerController = UIImagePickerController()
		imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
		imagePicker.delegate = self
		
		self.present(imagePicker, animated: true, completion: nil)
	}
	
    /// Saves the user's chosen image in editProfileImage
	func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
		let pickedImage:UIImage = info.object(forKey: UIImagePickerControllerOriginalImage) as! UIImage
		
		// Scale image
		let scaledImage = self.scaleImageWidth(pickedImage, and: CGSize(width: 100,height: 100))
		
		let imageData = UIImagePNGRepresentation(scaledImage)
		
		self.myEditProfileImageFile = PFFile(data: imageData)
		editProfileImage.image = scaledImage
		
		picker.dismiss(animated: true, completion: nil)
	}
	
    /// Resizes the given image to the given size
	func scaleImageWidth(_ image:UIImage, and newSize:CGSize)->UIImage{
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
		image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
		let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
	
	//
	// UISegmentedControl
	//
    /// UI segement bar that changes gender in myPersonEditProfile
	@IBAction func genderButton(_ sender: UISegmentedControl) {
        //Disable Keyboard
        self.view.endEditing(true)
        
		if (genderSelection.selectedSegmentIndex == 0){
			myPersonEditProfile.gender = "Male"
		}
		else{
			myPersonEditProfile.gender = "Female"
		}
	}
    /// UI segement bar that changes role in myPersonEditProfile
	@IBAction func roleButton(_ sender: UISegmentedControl) {
        //Disable Keyboard
        self.view.endEditing(true)
        
		if (roleSelection.selectedSegmentIndex == 0){
			myPersonEditProfile.role = "Student"
		}
		else{
			myPersonEditProfile.role = "Faculty"
		}
	}
	
	//
	// Keyboard
	//
    /// Dismiss keyboard
	override func touchesBegan(_ touches: NSSet, with event: UIEvent) {
		self.view.endEditing(true)
	}
	
	
}
