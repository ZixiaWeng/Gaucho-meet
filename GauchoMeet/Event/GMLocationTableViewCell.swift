//
//  GMLocationTableViewCell.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 2/19/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit
import MapKit

class GMLocationTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLable: UILabel!
	@IBOutlet weak var mapView: MKMapView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
