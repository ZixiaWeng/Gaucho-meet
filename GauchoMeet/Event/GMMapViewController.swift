//
//  GMMapViewController.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 1/22/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// It manages user's location, initiates the map frame and present event annotations
class GMMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	
	private static var __once: () = {
			let span = MKCoordinateSpanMake(0.01, 0.01)
			var region =  MKCoordinateRegionMake(mapView.userLocation.coordinate, span)
			GMMapViewController.mapView.setRegion(region, animated: true )
			self.updateAnotations()
		}()
	
	/// A CLLicationManager taking care of user's current location
	let locationManager = CLLocationManager()
	/// An NSMutableArray that stores events
	var dataArray: NSMutableArray = []
	
	@IBOutlet weak var mapView:MKMapView!
	
	/// Initializes
	///
	/// * locationMnager
	/// * Add self as an obsever of the default notification center
	override func viewDidLoad() {
		super.viewDidLoad()
		// Mapview & CLLocationManager initialization
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestAlwaysAuthorization()
		self.locationManager.startUpdatingLocation()
		
		// Add as an observer
		NotificationCenter.default.addObserver(self, selector:#selector(GMMapViewController.updateAnotations), name:NSNotification.Name(rawValue: GMEventUpdatedNotification), object: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - MapView
	
	/// Show an area on map according to user's current location
	func mapView(_ mapView: MKMapView!, didUpdate userLocation: MKUserLocation!) {
		// use dispatch_once_t to make suer it will only be called once
		struct TokenHolder {
			static var token: Int = 0
		}
		
		_ = GMMapViewController.__once
	}
	
	/// Generates MKAnnotationView for GMEventViewAnnotation
	///
	/// :param: annotation The annotaion being processed
	///
	/// :returns: MKAnnotationView, or nil when user's current location is passed in
	func mapView(_ mapView: MKMapView!, viewForAnnotation annotation: GMEventViewAnnotation!) -> MKAnnotationView! {
		if annotation.isKind(of: MKUserLocation.self) {
			return nil
		}
		
		return annotation.creatEventAnnotationView(mapView, annotation: annotation)
	}
	
	/// Defines the behavior when an annotation's accessory control button is tapped
	func mapView(_ mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
		for (i in 0 ..< self.dataArray.count ) {
			let event = self.dataArray[i] as! PFObject
			if ( (view.annotation as GMEventViewAnnotation).identifier ==  event.objectId as String) {
				self.performSegueWithIdentifier("showEventDetailFromMap", sender: event)
				return
			}
		}
	}
	
	/// Updates anotations after an new event is created or an user triggers the refresh function
	func updateAnotations(){
		mapView.removeAnnotations(mapView.annotations)
		for (i in 0 ..< self.dataArray.count ) {
			let event = self.dataArray[i] as! PFObject
			let coor = CLLocationCoordinate2DMake((event["coordinates"] as PFGeoPoint).latitude, (event["coordinates"] as PFGeoPoint).longitude)
			var annotation = MKPointAnnotation()
			annotation.setCoordinate(coor)
			annotation.title = event["description"] as? String
			annotation.subtitle = GMDateFormatter.stringFromDate(event["plannedTime"] as NSDate)
			var returnAnnotation = GMEventViewAnnotation(annotation: annotation, reuseIdentifier:NSStringFromClass(GMEventViewAnnotation), identifier: event.objectId as String)
			mapView.addAnnotation(returnAnnotation)
		}
		
	}
	
	// MARK: - LocationManagerDelegate
	func locationManager(_ manager: CLLocationManager!, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == CLAuthorizationStatus.authorizedWhenInUse {
			manager.delegate = self
			manager.desiredAccuracy = kCLLocationAccuracyBest
			manager.startUpdatingLocation()
		}
	}
	
	// MARK: - Navigation
	/// Passes a reference of event to GMDetailEventViewController
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showEventDetailFromMap" {
			let target = segue.destination as! GMDetailEventViewController
			target.event = sender as! PFObject
			target.host = target.event["host"] as! PFUser
			target.host.fetchIfNeeded()
		}
	}
	
}
