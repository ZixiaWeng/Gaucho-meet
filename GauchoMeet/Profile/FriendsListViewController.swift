//
//  FriendsListViewController.swift
//  GauchoMeet
//
//  Created by Geon Lee on 2/21/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

class FriendsListViewController: UITableViewController {

	var friendListForTableView: [PFUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // No Friends
        if (PFUser.current()["friend_list"] == nil){
            println("ERROR: no friends")
        }
		else {
			friendListForTableView = PFUser.current()["friend_list"] as! [PFUser]
		}
        
        // Remove unused cells
        self.tableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // Building table view
    //
    /// Provides the number of rows to build
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (PFUser.current()["friend_list"] == nil) { return 0 }
		return friendListForTableView.count
    }
    
    /// Builds a dynamic table view of editable user information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell") as! GMProfileTableViewCell
        
        var friend = friendListForTableView[(indexPath as NSIndexPath).row]
        friend.fetchIfNeeded()
        
        cell.userNameLabel.text = friend.username
        cell.majorLable.text = friend["major"] as? String
        cell.classLabel.text = friend["class"] as? String
        var profilePic = friend["userImage"] as! PFFile?
        if (profilePic != nil) {
            profilePic!.getDataInBackgroundWithBlock{
                (imageData:Data!, error:NSError!)->Void in
                if (error == nil){
                    let image:UIImage = UIImage(data: imageData)!
                    cell.profilePic.image = image
                }
                else{
                    println("Failed converting data to Image")
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }


}
