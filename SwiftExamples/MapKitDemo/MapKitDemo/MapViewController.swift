//
//  MapViewController.swift
//  MapKitDemo
//
//  Created by Manoj Pratap on 04/04/17.
//  Copyright © 2017 learning. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController , MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Request User Location
        requestUserLocation()
        
        // add Annotation
        addAnnotation()
    }

    func requestUserLocation(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            return
            
        case .denied,.restricted:
            print("Location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
  
    func addAnnotation(){
        mapView.delegate = self
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
}
