//
//  MapAndCoreLocation.h
//  Tuts
//
//  Created by Manoj pratap singh rana on 03/12/16.
//  Copyright © 2016 impetus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapAndCoreLocation : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
