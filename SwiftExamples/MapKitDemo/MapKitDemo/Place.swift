//
//  Place.swift
//  MapKitDemo
//
//  Created by Manoj Pratap on 04/04/17.
//  Copyright © 2017 learning. All rights reserved.
//

import Foundation
import MapKit
class Place : NSObject {
    var title : String?
    var coordinate : CLLocationCoordinate2D
    var subtitle: String?
    
    init(title : String?, subtitle : String?, coordinate : CLLocationCoordinate2D  ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static var locations : [Place] = [
        Place(title: "Delhi", subtitle: "Welcome to Delhi", coordinate:CLLocationCoordinate2D(latitude: 28.7041,longitude: 77.1025)),
        Place(title: "Noida", subtitle: "Welcome to Noida", coordinate:CLLocationCoordinate2D(latitude: 28.5355,longitude: 77.3910)),
        Place(title: "Ghaziabad", subtitle: "Welcome to Ghaziabad", coordinate:CLLocationCoordinate2D(latitude: 28.6692,longitude: 77.4538))
    ]
 
}

extension Place  : MKAnnotation{

}
