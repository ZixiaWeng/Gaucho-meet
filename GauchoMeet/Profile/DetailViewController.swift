//
//  DetailViewController.swift
//  GauchoMeet
//
//  Created by Geon Lee on 1/25/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

/// Class linked to Edit Profile Detail Selection User Interface on ProfileStoryboard
class DetailViewController: UITableViewController {

    
    @IBOutlet weak var detailTitle: UINavigationItem!
    @IBOutlet var detailTableView: UITableView!

    /// Person class instance for user's information that points to myEditPersonProfile from EditProfileViewController
    var myPersonDetailProfile: Person!
    /// Decides which detail table view to build
    var typeOfDetail : String = ""
    /// Info class array that holds editable detail options
    var arrayOfDetail : [Info] = []
    
    
    /// Decides which table view to build based on typeOfDetail
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Build Array
        detailTitle.title = typeOfDetail
        if (typeOfDetail == "Class"){
            buildClassArray()
        }
        else if (typeOfDetail == "College"){
            buildCollegeArray()
        }
        else if (typeOfDetail == "Major"){
            buildMajorArray()
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

        return arrayOfDetail.count
    }
    
    /// Builds a dynamic table view of options for editable user information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell: DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
        
        var info: Info = arrayOfDetail[(indexPath as NSIndexPath).row]
        
        cell.setDetailCell(info.leftInfo, rightDetail_: info.rightInfo)
        
