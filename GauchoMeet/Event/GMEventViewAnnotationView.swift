//
//  GMEventViewAnnotation.swift
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 2/7/15.
//  Copyright (c) 2015 Golden: Tyler Weimin Ouyang, Geon Lee, Zixia Weng, Manpreet Bahia. All rights reserved.
//

import UIKit
import MapKit

class GMEventViewAnnotation: NSObject, MKAnnotation {

	var coordinate: CLLocationCoordinate2D
	var title: String
	var subtitle: String
	var identifier: String
	
	init( annotation: MKAnnotation!, reuseIdentifier: String!, identifier: String!){
		self.coordinate = annotation.coordinate
		self.title = annotation.title!!
		self.subtitle = annotation.subtitle!!
		self.identifier = identifier
	}

	func creatEventAnnotationView(_ mapView: MKMapView, annotation: GMEventViewAnnotation) -> MKAnnotationView! {
		
		var returnView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(GMEventViewAnnotation))
		
		if returnView == nil {
			returnView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(GMEventViewAnnotation))
			(returnView as! MKPinAnnotationView).animatesDrop = true
			(returnView as! MKPinAnnotationView).canShowCallout = true
			var rightButton = UIButton.withType(UIButtonType.detailDisclosure) as UIButton
			rightButton.addTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
			(returnView as! MKPinAnnotationView).rightCalloutAccessoryView = rightButton
		}
		return returnView
	}
	
}
