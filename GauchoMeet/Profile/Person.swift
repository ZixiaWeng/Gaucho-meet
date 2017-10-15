//
//  Person.swift
//  GauchoMeet
//
//  Created by Geon Lee on 1/26/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import Foundation

/// Person class used to store the user's information
class Person{
    
    /// User's username
    var username: String?
    /// User's first name
    var firstName: String?
    /// User's last name
    var lastName: String?
    /// User's gender
    var gender: String?
    /// User's role: Student/Faculty
    var role: String?
    /// User's graduating class
    var gradClass: String?
    /// User's college
    var college: String?
    /// User's major
    var major: String?
    
    /// Default constructor
    init(){
        self.username = ""
        self.firstName = ""
        self.lastName = ""
        self.gender = ""
        self.role = ""
        self.gradClass = ""
        self.college = ""
        self.major = ""
    }
    
    /// Argument Constructor with provided user's information
    init(username_: String?, firstName_: String?, lastName_: String?, gender_: String?, role_: String?, gradClass_: String?, college_:String?, major_: String?){
        self.username = username_
        self.firstName = firstName_
        self.lastName = lastName_
        self.gender = gender_
        self.role = role_
        self.gradClass = gradClass_
        self.college = college_
        self.major = major_
    }

}