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
    var numberOfTimesLoaded = 0
    
    @IBOutlet weak var pinDetailPeekView: UIView!
//    @IBOutlet weak var pinImageTest: UIImageView!
    @IBOutlet weak var userPeekView: UIView!
    
    @IBAction func refreshButton(sender: AnyObject) {
        refreshNewPins(self.mapView.visibleMapRect)
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
    
    func refreshNewPins(visibleMapRectangle: MKMapRect) {

        print("\nRequesting pins from model")
        var newPinsAdded = 0
        let query = PFQuery(className: "Pin")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (pins: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Find succeeded
                // print("Successfully retrieved \(pins!.count) pins")
                if let pins = pins {
                    for p in pins {
                        let pinID = p.objectId!
                        if !(self.storedPinIDs.contains(pinID)) {
                            
                            // create the map annotation object
                            let pin = MKPointAnnotation()
                            pin.title = pinID
                            
                            // add to the map
                            if let location = p["location"] {
                                pin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                                if MKMapRectContainsPoint(visibleMapRectangle, MKMapPointForCoordinate(pin.coordinate)) {
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
                    } else if newPinsAdded == 1 {
                        print("Success! Added 1 pin\n")
                    } else {
                        print("Success! Added \(newPinsAdded) pins\n")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let insets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
//        imageScrollView.contentInset = insets
//        imageScrollView.scrollIndicatorInsets = insets
//        imageScrollView.showsHorizontalScrollIndicator = false
//        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        pinDetailPeekView.layer.shadowColor = UIColor.blackColor().CGColor
        pinDetailPeekView.layer.shadowOffset = CGSizeZero
        pinDetailPeekView.layer.shadowRadius = 1.0
        pinDetailPeekView.layer.shadowOpacity = 0.3
        
        userPeekView.layer.shadowColor = UIColor.blackColor().CGColor
        userPeekView.layer.shadowOffset = CGSizeZero
        userPeekView.layer.shadowRadius = 1.0
        userPeekView.layer.shadowOpacity = 0.3
        
        self.mapView.rotateEnabled = false
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        // remove stackview 
        for view in self.imageStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        if let pin = view.annotation {
            if let title = pin.title {
                print("pin with id \"\(title!)\" pressed")
                let pinQuery = PFQuery(className: "Pin")
                pinQuery.whereKey("objectId", equalTo: title!)
                pinQuery.findObjectsInBackgroundWithBlock {
                    (pin: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        if let pin = pin {
                            for p in pin {
                                let imageQuery = PFQuery(className: "Photo")
                                imageQuery.whereKey("pin", equalTo: p)
                                imageQuery.findObjectsInBackgroundWithBlock {
                                    (images: [PFObject]?, error2: NSError?) -> Void in
                                    
                                    if error2 == nil {
                                        if let images = images {
                                            for i in images {
                                                let pic = i["imageFile"] as! PFFile
                                                pic.getDataInBackgroundWithBlock {
                                                    (imageData: NSData?, error: NSError?) -> Void in
                                                    if error == nil {
                                                        if let imageData = imageData {
                                                            let image = UIImage(data: imageData)
                                                            self.appendImageViewToStack(image)
                                                            //                                                        self.pinImageTest.image = image
                                                            //                                                        image?.size.
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func appendImageViewToStack(image: UIImage?) {
        print("Appending image")
        
        let stack = imageStackView
        let newImageView = createViewEmbeddedWithImage(image)
        
        newImageView.hidden = true
        
//        let anotherview = createViewEmbeddedWithImage(image)
//        anotherview.hidden = true
        stack.addArrangedSubview(newImageView)
//        stack.addArrangedSubview(anotherview)
        
        UIView.animateWithDuration(0.2, animations: {
            newImageView.hidden = false
//            anotherview.hidden = false
        })
    }
    
    private func createViewEmbeddedWithImage(image: UIImage?) -> UIView {
        let height = imageStackView.frame.height
        let sizeMultiplier: CGFloat = (image?.size.height)! / height
        let width = (image?.size.width)! / sizeMultiplier
        
        let imageViewFrame = CGRectMake(0, 0, width, height)
//        let view = UIView(frame: viewFrame)
        
        let imageView = UIImageView(image: image)
//        imageView.backgroundColor = UIColor.blackColor()
        imageView.bounds = imageViewFrame
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        print(imageView.frame.width)
        print(image?.size.width)
        print(imageView.frame.height)
        print(image?.size.height)
        print(imageStackView.frame.height)
        print(imageStackView.frame.width)
        
        let constraintImageViewWidth = NSLayoutConstraint (item: imageView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: width)
        imageView.addConstraint(constraintImageViewWidth)
        
        return imageView
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
            var finalBottomFrame = self.pinDetailPeekView.frame
            finalBottomFrame.origin.y += finalBottomFrame.size.height
            
            var finalTopFrame = self.userPeekView.frame
            finalTopFrame.origin.y -= finalTopFrame.size.height + (self.userPeekView.center.y - self.userPeekView.frame.height / 2)
            
            self.pinDetailPeekView.frame = finalBottomFrame
            self.userPeekView.frame = finalTopFrame
            }, completion: { finished in
                // print("Map region changing")
            })
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseOut, animations: {
            var finalBottomFrame = self.pinDetailPeekView.frame
            finalBottomFrame.origin.y -= finalBottomFrame.size.height
            
            var finalTopFrame = self.userPeekView.frame
            finalTopFrame.origin.y += finalTopFrame.size.height - self.userPeekView.center.y
            
            self.pinDetailPeekView.frame = finalBottomFrame
            self.userPeekView.frame = finalTopFrame
            }, completion: { finished in
            // print("Map region finished changing")
        })
        
        if numberOfTimesLoaded > 1 {
            refreshNewPins(self.mapView.visibleMapRect)
        }
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        // called when the map has found the user's location
        let currentLat = self.locationManager.location?.coordinate.latitude
        let currentLong = self.locationManager.location?.coordinate.longitude
        let center = CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        // manually generates an MKMapRect based on user's current location regardless of current map view zoom
        let rect = MKMapRectForCoordinateRegion(region)
        self.numberOfTimesLoaded++
        
        if numberOfTimesLoaded == 1 {
            // allows automatic refresh only one time
            refreshNewPins(rect)
        }
        self.numberOfTimesLoaded++
    }
    
    // returns an MKMapRect when passed in a MKCoordinateRegion
    func MKMapRectForCoordinateRegion(region: MKCoordinateRegion) -> MKMapRect {
        let a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta / 2, region.center.longitude - region.span.longitudeDelta / 2))
        let b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta / 2, region.center.longitude + region.span.longitudeDelta / 2))
        return MKMapRectMake(fmin(a.x, b.x), fmin(a.y, b.y), fabs(a.x - b.x), fabs(a.y - b.y))
    }
    
    // Sets up the annotation pins
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = String(stringInterpolationSegment: annotation.coordinate.longitude)
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let pinImage = UIImage(named:"map_pin.png")
            pinView?.image = pinImage
            pinView?.centerOffset = CGPointMake(0, -(pinImage!.size.height/2))
            
            // set to false to disable callout bubble
            pinView?.canShowCallout = true
        }
        
//        let button = UIButton(type: UIButtonType.DetailDisclosure)
//        button.addTarget(self, action: "pin_press:", forControlEvents: .TouchUpInside)
//        pinView?.rightCalloutAccessoryView = button
        
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
//        print(images)
//        print("L:LSDKJ")
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
