//
//  MapAndCoreLocation.m
//  Tuts
//
//  Created by Manoj pratap singh rana on 03/12/16.
//  Copyright © 2016 impetus. All rights reserved.
//

#import "MapAndCoreLocation.h"
#import "MapAnnotation.h"

@interface MapAndCoreLocation ()
@property (nonatomic,strong) CLLocationManager *locationManager;

//Geo-coding property ,class
@property (nonatomic, strong) CLGeocoder *geocoder;
//End Geo
@end

@implementation MapAndCoreLocation

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return  self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    /* Set the map type to Satellite */
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate=self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    
    /* CoreLocation setup
     a)Add "location-services" item under "Require Device capability" key
     b)If gps required add gps too
     c)Add new key "Privacy - Location When In Use Usage Description" or "Privacy - Location Always In Use Usage Description" if SignificatLocation services needed
     */
    _locationManager=[CLLocationManager new];
    _locationManager.delegate=self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    if ([CLLocationManager locationServicesEnabled]) {
       //if location service enabled,check for authorization status
        CLAuthorizationStatus status=[CLLocationManager authorizationStatus];
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
            // Ask for user permission
        //Uncomment below line for enabling location
           [_locationManager requestWhenInUseAuthorization];
            break;
                
            case kCLAuthorizationStatusDenied:{
                //Show alert that location not permitted by user,ask to enable
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Location" message:@"Enable location from setting for this app" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
            
            default:
                break;
                
        }
    }
    //Call to add annotation
    [self addAnnotation];
    //Geo-Coding
    [self convertAddressToLatLong];
    
}

#pragma mark Add Annotation
-(void)addAnnotation{
//We are adding Annotation for Noida IMPetus building
    CLLocationCoordinate2D impetusCordinate=CLLocationCoordinate2DMake(28.6075627, 77.36833189999993);
    MapAnnotation *annotation=[[MapAnnotation alloc] initWithCoordinates:impetusCordinate title:@"Impetus" subTitle:@"infront amarujala"];
    [self.mapView addAnnotation:annotation];
}

#pragma mark GeoCoding

-(void)convertAddressToLatLong{
[self.geocoder geocodeAddressString:@"Impetus" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
   
    if (placemarks.count > 0 && error == nil){
        NSLog(@"Found %lu placemark(s).",(unsigned long)[placemarks count]);
        CLPlacemark *firstPlacemark = placemarks[0];
      
        NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
        
        NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
    }
    else if (placemarks.count == 0 &&
             error == nil){
        NSLog(@"Found no placemarks.");
    }
    else if (error != nil){
        NSLog(@"An error occurred = %@", error);
    }


}];
}

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status==kCLAuthorizationStatusAuthorizedAlways || status==kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager startUpdatingLocation];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//locations array contains location fetched by location service.Location at index 0 is the latest location
    if(locations!=nil && locations.count>0){
        NSLog(@"Current location %@",locations[0]);
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//If location service failed to fetch current location, we print logs for that
    NSLog(@"Error in fetching location: %@",error.description);
}

#pragma mark MapViewDelegateMethods
/*
 MapViewDeleagte protocol has follwing methods in order to recieve message from mapView
 
 mapViewWillStartLoadingMap:
 This method is called on the delegate object whenever the map view starts to load the data that visually represents the map to the user.
 
 mapView:viewForAnnotation:
 This method is called on the delegate object whenever the map view is asking for an instance of MKAnnotationView to visually represent an annotation on the map. 
 
 mapViewWillStartLocatingUser:
 This method, as its name implies, gets called on the delegate object whenever the map view starts to detect the user’s location. 
 
 mapView:regionDidChangeAnimated:
 This method gets called on the delegate object whenever the region displayed by the map changes.

 */

//Confiure it for custom annatation view
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKAnnotationView *result = nil;
    if ([annotation isKindOfClass:[MapAnnotation class]] == NO){
        return result;
    }
    
    if ([mapView isEqual:self.mapView] == NO){
        /* We want to process this event only for the Map View
         that we have created previously */
        return result;
    }
    
    /* First typecast the annotation for which the Map View has
     fired this delegate message */
    MapAnnotation *senderAnnotation = (MapAnnotation *)annotation;
   
    
    /* we are about to create resusable identifier*/
    NSString *pinReusableIdentifier =@"pin";
    
    /* Using the identifier we retrieved above, we will
     attempt to reuse a pin in the sender Map View */
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView  dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    
    if (annotationView == nil){
        /* If we fail to reuse a pin, then we will create one */
        annotationView =
        [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation
                                        reuseIdentifier:pinReusableIdentifier];
        /* Make sure we can see the callouts on top of
         each pin in case we have assigned title and/or
         subtitle to each pin */
        annotationView.canShowCallout = YES;
    }
    annotationView.pinTintColor=[UIColor blueColor];
    result = annotationView;
    return result;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //Not right place to serch,we can save userlocation in property and then use that locaion to trigger seach operation
    //Locatio search, near by
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"restaurants";
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    request.region =
    MKCoordinateRegionMake(userLocation.location.coordinate, span);
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:
     ^(MKLocalSearchResponse *response, NSError *error) { for (MKMapItem *item in response.mapItems){
        NSLog(@"Item name = %@", item.name);
        NSLog(@"Item phone number = %@", item.phoneNumber);
        NSLog(@"Item url = %@", item.url);
        NSLog(@"Item location = %@", item.placemark.location);
    } }];
}

@end
