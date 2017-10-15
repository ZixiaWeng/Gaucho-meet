//
//  GMLocationTableViewController.swift
//  SearchController
//
//  Created by Zixia Weng on 02/20/15.
//  Copyright (c) 2014 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit

class GMLocationTableViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
	// Initialize and sort in alphabetical order.
	let locations = [
		GMLocations(category:"Isla Vista",locationName:"Kogilicious",coordinates: CLLocation(latitude: 34.411579, longitude:  -119.855137)),
		GMLocations(category:"Isla Vista",locationName:"Freebirds World Burrito",coordinates: CLLocation(latitude: 34.413254, longitude:  -119.855682)),
		GMLocations(category:"Isla Vista",locationName:"Lovin Oven",coordinates: CLLocation(latitude: 34.412628, longitude:  -119.862074)),
		GMLocations(category:"Isla Vista",locationName:"Buddha Bowls", coordinates: CLLocation(latitude: 34.4141049,                         longitude: -119.8570412)),
		GMLocations(category:"Isla Vista",locationName:"South Coast Deli", coordinates: CLLocation(latitude: 34.432976, longitude: -119.8097178)),
		GMLocations(category:"Isla Vista",locationName:"Sorriso Italiano", coordinates: CLLocation(latitude: 34.4141049, longitude: -119.8570412)),
		GMLocations(category:"Isla Vista",locationName:"Woodstock’s Pizza", coordinates: CLLocation(latitude: 34.4140959, longitude: -119.8553903)),
		GMLocations(category:"Isla Vista",locationName:"Kaptain’s Firehouse BBQ", coordinates: CLLocation(latitude: 34.4131191, longitude: -119.8562268)),
		GMLocations(category:"Isla Vista",locationName:"Blaze Fast Fire’d Pizza", coordinates: CLLocation(latitude: 34.4131191, longitude: -119.8562268)),
		GMLocations(category:"Isla Vista",locationName:"The Habit", coordinates: CLLocation(latitude: 34.4140959, longitude: -119.8553903)),
		GMLocations(category:"Isla Vista",locationName:"Super Cuca’s Taqueria", coordinates: CLLocation(latitude: 34.412447, longitude: -119.8554007)),
		GMLocations(category:"Isla Vista",locationName:"Aladdin Café", coordinates: CLLocation(latitude: 34.4140959, longitude: -119.8553903)),
		GMLocations(category:"Isla Vista",locationName:"Hana Kitchen", coordinates: CLLocation(latitude: 34.4131138, longitude: -119.8553953)),
		GMLocations(category:"Isla Vista",locationName:"Pizza My Heart", coordinates: CLLocation(latitude: 34.4111551, longitude: -119.861843)),
		GMLocations(category:"Isla Vista",locationName:"Silvergreens", coordinates: CLLocation(latitude: 34.4141049, longitude: -119.8570412)),
		GMLocations(category:"Isla Vista",locationName:"Jimmy John’s Gourmet", coordinates: CLLocation(latitude: 34.4141049, longitude: -119.8570412)),
		GMLocations(category:"Isla Vista",locationName:"Giovanni’s Isla Vista", coordinates: CLLocation(latitude: 34.4131138, longitude: -119.8553953)),
		GMLocations(category:"Isla Vista",locationName:"Crushcakes & Café", coordinates: CLLocation(latitude: 34.4133292, longitude: -119.8609718)),
		GMLocations(category:"Isla Vista",locationName:"Angry Wings", coordinates: CLLocation(latitude: 34.4133292, longitude: -119.8609718)),
		GMLocations(category:"Isla Vista",locationName:"Naan Stop", coordinates: CLLocation(latitude: 34.4141049, longitude: -119.8570412)),
		GMLocations(category:"Isla Vista",locationName:"Pho Bistro", coordinates: CLLocation(latitude: 34.4140959, longitude: -119.8553903)),
		GMLocations(category:"Isla Vista",locationName:"El Sitio", coordinates: CLLocation(latitude: 34.4131191, longitude: -119.8562268)),
		GMLocations(category:"Isla Vista",locationName:"Cantina", coordinates: CLLocation(latitude: 34.4141049, longitude: -119.8570412)),
		GMLocations(category:"Isla Vista",locationName:"Bagel Café", coordinates: CLLocation(latitude: 34.4111551, longitude: -119.861843)),
		GMLocations(category:"Isla Vista",locationName:"Café Equilibrium", coordinates: CLLocation(latitude: 34.4131138, longitude: -119.8553953)),
		GMLocations(category:"Isla Vista",locationName:"IV Deli Mart", coordinates: CLLocation(latitude: 34.4131138, longitude: -119.8553953)),
		GMLocations(category:"Isla Vista",locationName:"Blenders In The Grass", coordinates: CLLocation(latitude: 34.4131191, longitude: -119.8562268)),
		GMLocations(category:"Isla Vista",locationName:"Sam’s To Go", coordinates: CLLocation(latitude: 34.4133292, longitude: -119.8609718)),
		GMLocations(category:"Isla Vista",locationName:"Domino’s Pizza", coordinates: CLLocation(latitude: 34.4141049, longitude: -119.8570412)),
		GMLocations(category:"Isla Vista",locationName:"Dejavu", coordinates: CLLocation(latitude: 34.4141049, longitude: -119.8570412)),
		GMLocations(category:"Isla Vista",locationName:"Rosarito", coordinates: CLLocation(latitude: 34.4133292, longitude: -119.8609718)),
		GMLocations(category:"Campus",locationName:"Subway", coordinates: CLLocation(latitude: 34.413336, longitude: -119.855188)),
		GMLocations(category:"Campus",locationName:"De La Guerra (DLG) Dining Common", coordinates: CLLocation(latitude:
			34.409605, longitude: -119.845124)),
		GMLocations(category:"Campus",locationName:"Carrillo Dining Common", coordinates: CLLocation(latitude:
			34.410034, longitude: -119.852872)),
		GMLocations(category:"Campus",locationName:"Ortega Dining Common", coordinates: CLLocation(latitude:
			34.410977, longitude: -119.847012)),
		GMLocations(category:"Campus",locationName:"Portola Dining Common", coordinates: CLLocation(latitude:
			34.418075, longitude: -119.868026)),
		GMLocations(category:"Campus",locationName:"Former Women’s Center (near Old Gym)", coordinates: CLLocation(latitude: 34.413211, longitude: -119.849455)),
		GMLocations(category:"Campus",locationName:"Old Gym", coordinates: CLLocation(latitude: 34.414552, longitude: -119.848099)),
		GMLocations(category:"Campus",locationName:"Materials Research Laboratory (MRL)", coordinates: CLLocation(latitude: 34.414178, longitude: -119.841851)),
		GMLocations(category:"Campus",locationName:"Trailer 932 (behind Davidson Library) ", coordinates: CLLocation(latitude: 34.413876, longitude: -119.845571)),
		GMLocations(category:"Campus",locationName:"Physics Trailer 3", coordinates: CLLocation(latitude: 34.414048, longitude: -119.843006)),
		GMLocations(category:"Campus",locationName:"Physics Trailer 2", coordinates: CLLocation(latitude: 34.414048, longitude: -119.843006)),
		GMLocations(category:"Campus",locationName:"Physics Trailer 1", coordinates: CLLocation(latitude: 34.414048, longitude: -119.843006)),
		GMLocations(category:"Campus",locationName:"Trailer 940 (behind Davidson Library)", coordinates: CLLocation(latitude: 34.413876, longitude: -119.845571)),
		GMLocations(category:"Campus",locationName:"Anacapa Residence Hall", coordinates: CLLocation(latitude: 34.411017, longitude: -119.843019)),
		GMLocations(category:"Campus",locationName:"Arts Building", coordinates: CLLocation(latitude: 34.412588, longitude: -119.849499)),
		GMLocations(category:"Campus",locationName:"Biological Sciences II", coordinates: CLLocation(latitude: 34.411973, longitude: -119.842712)),
		GMLocations(category:"Campus",locationName:"Broida Hall (Physics) ", coordinates: CLLocation(latitude: 34.414048, longitude: -119.843006)),
		GMLocations(category:"Campus",locationName:"Bren Hall", coordinates: CLLocation(latitude: 34.412143, longitude: -119.842105)),
		GMLocations(category:"Campus",locationName:"Biological Sciences Instructional Facility", coordinates: CLLocation(latitude: 34.411973, longitude: -119.842712)),
		GMLocations(category:"Campus",locationName:"Buchanan Hall", coordinates: CLLocation(latitude: 34.415493, longitude: -119.844547)),
		GMLocations(category:"Campus",locationName:"Campbell Hall", coordinates: CLLocation(latitude: 34.416232, longitude: -119.845357)),
		GMLocations(category:"Campus",locationName:"Chemistry Building", coordinates: CLLocation(latitude: 34.415502, longitude: -119.842181)),
		GMLocations(category:"Campus",locationName:"Ellison Hall", coordinates: CLLocation(latitude: 34.415754, longitude: -119.845228)),
		GMLocations(category:"Campus",locationName:"Embarcadero Hall", coordinates: CLLocation(latitude: 34.412191, longitude: -119.855868)),
		GMLocations(category:"Campus",locationName:"Engineering Building II", coordinates: CLLocation(latitude: 34.414905, longitude: -119.841532)),
		GMLocations(category:"Campus",locationName:"Engineering Sciences Building", coordinates: CLLocation(latitude: 34.415489, longitude: -119.841355)),
		GMLocations(category:"Campus",locationName:"Event Center", coordinates: CLLocation(latitude: 34.413773, longitude: -119.851264)),
		GMLocations(category:"Campus",locationName:"Girvetz Hall", coordinates: CLLocation(latitude: 34.413296, longitude: -119.847116)),
		GMLocations(category:"Campus",locationName:"Harold Frank Hall (previously Engineering I) ", coordinates: CLLocation(latitude: 34.413783, longitude: -119.841134)),
		GMLocations(category:"Campus",locationName:"Humanities and Social Sciences Building", coordinates: CLLocation(latitude: 34.413631, longitude: -119.850642)),
		GMLocations(category:"Campus",locationName:"Isla Vista Theatre", coordinates: CLLocation(latitude: 34.41132, longitude: -119.855039)),
		GMLocations(category:"Campus",locationName:"Kerr Hall", coordinates: CLLocation(latitude: 34.414481, longitude: -119.847091)),
		GMLocations(category:"Campus",locationName:"Kohn Hall", coordinates: CLLocation(latitude: 34.414402, longitude: -119.840369)),
		GMLocations(category:"Campus",locationName:"Library", coordinates: CLLocation(latitude: 34.413876, longitude: -119.845571)),
		GMLocations(category:"Campus",locationName:"Life Science Building", coordinates: CLLocation(latitude: 34.411836, longitude: -119.843506)),
		GMLocations(category:"Campus",locationName:"Manzanita Village De Anza Center", coordinates: CLLocation(latitude: 34.40959, longitude: -119.852824)),
		GMLocations(category:"Campus",locationName:"Marine Biology Laboratory", coordinates: CLLocation(latitude: 34.412506, longitude: -119.842465)),
		GMLocations(category:"Campus",locationName:"Music Building", coordinates: CLLocation(latitude: 34.412128, longitude: -119.847053)),
		GMLocations(category:"Campus",locationName:"Lotte Lehmann Concert Hall", coordinates: CLLocation(latitude: 34.412128, longitude: -119.847053)),
		GMLocations(category:"Campus",locationName:"Noble Hall", coordinates: CLLocation(latitude: 34.412511, longitude: -119.843951)),
		GMLocations(category:"Campus",locationName:"North Hall", coordinates: CLLocation(latitude: 34.415454, longitude: -119.846308)),
		GMLocations(category:"Campus",locationName:"Phelps Hall", coordinates: CLLocation(latitude: 34.4161308, longitude: -119.8446426)),
		GMLocations(category:"Campus",locationName:"Physical Sciences Building North", coordinates: CLLocation(latitude: 34.406022, longitude: -119.697852)),
		GMLocations(category:"Campus",locationName:"Physical Sciences Building South", coordinates: CLLocation(latitude: 34.406022, longitude: -119.697852)),
		GMLocations(category:"Campus",locationName:"Psychology Building", coordinates: CLLocation(latitude: 34.412163, longitude: -119.845085)),
		GMLocations(category:"Campus",locationName:"Recreation Center", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"Recreation Center Tennis Courts", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"Recreation Center Main Gym", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"Recreation Center Pavilion", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"Recreation Center Weight Room", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"Robertson Gym", coordinates: CLLocation(latitude: 34.416232, longitude: -119.849412)),
		GMLocations(category:"Campus",locationName:"Robertson Gym Tennis Courts", coordinates: CLLocation(latitude: 34.416232, longitude: -119.849412)),
		GMLocations(category:"Campus",locationName:"Robertson Gym Field", coordinates: CLLocation(latitude: 34.416232, longitude: -119.849412)),
		GMLocations(category:"Campus",locationName:"Recreation Center Racquet Courts", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"Student Affairs and Administrative Services Building", coordinates: CLLocation(latitude: 34.416086, longitude: -119.847057)),
		GMLocations(category:"Campus",locationName:"San Miguel Residence Hall", coordinates: CLLocation(latitude: 34.410267, longitude: -119.84666)),
		GMLocations(category:"Campus",locationName:"San Nicholas Residence Hall", coordinates: CLLocation(latitude: 34.409546, longitude: -119.846194)),
		GMLocations(category:"Campus",locationName:"San Rafael Residence Hall", coordinates: CLLocation(latitude: 34.41094, longitude: -119.852856)),
		GMLocations(category:"Campus",locationName:"Santa Cruz Residence Hall", coordinates: CLLocation(latitude: 34.409913, longitude: -119.843773)),
		GMLocations(category:"Campus",locationName:"Santa Rosa Residence Hall", coordinates: CLLocation(latitude: 34.41078, longitude: -119.845098)),
		GMLocations(category:"Campus",locationName:"Softball Field", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"South Hall", coordinates: CLLocation(latitude: 34.414051, longitude: -119.847190)),
		GMLocations(category:"Campus",locationName:"Stadium Tennis Courts", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"Stadium Field", coordinates: CLLocation(latitude: 34.420044, longitude: -119.854597)),
		GMLocations(category:"Campus",locationName:"Storke Field", coordinates: CLLocation(latitude: 34.419195, longitude: -119.856427)),
		GMLocations(category:"Campus",locationName:"Student Health Center", coordinates: CLLocation(latitude: 34.415662, longitude: -119.852876)),
		GMLocations(category:"Campus",locationName:"Student Resources Building", coordinates: CLLocation(latitude: 34.412818, longitude: -119.852537)),
		GMLocations(category:"Campus",locationName:"Swimming Pool", coordinates: CLLocation(latitude: 34.418175, longitude: -119.849844)),
		GMLocations(category:"Campus",locationName:"Theater/Dance East", coordinates: CLLocation(latitude: 34.412525, longitude: -119.850751)),
		GMLocations(category:"Campus",locationName:"Theater/Dance West", coordinates: CLLocation(latitude: 34.412552, longitude: -119.851244)),
		GMLocations(category:"Campus",locationName:"Track Field", coordinates: CLLocation(latitude: 34.41827, longitude: -119.849114)),
		GMLocations(category:"Campus",locationName:"UCEN", coordinates: CLLocation(latitude: 34.411611, longitude: -119.848321)),
		GMLocations(category:"Campus",locationName:"Webb Hall", coordinates: CLLocation(latitude: 34.413356, longitude: -119.843635)),
		]
	
	// The following 2 properties are set in viewDidLoad(),
	// They an implicitly unwrapped optional because they are used in many other places throughout this view controller
	//
	/// Search controller to help us with filtering.
	var searchController: UISearchController!
	/// Secondary search results table view.
	var resultsTableController: ResultsTableController!
	/// Global variable that holds the seleted location
	var selectedLocation: GMLocations?
	
	// MARK:- View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		resultsTableController = ResultsTableController()
		
		// We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
		resultsTableController.tableView.delegate = self
		
		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController.searchResultsUpdater = self
		searchController.searchBar.sizeToFit()
		tableView.tableHeaderView = searchController.searchBar
		
		searchController.delegate = self
		searchController.dimsBackgroundDuringPresentation = false // default is YES
		searchController.searchBar.delegate = self    // so we can monitor text changes + others
		
		// Search is now just presenting a view controller. As such, normal view controller
		// presentation semantics apply. Namely that presentation will walk up the view controller
		// hierarchy until it finds the root view controller or one that defines a presentation context.
		definesPresentationContext = true
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	// MARK: UISearchBarDelegate
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	// MARK:- Util methods
	
	func hideSearchBar() {
		let yOffset = self.navigationController!.navigationBar.bounds.height + UIApplication.shared.statusBarFrame.height
		self.tableView.contentOffset = CGPoint(x: 0, y: self.searchController!.searchBar.bounds.height - yOffset)
	}
	
	
	// MARK: UISearchResultsUpdating
	
	func updateSearchResults(for searchController: UISearchController) {
		// Update the filtered array based on the search text.
		let searchResults = locations
		
		// Strip out all the leading and trailing spaces.
		let whitespaceCharacterSet = CharacterSet.whitespaces
		let strippedString = searchController.searchBar.text.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
		let searchItems = strippedString.componentsSeparatedByString(" ") as [String]
		
		// Build all the "AND" expressions for each value in the searchString.
		var andMatchPredicates = [NSPredicate]()
		
		for searchString in searchItems {
			// Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
			//
			// Example if searchItems contains "iphone 599 2007":
			//      name CONTAINS[c] "iphone"
			//      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
			//      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
			//
			var searchItemsPredicate = [NSPredicate]()
			
			// Below we use NSExpression represent expressions in our predicates.
			// NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value).
			
			// Name field matching.
			var lhs = NSExpression(forKeyPath: "locationName")
			var rhs = NSExpression(forConstantValue: searchString)
			
			var finalPredicate = NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier: .DirectPredicateModifier, type: .ContainsPredicateOperatorType, options: .CaseInsensitivePredicateOption)
			
			searchItemsPredicate.append(finalPredicate)
			
			// Add this OR predicate to our master AND predicate.
			let orMatchPredicates = NSCompoundPredicate.orPredicateWithSubpredicates(searchItemsPredicate)
			andMatchPredicates.append(orMatchPredicates)
		}
		
		// Match up the fields of the Location object.
		let finalCompoundPredicate = NSCompoundPredicate.andPredicate(withSubpredicates: andMatchPredicates)
		
		let filteredResults = searchResults.filter(){ finalCompoundPredicate.evaluate(with: $0) }
		
		// Hand over the filtered results to our search results table.
		let resultsController = searchController.searchResultsController as! ResultsTableController
		resultsController.filteredLocations = filteredResults
		resultsController.tableView.reloadData()
	}

	// MARK:- UITableView DataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return locations.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "locationList")! as UITableViewCell
		cell.textLabel?.text = locations[indexPath.row].locationName
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		// Note: Should not be necessary but current iOS 8.0 bug requires it.
		tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
		
		// Check to see which table view cell was selected.
		if tableView == self.tableView {
			selectedLocation = locations[(indexPath as NSIndexPath).row]
		}
		else {
			selectedLocation = resultsTableController.filteredLocations[(indexPath as NSIndexPath).row]
		}
		
		self.performSegue(withIdentifier: "unwindToCreateEvent", sender: self)
	}

	
	// MARK:- UISearchControllerDelegate methods
	
	func didDismissSearchController(_ searchController: UISearchController) {
		UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: { () -> Void in
			self.hideSearchBar()
			}, completion: nil)
	}
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
		if segue.identifier == "unwindToCreateEvent" {
			let createEventView = segue.destination as! GMCRTEventTableViewController
			createEventView.eventLocation = selectedLocation!.locationName
			createEventView.tableView.reloadData()
		}
	}
}




