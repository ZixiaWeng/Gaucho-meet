//
//  GMEvetnTypePickerView.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 1/17/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

class GMEvetnTypePickerView: UIPickerView {

    var rowsOfComponent1 = 3
    var rowsOfComponent2 = 2
	
	/// :returns: Different nnumber for rows for different components
    override func  numberOfRows(inComponent component: Int) -> Int {
        if component == 0 {
            return 3
        }
        if component == 1 {
			return rowsOfComponent1
		}
		return rowsOfComponent2
	}
	//// Determines the number of rows in the next two components when a row is seleted in the firt columnn
	override func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
		if component == 0 {
			if self.selectedRow(inComponent: 0) == 0 { //meals
				rowsOfComponent1 = 3
				rowsOfComponent2 = 2
				self.reloadComponent(1)
				self.reloadComponent(2)
			}
			else if self.selectedRow(inComponent: 0) == 1 { //study group
				rowsOfComponent1 = 2
				rowsOfComponent2 = 2
				self.reloadComponent(1)
				self.reloadComponent(2)
			}
			else if self.selectedRow(inComponent: 0) == 2 { // hang out
				rowsOfComponent1 = 2
				rowsOfComponent2 = 2
				self.reloadComponent(1)
				self.reloadComponent(2)
			}
		}
	}
	
	
	
}
