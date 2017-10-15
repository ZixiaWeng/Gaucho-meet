//
//  RightDetailTableViewCell.swift
//  GauchoMeet
//
//  Created by Geon Lee on 1/25/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

/// Linked to the dynamic table view cell on DetailViewController UI in ProfileStoryboard
class RightDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var infoRight: UILabel!
    @IBOutlet weak var infoLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Sets the left and right details of the cell
    func setRightDetailCell(_ leftTitle_: String, rightDetail_: String){
        self.infoLeft.text = leftTitle_
        self.infoRight.text = rightDetail_
    }

}
