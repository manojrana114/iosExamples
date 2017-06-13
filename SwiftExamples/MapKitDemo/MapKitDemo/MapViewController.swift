//
//  MapViewController.swift
//  MapKitDemo
//
//  Created by Manoj Pratap on 04/04/17.
//  Copyright © 2017 learning. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController , MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Request User Location
        requestUserLocation()
        // set delegate
        locationManager.delegate = self;
        
        
        mapView.delegate = self

        // add Annotation
        //addAnnotation()
        
        //Add Route
        //drawRoute()
        startMonitoringRegion()

    }

    func requestUserLocation(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            return
            
        case .denied,.restricted:
            print("Location access denied")
            
        default:
            //locationManager.requestWhenInUseAuthorization()
    
            //Code for regio monotoring
            locationManager.requestAlwaysAuthorization()
        }
    }
  
    func startMonitoringRegion(){
        
        //Add MK Circle around monitoring region
        let monitoredRegionOverLay = MKCircle(center:
            .init(latitude: 28.616988, longitude: 77.371626), radius: 200)
        mapView.add(monitoredRegionOverLay)
        
        //Monitor region
        let currRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 28.616988, longitude: 77.371626), radius: 200, identifier: "Home")
        locationManager.startMonitoring(for: currRegion)
        
    }
    
    //MARK : Add annotation to map
    func addAnnotation(){
        mapView.addAnnotations(Place.locations)
    }
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ANNOTATION") ?? MKAnnotationView()
        annotationView.image = UIImage(named: "Annotations")
        annotationView.canShowCallout = true;
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        //Add Circular overlay
        let overlays = Place.locations.map {MKCircle(center: $0.coordinate, radius: 100)}
        mapView.addOverlays(overlays)
        
        //add polyLines
        var locations = Place.locations.map{$0.coordinate}
        let polyLines = MKPolyline(coordinates: &locations, count: locations.count)
        mapView.add(polyLines)
        
        // Add Polygons
        let polygon = MKPolygon(coordinates: &locations, count: locations.count)
        mapView.add(polygon)
        return annotationView;
    }

    //MARK: Render Overlays (Circular region around Location)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if(overlay is MKCircle){
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.1)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
        
        if(overlay is MKPolyline){
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        }
        if(overlay is MKPolygon){
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.1)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    //MARK: Callout View
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //Show alert on tapping right disclosure button on callout
        guard let annotation =  view.annotation as? Place , let title = annotation.title else {return}
        
        let alert = UIAlertController(title: title, message: "you have selected \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
           
    }
    
    //MARK : Draw Route
    func drawRoute(){
    
        // 1) Source and destination coordinates
        let sourceCordinate = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472) //ABES
        let destinationCordinate = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564) //Noida
        
        // 2) Get PlaceMark from coordinates
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCordinate)
        
        // 3) Get MapItem from PlaceMark
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
    
        // 4) Request for direction
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .any
        
        // 5) create Direction
        let directions = MKDirections(request: directionRequest)

        // 6) Call calculateDirection
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0] // MKRoute
            self.mapView.add(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            
        }
    
    }
    
    
    //MARK : Region monitoring methods
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter region")

    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit region")
    }
}
