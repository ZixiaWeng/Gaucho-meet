//
//  Info.swift
//  GauchoMeet
//
//  Created by Geon Lee on 1/25/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import Foundation

/// Information class used to create profile information
class Info{
    
    /// Type of profile information
	var leftInfo: String
    /// Holds the profile information
	var rightInfo: String

    /// Default constructor
    init(){
        self.leftInfo = ""
        self.rightInfo = ""
    }
    
    /// Argument Constructor with provided profile information
    init(leftInfo_: String, rightInfo_: String?){
        
            self.leftInfo = leftInfo_
            self.rightInfo = ""
        
		if rightInfo_ != nil {
			self.rightInfo = rightInfo_!
		}

    }
    
}