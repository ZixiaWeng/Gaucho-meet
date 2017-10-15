//
//  GMProfileTableViewCell.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 2/18/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

class GMProfileTableViewCell: UITableViewCell {

	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var majorLable: UILabel!
	@IBOutlet weak var classLabel: UILabel!
	@IBOutlet weak var profilePic: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
