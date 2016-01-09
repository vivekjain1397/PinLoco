//
//  ProfileViewController.swift
//  PinLoco
//
//  Created by Nicholas Cai on 11/14/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import UIKit
import Parse
import MapKit

class ProfileViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var profPic: UIImageView!
    let singleton = Singleton.sharedInstance
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var selectPhotoButton: UIButton!
    var locationManager=CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func logOutButton(sender: AnyObject) {
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = String(PFUser.currentUser()!["firstName"])
//        lastNameLabel.text = String(PFUser.currentUser()!["lastName"])
//        scoreLabel.text = "Score: "+String(PFUser.currentUser()!["avgScore"])
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
//        self.singleton.updateSingletonData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadAnnotations", name: singletonUpdatedKey, object: nil)
        //        loadAnnotations()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.doUpload = true
        loadAnnotations()
    }

    func loadAnnotations() {
        print("Hello")
        for (p, _) in singleton.userData {
            //            var annotationView: MKPinAnnotationView!
            self.mapView.addAnnotation(p)
//            print(p.coordinate)
        }
    }
    
    func addAnnotation() {
        let lat = 37.3175
        let long = -122.0419
        
        
        let myAnnotation = MKPointAnnotation()
        
        myAnnotation.title = "Hello"
        myAnnotation.subtitle = "Nick"
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        self.mapView.addAnnotation(myAnnotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
