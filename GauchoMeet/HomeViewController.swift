//
//  HomeViewController.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 12/30/14.
//  Copyright (c) 2014 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit
/// Date formatter for dates
var GMDateFormatter = DateFormatter()
let GMPostEventNotification = "GMPostEventNotification"
let GMEventUpdatedNotification = "GMEventUpdatedNotification"
class HomeViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedConrtol: UISegmentedControl!
	@IBOutlet weak var mapView: UIView!
	

	let locationManager = CLLocationManager()
	var query = PFQuery(className:"eventDemo")
	var entries = 0
	var dataArray: NSMutableArray = []
	var refreshControl: UIRefreshControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Decide what to show
		// http://www.ioscreator.com/tutorials/segmented-control-tutorial-ios8-swift
		switch segmentedConrtol.selectedSegmentIndex {
		case 0:
			mapView.isHidden = true
			tableView.isHidden = false;
		case 1:
			tableView.isHidden = true
			mapView.isHidden = false;
			
		default:
			break;
		}
		
		// DateFormatter setup
		GMDateFormatter.dateStyle = DateFormatter.Style.short
		GMDateFormatter.timeStyle = DateFormatter.Style.short
		
		// Refresh
		self.refreshControl = UIRefreshControl()
		self.refreshControl.backgroundColor = UIColor.gray
		self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
		self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), for: UIControlEvents.valueChanged)
		self.tableView.addSubview(self.refreshControl)
		
		// Add self as a notification obsever
		NotificationCenter.default.addObserver(self, selector:#selector(HomeViewController.updateTableView), name:NSNotification.Name(rawValue: GMPostEventNotification), object: nil)
		
		// query from server and store data in a NSMutableArray
		query?.cachePolicy = kPFCachePolicyCacheElseNetwork
		query?.maxCacheAge = 60 * 10 // set cache time to 10 min
		query?.limit = 10
		self.updateTableView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func unwindToHome(_ segue:UIStoryboardSegue) {
		
	}
	
	
	// MARK: - TableView
	// http://adoptioncurve.net/archives/2014/07/a-minimum-viable-tableview-in-swift/
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.entries
	}
	
	func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
		let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! GMEventTableViewCell
		
		let event = dataArray[indexPath.row] as! PFObject
		cell.eventTitleLabel.text = (event["description"] as! NSString) as String
		cell.eventDescLabel.text = GMDateFormatter.string(from: (event["plannedTime"] as! NSDate) as Date)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func updateTableView() {
		// Query from server
		var now = Date()
		query?.whereKey("plannedTime", greaterThan: now)
		query.findObjectsInBackground {
			(objects: [AnyObject]!, error: NSError!) -> Void in
			if error == nil {
				// The find succeeded.
				NSLog("Successfully retrieved \(objects.count) events.")
				
				// Do something with the found objects
				self.dataArray.removeAllObjects()
				self.dataArray.addObjects(from: objects)
				self.entries = objects.count
				self.tableView.reloadData()
				self.refreshControl.endRefreshing()
				
				// Send notification
				NotificationCenter.default.post(name: Notification.Name(rawValue: GMEventUpdatedNotification), object: nil)
			} else {
				// Log details of the failure
				NSLog("Error: %@ %@", error, error.userInfo!)
				self.refreshControl.endRefreshing()
				
			}
		}
	}
	
	// MARK: Refresh
	func refresh(_ sender:AnyObject){
		self.updateTableView()
	}
	
	
	// MARK: - Segmented Control
	@IBAction func ViewChanged(_ sender: UISegmentedControl) {
		switch segmentedConrtol.selectedSegmentIndex {
		case 0:
			mapView.isHidden = true
			tableView.isHidden = false;
		case 1:
			tableView.isHidden = true
			mapView.isHidden = false;
			
		default:
			break;
		}
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Pass reference to the deatil event view
		if segue.identifier == "showEventDetail" {
			let target = segue.destination as! GMDetailEventViewController
			let selectedIndexPath = self.tableView.indexPath(for: sender as! GMEventTableViewCell)
			target.event = dataArray[selectedIndexPath!.row] as! PFObject
			target.host = target.event["host"] as! PFUser
			target.host.fetchIfNeeded()
		}
		else if segue.identifier == "mapViewRelation" {
			let target = segue.destination as! GMMapViewController
			target.dataArray = self.dataArray
		}
	}
	
}
