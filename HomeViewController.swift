//
//  HomeViewController.swift
//  PinLoco
//
//  Created by Nicholas Cai on 11/13/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBAction func locateUser(sender: AnyObject) {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
            self.mapView.setRegion(region, animated: true)
            self.locationManager.stopUpdatingLocation()
        }
        
        addAnnotation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
//        UIImage *annotationImage = [UIImage imageNamed:@"annotation-image"]; //NOTE: Using a UIImageView will not work
//        annotationView.image = annotationImage; // NOTE: Make sure annotationView is an instance of MKAn
    }
    
    func addAnnotation() {
        let lat = 37.3175
        let long = -122.0419
        
        var annotationView: MKPinAnnotationView!
        var myAnnotation: CustomPointAnnotation!
        
        myAnnotation = CustomPointAnnotation()
        myAnnotation.title = "Hello"
        myAnnotation.subtitle = "Nick"
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        myAnnotation.pinImageName = "High Income"
        annotationView = MKPinAnnotationView(annotation: myAnnotation, reuseIdentifier: "pin")
        self.mapView.addAnnotation(annotationView.annotation!)
    }
    
    func mapView(mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
            print("hello")
            let reuseIdentifier = "pin"
            
            var v = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
            if v == nil {
                v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                v!.canShowCallout = true
            }
            else {
                v!.annotation = annotation
            }
            
            let customPointAnnotation = annotation as! CustomPointAnnotation
            v!.image = UIImage(named:customPointAnnotation.pinImageName)
            
            return v
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
