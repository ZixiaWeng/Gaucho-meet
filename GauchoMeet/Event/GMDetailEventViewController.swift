//
//  GMDetailEventViewController.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 2/4/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit
import MapKit

/// Controls DetailEventView
class GMDetailEventViewController: UITableViewController {
	/// Holds a reference to the event
	var event: PFObject!
	/// Holds a reference to the event's host
	var host:PFUser!
	var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.rowHeight = UITableViewAutomaticDimension
		
	}
	// MARK: - TableView
	/// Returns the number of rows
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	/// Constructs a cell for each row
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (indexPath as NSIndexPath).row == 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell") as! GMProfileTableViewCell
			cell.userNameLabel.text = host.username
			cell.majorLable.text = host["major"] as? String
			cell.classLabel.text = host["class"] as? String
			var profilePic = host["userImage"] as! PFFile?
			if (profilePic != nil) {
				profilePic!.getDataInBackgroundWithBlock{
					(imageData:Data!, error:NSError!)->Void in
					if (error == nil){
						let image:UIImage = UIImage(data: imageData)!
						cell.profilePic.image = image
					}
					else{
						println("Failed converting data to Image")
					}
				}
			}
			return cell
		}
		else if (indexPath as NSIndexPath).row == 4 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! GMLocationTableViewCell
			self.mapView = cell.mapView
			let span = MKCoordinateSpanMake(0.007, 0.007)
			let coor = CLLocationCoordinate2DMake((event["coordinates"] as! PFGeoPoint).latitude, (event["coordinates"] as! PFGeoPoint).longitude)
			var region =  MKCoordinateRegionMake(coor, span)
			self.mapView.setRegion(region, animated: false)
			cell.nameLable.text = event["location"] as? String
			var annotation = MKPointAnnotation()
			annotation.setCoordinate(coor)
			mapView.addAnnotation(annotation)
			let hashv = cell.nameLable.text.hashValue
			return cell
		}
		else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "eventDetailCell")! as UITableViewCell
			switch (indexPath as NSIndexPath).row {
			case 0:
				cell.textLabel?.text = "Event"
				cell.detailTextLabel?.text = self.event["description"] as? String
			case 1:
				cell.textLabel?.text = "Type"
				cell.detailTextLabel?.text = self.event["type"] as? String
			case 2:
				cell.textLabel?.text = "Time"
				cell.detailTextLabel?.text = GMDateFormatter.stringFromDate(event["plannedTime"] as NSDate)
			default:
				cell.textLabel?.text = "Time"
			}
			return cell
		}
	}
	/// Determines the height for certain rows
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if (indexPath as NSIndexPath).row == 3 {
			return 125
		}
		if (indexPath as NSIndexPath).row == 4 {
			return 180
		}
		return 44
	}
	/// Opens ProfileViewController wehn host's/participants' row is selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
		if (indexPath as NSIndexPath).row == 3 {
			let storyboard = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
			let profileView = storyboard.instantiateViewController(withIdentifier: "profileView") as! ProfileViewController
			profileView.myPresentedUser = event["host"] as! PFUser
			profileView.myPresentedUser.fetchIfNeeded()
			profileView.navigationItem.rightBarButtonItem = nil
            profileView.hideAddFriendButton = false
            profileView.hideFriendListButton = true
			self.show(profileView, sender: nil)
		}
		else if (indexPath as NSIndexPath).row == 4 {
			let placeMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake((event["coordinates"] as! PFGeoPoint).latitude, (event["coordinates"] as! PFGeoPoint).longitude), addressDictionary: nil)
			let mapItems = [MKMapItem(placemark: placeMark)]
			mapItems[0].name = event["location"] as! String
			MKMapItem.openMaps(with: mapItems, launchOptions: nil)
		}
		
		
	}
	
}
