//
//  HomeViewController.swift
//  PinLoco
//
//  Created by Nicholas Cai on 11/13/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import UIKit
import DKImagePickerController
import MapKit
import Parse

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: Properties
    var storedPinIDs: [String] = []
    let singleton = Singleton.sharedInstance
//    var lastUpdatedtime: NSDate!
    
    @IBAction func refreshButton(sender: AnyObject) {
//        let lat = self.mapView.centerCoordinate.latitude
//        let long = self.mapView.centerCoordinate.longitude
        refreshNewPins()
    }
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    
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
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func refreshNewPins() {

        print("Requesting pins from model")
        var newPinsAdded = 0
        let query = PFQuery(className: "Pin")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (pins: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Find succeeded
//                print("Successfully retrieved \(pins!.count) pins")
                if let pins = pins {
                    for p in pins {
                        let pinID = p.objectId!
                        if !(self.storedPinIDs.contains(pinID)) {
                            
                            // create the map annotation object
                            let pin = CustomPin()
                            let firstName = PFUser.currentUser()!["firstName"] as? String
                            let lastName = PFUser.currentUser()!["lastName"] as? String
                            pin.title = firstName! + " " + lastName!
                            pin.subtitle = PFUser.currentUser()!["avgScore"] as? String
                            pin.id = p.objectId!
                            
                            // add to the map
                            if let location = p["location"] {
                                pin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                                if MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate(pin.coordinate)) {
                                    self.mapView.addAnnotation(pin)
                                    self.storedPinIDs.append(pinID)
                                    newPinsAdded++
                                    // print("Annotating new pin")
                                }
                            }
                        }
                    }
                    if newPinsAdded == 0 {
                        print("No new pins to add\n")
                    } else {
                        print("Success! Added \(newPinsAdded) pins\n")
                    }
                    
                }
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        let currentLat = self.locationManager.location?.coordinate.latitude
        let currentLong = self.locationManager.location?.coordinate.longitude
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(currentLat!, currentLong!)
        
        refreshNewPins()
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadAnnotations", name: singletonUpdatedKey, object: nil)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = String(stringInterpolationSegment: annotation.coordinate.longitude)
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if pinView == nil {
            
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let pinImage = UIImage(named:"map_pin.png")
            pinView!.image = pinImage
            pinView!.canShowCallout = true
            pinView?.centerOffset = CGPointMake(0, -(pinImage!.size.height/2))
            
        }
        
//        anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        anView.image = UIImage(named:"1.png")
//        anView.canShowCallout = true
        
        let button = UIButton(type: UIButtonType.DetailDisclosure)
        button.addTarget(self, action: "pin_press:", forControlEvents: .TouchUpInside)
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
    }
    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            performSegueWithIdentifier("pinToPhotoTableSegue", sender: view)
//        }
//    }
    
    func pin_press(sender: UIButton!) {

        let homePhotoTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePhotoTVC") as? HomePhotoTableViewController
//        let segue = self.storyboard?.seg
        self.singleton.selectedPin = self.mapView.selectedAnnotations[0].self
        let selectedPin = self.mapView.selectedAnnotations[0]
        var customImages: [CustomImage] = []
        print(singleton.userData)
        for (p, i) in singleton.userData {
            if p.isEqual(selectedPin) {
                print("True")
                customImages = i
                print(customImages)
                print(p)
                print(selectedPin)
            }
        }
        var images: [UIImage] = []
        for i in customImages {
            images.append(i.image!)
        }
        homePhotoTableViewController!.imageList = images
        self.navigationController?.pushViewController(homePhotoTableViewController!, animated: true)
        print(images)
        print("L:LSDKJ")
//        self.navigationController?.performSegueWithIdentifier("pinToPhotoTableSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("hellO")
        // setting identifier as segue's identifer
        if let identifier = segue.identifier {
            switch identifier {
                // if the identifier is "Show Details" ...
            case "pinToPhotoTableSegue":
                print("DOOD")
                // then select the segue's destination (DetailedView) ...
                let homePhotoTableViewController = segue.destinationViewController as! HomePhotoTableViewController
                // and select the index of the tableviewcell which is actually the sender
                let selectedPin = self.mapView.selectedAnnotations[0]
                var customImages: [CustomImage] = []
                for (p, i) in singleton.userData {
                    if p.isEqual(selectedPin) {
                        customImages = i
                        print(selectedPin)
                        print(p)
                    }
                }
                var images: [UIImage] = []
                for i in customImages {
                    images.append(i.image!)
                }
                homePhotoTableViewController.imageList = images
            default: break
            }
        }
        
    }
    
//    var customPinView: MKPinAnnotationView = MKPinAnnotationView(annotation: MKAnnotation(), reuseIdentifier: "pin")
////    customPinView.pinColor = MKPinAnnotationColorPurple
////    customPinView.animatesDrop = true
//    customPinView.canShowCallout = true
//    calloutAccessoryControlTapped:
//    control
//    var rightButton: UIButton = UIButton(type: UIButtonTypeDetailDisclosure)
//    rightButton.addTarget(self, action: "showDetails:", forControlEvents: UIControlEventTouchUpInside)
//    customPinView.rightCalloutAccessoryView = rightButton
//    return customPinView

    
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
    
    @IBAction func selectButtonPress(sender: AnyObject) {
        
    }
//        let pickerController = DKImagePickerController()
//        //pickerController.sourceType = .Camera
//        
//        pickerController.didCancel = { () in
//            print("didCancel")
//        }
//        
//        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
//            print("didSelectAssets")
//            
//            var viewController = 1
//            //            for pic in assets {
//            //                let imageView = UIImageView(image: pic.fullResolutionImage)
//            //                imageView.frame = CGRect(x: self.x_coor, y: self.y_coor,width: 200,height: 200)
//            //                self.y_coor += 200
//            //                self.view.addSubview(imageView)
//        }
//    
//    
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        doUpload = appDelegate.doUpload
//        if  doUpload {
//            self.presentViewController(pickerController, animated: true) {}
//            appDelegate.doUpload = false
//            print("images")
//            //            print(images)
//        }
//    }
    


}
