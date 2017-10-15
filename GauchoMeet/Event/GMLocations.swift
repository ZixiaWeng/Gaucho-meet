//
//  Candy.swift
//  CandySearch
//
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation

class GMLocations: NSObject {
	let category : String
	let locationName : String
	let coordinates : CLLocation
	
	init (category: String, locationName: String, coordinates: CLLocation) {
		self.category = category
		self.locationName = locationName
		self.coordinates = coordinates
	}
	
	// MARK: Types
	
	struct CoderKeys {
		static let name = "locationNameKey"
		static let type = "categoryKey"
		static let coor = "coordinatesKey"
	}
	
	// MARK: NSCoding
	
	required init(coder aDecoder: NSCoder) {
		locationName = aDecoder.decodeObject(forKey: CoderKeys.name) as! String
		category = aDecoder.decodeObject(forKey: CoderKeys.type) as! String
		coordinates = aDecoder.decodeObject(forKey: CoderKeys.coor) as! CLLocation
	}
	
	func encodeWithCoder(_ aCoder: NSCoder) {
		aCoder.encode(locationName, forKey: CoderKeys.name)
		aCoder.encode(category, forKey: CoderKeys.type)
		aCoder.encode(coordinates, forKey: CoderKeys.coor)
	}
	

}
