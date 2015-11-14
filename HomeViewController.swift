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
        
//        addAnnotation()
    }
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.doUpload = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        addAnnotation()
        
//        UIImage *annotationImage = [UIImage imageNamed:@"annotation-image"]; //NOTE: Using a UIImageView will not work
//        annotationView.image = annotationImage; // NOTE: Make sure annotationView is an instance of MKAn
    }
    
    func addAnnotation() {
        let lat = 37.3175
        let long = -122.0419
        
        var annotationView: MKPinAnnotationView!
        var myAnnotation = MKPointAnnotation()

        myAnnotation.title = "Hello"
        myAnnotation.subtitle = "Nick"
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        self.mapView.addAnnotation(myAnnotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = String(stringInterpolationSegment: annotation.coordinate.longitude)
        
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            
        }
        
        let button = UIButton(type: UIButtonType.DetailDisclosure)
        button.addTarget(self, action: "pin_press:", forControlEvents: .TouchUpInside)
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
    }
    
    func pin_press(sender: UIButton!) {
        print("PIN PRESSED LOL")
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
