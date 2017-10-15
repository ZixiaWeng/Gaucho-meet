//
//  DetailTableViewCell.swift
//  GauchoMeet
//
//  Created by Geon Lee on 1/25/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

/// Linked to the dynamic table view cell on EditProfileViewController UI in ProfileStoryboard
class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLeft: UILabel!
    @IBOutlet weak var detailRight: UILabel!
    
    /// Hides the left detail of the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.detailLeft.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// Sets the left and right details of the cell
    func setDetailCell(_ leftTitle_: String, rightDetail_: String){
        self.detailLeft.text = leftTitle_
        self.detailRight.text = rightDetail_
    }

}
