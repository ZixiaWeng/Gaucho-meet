/*
Copyright (C) 2014 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:

The table view controller responsible for displaying the filtered products as the user types in the search field.

*/

import UIKit

class ResultsTableController : UITableViewController {
    // MARK: Properties
    
    var filteredLocations = [GMLocations]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
	
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "locationList") as? UITableViewCell
		
		if cell == nil {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "locationList")
		}
        
        let location = filteredLocations[(indexPath as NSIndexPath).row]
        configureCell(cell!, forLocation: location)
        
        return cell!
    }
	
	// MARK: Set up a cell's contents
	
	func configureCell(_ cell: UITableViewCell, forLocation location: GMLocations) {
		cell.textLabel?.text = location.locationName
		
		// Add ratings on the right of the row
	}
}