        return cell
    }
    
    /// Sends back to EditProfileViewController when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "unwindToEditProfile", sender: self)
    }


    //
    // Preparation for Segue
    //
    /// Segue prepation back to EditProfileViewController: reloads the table view in EditProfileViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToEditProfile" {
            // Change Person's Info
            let index = detailTableView.indexPathForSelectedRow?.row
            let info:Info = arrayOfDetail[index!]
            changePersonInfo(info.leftInfo, rightChange_: info.rightInfo, myPerson_: myPersonDetailProfile)
            
            // Reload
            let editProfileViewController = segue.destination as! EditProfileViewController
            editProfileViewController.editProfileTableView.reloadData()
        }
    }
    
    
    //
    // Changing Person's info
    //
    /// Helper function that changes Person class isntance's information
    func changePersonInfo (_ leftChange_: String, rightChange_: String, myPerson_: Person){
        switch (leftChange_){
        case ("Class"):
            myPerson_.gradClass = rightChange_
        case ("College"):
            myPerson_.college = rightChange_
        case ("Major"):
            myPerson_.major = rightChange_
        default:
            let leftChange_ = "do nothing"
        }
    }
    
    
    //
    // Array builders
    //
    /// Helpfer function that builds an Info class array of graduating class years
    func buildClassArray(){
        let classInfo1 = Info(leftInfo_: "Class", rightInfo_: "Class of 1990")
        let classInfo2 = Info(leftInfo_: "Class", rightInfo_: "Class of 1991")
        let classInfo3 = Info(leftInfo_: "Class", rightInfo_: "Class of 1992")
        let classInfo4 = Info(leftInfo_: "Class", rightInfo_: "Class of 1993")
        let classInfo5 = Info(leftInfo_: "Class", rightInfo_: "Class of 1994")
        let classInfo6 = Info(leftInfo_: "Class", rightInfo_: "Class of 1995")
        let classInfo7 = Info(leftInfo_: "Class", rightInfo_: "Class of 1996")
        let classInfo8 = Info(leftInfo_: "Class", rightInfo_: "Class of 1997")
        let classInfo9 = Info(leftInfo_: "Class", rightInfo_: "Class of 1998")
        let classInfo10 = Info(leftInfo_: "Class", rightInfo_: "Class of 1999")
        let classInfo11 = Info(leftInfo_: "Class", rightInfo_: "Class of 2000")
        let classInfo12 = Info(leftInfo_: "Class", rightInfo_: "Class of 2001")
        let classInfo13 = Info(leftInfo_: "Class", rightInfo_: "Class of 2002")
        let classInfo14 = Info(leftInfo_: "Class", rightInfo_: "Class of 2003")
        let classInfo15 = Info(leftInfo_: "Class", rightInfo_: "Class of 2004")
        let classInfo16 = Info(leftInfo_: "Class", rightInfo_: "Class of 2005")
        let classInfo17 = Info(leftInfo_: "Class", rightInfo_: "Class of 2006")
        let classInfo18 = Info(leftInfo_: "Class", rightInfo_: "Class of 2007")
        let classInfo19 = Info(leftInfo_: "Class", rightInfo_: "Class of 2008")
        let classInfo20 = Info(leftInfo_: "Class", rightInfo_: "Class of 2009")
        let classInfo21 = Info(leftInfo_: "Class", rightInfo_: "Class of 2010")
        let classInfo22 = Info(leftInfo_: "Class", rightInfo_: "Class of 2011")
        let classInfo23 = Info(leftInfo_: "Class", rightInfo_: "Class of 2012")
        let classInfo24 = Info(leftInfo_: "Class", rightInfo_: "Class of 2013")
        let classInfo25 = Info(leftInfo_: "Class", rightInfo_: "Class of 2014")
        let classInfo26 = Info(leftInfo_: "Class", rightInfo_: "Class of 2015")
        let classInfo27 = Info(leftInfo_: "Class", rightInfo_: "Class of 2016")
        let classInfo28 = Info(leftInfo_: "Class", rightInfo_: "Class of 2017")
        let classInfo29 = Info(leftInfo_: "Class", rightInfo_: "Class of 2018")
        let classInfo30 = Info(leftInfo_: "Class", rightInfo_: "Class of 2019")
        let classInfo31 = Info(leftInfo_: "Class", rightInfo_: "Class of 2020")
        let classInfo32 = Info(leftInfo_: "Class", rightInfo_: "Class of 2021")
        let classInfo33 = Info(leftInfo_: "Class", rightInfo_: "Class of 2022")
        let classInfo34 = Info(leftInfo_: "Class", rightInfo_: "Class of 2023")
        let classInfo35 = Info(leftInfo_: "Class", rightInfo_: "Class of 2024")
        let classInfo36 = Info(leftInfo_: "Class", rightInfo_: "Class of 2025")
        let classInfo37 = Info(leftInfo_: "Class", rightInfo_: "Class of 2026")
        let classInfo38 = Info(leftInfo_: "Class", rightInfo_: "Class of 2027")
        let classInfo39 = Info(leftInfo_: "Class", rightInfo_: "Class of 2028")
        let classInfo40 = Info(leftInfo_: "Class", rightInfo_: "Class of 2029")
        
        arrayOfDetail.append(classInfo1)
        arrayOfDetail.append(classInfo2)
        arrayOfDetail.append(classInfo3)
        arrayOfDetail.append(classInfo4)
        arrayOfDetail.append(classInfo5)
        arrayOfDetail.append(classInfo6)
        arrayOfDetail.append(classInfo7)
        arrayOfDetail.append(classInfo8)
        arrayOfDetail.append(classInfo9)
        arrayOfDetail.append(classInfo10)
        arrayOfDetail.append(classInfo11)
        arrayOfDetail.append(classInfo12)
        arrayOfDetail.append(classInfo13)
        arrayOfDetail.append(classInfo14)
        arrayOfDetail.append(classInfo15)
        arrayOfDetail.append(classInfo16)
        arrayOfDetail.append(classInfo17)
        arrayOfDetail.append(classInfo18)
        arrayOfDetail.append(classInfo19)
        arrayOfDetail.append(classInfo20)
        arrayOfDetail.append(classInfo21)
        arrayOfDetail.append(classInfo22)
        arrayOfDetail.append(classInfo23)
        arrayOfDetail.append(classInfo24)
        arrayOfDetail.append(classInfo25)
        arrayOfDetail.append(classInfo26)
        arrayOfDetail.append(classInfo27)
        arrayOfDetail.append(classInfo28)
        arrayOfDetail.append(classInfo29)
        arrayOfDetail.append(classInfo30)
        arrayOfDetail.append(classInfo31)
        arrayOfDetail.append(classInfo32)
        arrayOfDetail.append(classInfo33)
        arrayOfDetail.append(classInfo34)
        arrayOfDetail.append(classInfo35)
        arrayOfDetail.append(classInfo36)
        arrayOfDetail.append(classInfo37)
        arrayOfDetail.append(classInfo38)
        arrayOfDetail.append(classInfo39)
        arrayOfDetail.append(classInfo40)
        
    }
    
    /// Helper function that builds an Info class array of graduating class years
    func buildCollegeArray(){
        let info1 = Info(leftInfo_: "College", rightInfo_: "College of Letters & Science")
        let info2 = Info(leftInfo_: "College", rightInfo_: "College of Engineering")
        let info3 = Info(leftInfo_: "College", rightInfo_: "College of Creative Studies")
        arrayOfDetail.append(info1)
        arrayOfDetail.append(info2)
        arrayOfDetail.append(info3)
    }
    
    /// Helper function that builds an Info class array of UCSB majors
    func buildMajorArray(){
        let info1 = Info(leftInfo_: "Major", rightInfo_: "Actuarial Science")
        let info2 = Info(leftInfo_: "Major", rightInfo_: "Anthropology")
        let info3 = Info(leftInfo_: "Major", rightInfo_: "Aquatic Biology")
        let info4 = Info(leftInfo_: "Major", rightInfo_: "Art")
        let info5 = Info(leftInfo_: "Major", rightInfo_: "Asian American Studies")
        let info6 = Info(leftInfo_: "Major", rightInfo_: "Asian Studies")
        let info7 = Info(leftInfo_: "Major", rightInfo_: "Biochemistry")
        let info8 = Info(leftInfo_: "Major", rightInfo_: "Biochemistry – Molecular Biology")
        let info9 = Info(leftInfo_: "Major", rightInfo_: "Biological Sciences")
        let info10 = Info(leftInfo_: "Major", rightInfo_: "Biology")
        let info11 = Info(leftInfo_: "Major", rightInfo_: "Biopsychology")
        let info12 = Info(leftInfo_: "Major", rightInfo_: "Black Studies")
        let info13 = Info(leftInfo_: "Major", rightInfo_: "Cell & Developmental Biology")
        let info14 = Info(leftInfo_: "Major", rightInfo_: "Chemical Engineering")
        let info15 = Info(leftInfo_: "Major", rightInfo_: "Chemistry")
        let info16 = Info(leftInfo_: "Major", rightInfo_: "Chemistry and Biochemistry ")
        let info17 = Info(leftInfo_: "Major", rightInfo_: "Chicano & Chicana Studies")
        let info18 = Info(leftInfo_: "Major", rightInfo_: "Chinese")
        let info19 = Info(leftInfo_: "Major", rightInfo_: "Classics")
        let info20 = Info(leftInfo_: "Major", rightInfo_: "Communication")
        let info21 = Info(leftInfo_: "Major", rightInfo_: "Comparative Literature")
        let info22 = Info(leftInfo_: "Major", rightInfo_: "Computer Engineering")
        let info23 = Info(leftInfo_: "Major", rightInfo_: "Computer Science")
        let info24 = Info(leftInfo_: "Major", rightInfo_: "Dance")
        let info25 = Info(leftInfo_: "Major", rightInfo_: "Earth Science")
        let info26 = Info(leftInfo_: "Major", rightInfo_: "Ecology & Evolution")
        let info27 = Info(leftInfo_: "Major", rightInfo_: "Economics")
        let info28 = Info(leftInfo_: "Major", rightInfo_: "Economics & Accounting")
        let info29 = Info(leftInfo_: "Major", rightInfo_: "Electrical Engineering")
        let info30 = Info(leftInfo_: "Major", rightInfo_: "English")
        let info31 = Info(leftInfo_: "Major", rightInfo_: "Environmental Studies")
        let info32 = Info(leftInfo_: "Major", rightInfo_: "Feminist Studies")
        let info33 = Info(leftInfo_: "Major", rightInfo_: "Film & Media Studies")
        let info34 = Info(leftInfo_: "Major", rightInfo_: "Financial Mathematics & Statistics ")
        let info35 = Info(leftInfo_: "Major", rightInfo_: "French")
        let info36 = Info(leftInfo_: "Major", rightInfo_: "Geography")
        let info37 = Info(leftInfo_: "Major", rightInfo_: "German")
        let info38 = Info(leftInfo_: "Major", rightInfo_: "Global Studies")
        let info39 = Info(leftInfo_: "Major", rightInfo_: "History")
        let info40 = Info(leftInfo_: "Major", rightInfo_: "History of Art & Architecture")
        let info41 = Info(leftInfo_: "Major", rightInfo_: "History of Public Policy")
        let info42 = Info(leftInfo_: "Major", rightInfo_: "Hydrologic Sciences & Policy")
        let info43 = Info(leftInfo_: "Major", rightInfo_: "Interdisciplinary Studies")
        let info44 = Info(leftInfo_: "Major", rightInfo_: "Italian Studies")
        let info45 = Info(leftInfo_: "Major", rightInfo_: "Japanese")
        let info46 = Info(leftInfo_: "Major", rightInfo_: "Language, Culture & Society")
        let info47 = Info(leftInfo_: "Major", rightInfo_: "Latin American & Iberian Studies")
        let info48 = Info(leftInfo_: "Major", rightInfo_: "Linguistics")
        let info49 = Info(leftInfo_: "Major", rightInfo_: "Mathematics")
        let info50 = Info(leftInfo_: "Major", rightInfo_: "Mathematical Sciences")
        let info51 = Info(leftInfo_: "Major", rightInfo_: "Mechanical Engineering")
        let info52 = Info(leftInfo_: "Major", rightInfo_: "Medieval Studies")
        let info53 = Info(leftInfo_: "Major", rightInfo_: "Microbiology")
        let info54 = Info(leftInfo_: "Major", rightInfo_: "Middle East Studies")
        let info55 = Info(leftInfo_: "Major", rightInfo_: "Music Composition")
        let info56 = Info(leftInfo_: "Major", rightInfo_: "Music Studies")
        let info57 = Info(leftInfo_: "Major", rightInfo_: "Pharmacology")
        let info58 = Info(leftInfo_: "Major", rightInfo_: "Philosophy")
        let info59 = Info(leftInfo_: "Major", rightInfo_: "Physical Geography")
        let info60 = Info(leftInfo_: "Major", rightInfo_: "Physics")
        let info61 = Info(leftInfo_: "Major", rightInfo_: "Physiology")
        let info62 = Info(leftInfo_: "Major", rightInfo_: "Political Sciences")
        let info63 = Info(leftInfo_: "Major", rightInfo_: "Portuguese ")
        let info64 = Info(leftInfo_: "Major", rightInfo_: "Psychology")
        let info65 = Info(leftInfo_: "Major", rightInfo_: "Religious Studies")
        let info66 = Info(leftInfo_: "Major", rightInfo_: "Renaissance Studies")
        let info67 = Info(leftInfo_: "Major", rightInfo_: "Slavic Languages & Literature")
        let info68 = Info(leftInfo_: "Major", rightInfo_: "Sociology")
        let info69 = Info(leftInfo_: "Major", rightInfo_: "Spanish")
        let info70 = Info(leftInfo_: "Major", rightInfo_: "Statistical Sciences")
        let info71 = Info(leftInfo_: "Major", rightInfo_: "Theater")
        let info72 = Info(leftInfo_: "Major", rightInfo_: "Zoology")

        arrayOfDetail.append(info1)
        arrayOfDetail.append(info2)
        arrayOfDetail.append(info3)
        arrayOfDetail.append(info4)
        arrayOfDetail.append(info5)
        arrayOfDetail.append(info6)
        arrayOfDetail.append(info7)
        arrayOfDetail.append(info8)
        arrayOfDetail.append(info9)
        arrayOfDetail.append(info10)
        arrayOfDetail.append(info11)
        arrayOfDetail.append(info12)
        arrayOfDetail.append(info13)
        arrayOfDetail.append(info14)
        arrayOfDetail.append(info15)
        arrayOfDetail.append(info16)
        arrayOfDetail.append(info17)
        arrayOfDetail.append(info18)
        arrayOfDetail.append(info19)
        arrayOfDetail.append(info20)
        arrayOfDetail.append(info21)
        arrayOfDetail.append(info22)
        arrayOfDetail.append(info23)
        arrayOfDetail.append(info24)
        arrayOfDetail.append(info25)
        arrayOfDetail.append(info26)
        arrayOfDetail.append(info27)
        arrayOfDetail.append(info28)
        arrayOfDetail.append(info29)
        arrayOfDetail.append(info30)
        arrayOfDetail.append(info31)
        arrayOfDetail.append(info32)
        arrayOfDetail.append(info33)
        arrayOfDetail.append(info34)
        arrayOfDetail.append(info35)
        arrayOfDetail.append(info36)
        arrayOfDetail.append(info37)
        arrayOfDetail.append(info38)
        arrayOfDetail.append(info39)
        arrayOfDetail.append(info40)
        arrayOfDetail.append(info41)
        arrayOfDetail.append(info42)
        arrayOfDetail.append(info43)
        arrayOfDetail.append(info44)
        arrayOfDetail.append(info45)
        arrayOfDetail.append(info46)
        arrayOfDetail.append(info47)
        arrayOfDetail.append(info48)
        arrayOfDetail.append(info49)
        arrayOfDetail.append(info50)
        arrayOfDetail.append(info51)
        arrayOfDetail.append(info52)
        arrayOfDetail.append(info53)
        arrayOfDetail.append(info54)
        arrayOfDetail.append(info55)
        arrayOfDetail.append(info56)
        arrayOfDetail.append(info57)
        arrayOfDetail.append(info58)
        arrayOfDetail.append(info59)
        arrayOfDetail.append(info60)
        arrayOfDetail.append(info61)
        arrayOfDetail.append(info62)
        arrayOfDetail.append(info63)
        arrayOfDetail.append(info64)
        arrayOfDetail.append(info65)
        arrayOfDetail.append(info66)
        arrayOfDetail.append(info67)
        arrayOfDetail.append(info68)
        arrayOfDetail.append(info69)
        arrayOfDetail.append(info70)
        arrayOfDetail.append(info71)
        arrayOfDetail.append(info72)
        
    }

    
}
