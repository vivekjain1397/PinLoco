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
    var locationmanager=CLLocationManager()
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.doUpload = true
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
