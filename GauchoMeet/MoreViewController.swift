//
//  moreViewController.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 12/29/14.
//  Copyright (c) 2014 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logoutButton(_ sender: AnyObject) {
        PFUser.logOut()
        //var currentUser = PFUser.currentUser() // this will now be nil
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let loginviewController = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController // identifier "loginView" is set in Mainstoryboard
        self.present(loginviewController, animated: true, completion: nil)
    }
    
}
