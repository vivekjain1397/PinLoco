//
//  Singleton.swift
//  PinLoco
//
//  Created by Nicholas Cai on 11/15/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import Foundation
import Parse
import Bolts
import MapKit

let singletonUpdatedKey = "com.cai.nicholas.singletonUpdatedKey"

private let _sharedInstance = Singleton()
class Singleton {
    private init() {
        
    }
    
    class var sharedInstance: Singleton {
        return _sharedInstance
    }
    
    var selectedPin:MKAnnotation?
    
    var userData: [MKPointAnnotation: [CustomImage]] = [:]
    
//    func updateSingletonData() {
//        let query = PFQuery(className:"Pin")
//        query.whereKey("user", equalTo: PFUser.currentUser()!)
//        query.findObjectsInBackgroundWithBlock {
//            (pins: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("From Singleton.swift: Successfully retrieved \(pins!.count) pins.")
//                // Do something with the found objects
//                
//                for pin in pins! {
//                    //                    let customPin = CustomPointAnnotation()
//                    print("From Singleton.swift: Pin in for loop")
//                    let inner_query = PFQuery(className:"Photo")
//                    inner_query.whereKey("pin", equalTo:pin)
//                    inner_query.findObjectsInBackgroundWithBlock {
//                        (photos: [PFObject]?, error2: NSError?) -> Void in
//                        if error2 == nil {
//                            //The find succeeded.
//                            print("From Singleton.swift: Successfully retrieved \(photos!.count) photos.")
//                            //Do something with the found objects
//                            
//                            var photoList: [CustomImage] = []
//                            for photo in photos! {
//                                let pic = photo["imageFile"] as! PFFile
//                                pic.getDataInBackgroundWithBlock {
//                                    (imageData: NSData?, error: NSError?) -> Void in
//                                    if error == nil {
//                                        if let imageData = imageData {
//                                            let image = UIImage(data:imageData)
//                                            let customImage = CustomImage(rating: 0, image: image)
//                                            photoList.append(customImage!)
//                                            let geoLoc = pin["location"]
//                                            let pin = MKPointAnnotation()
//                                            pin.coordinate = CLLocationCoordinate2D(latitude: geoLoc.latitude, longitude: geoLoc.longitude)
//                                            let firstName = PFUser.currentUser()!["firstName"] as! String
//                                            let lastName = PFUser.currentUser()!["lastName"] as! String
//                                            pin.title = firstName + " " + lastName
//                                            pin.subtitle = String(PFUser.currentUser()!["avgScore"])
//                                            self.userData[pin] = photoList
//                                            print(self.userData[pin]!)
//
//                                        }
//                                    }
//                                }
//                                // Put photos in a list
//                            }
//                            
//                        }
//                    }
//                }
//                print("From Singleton.swift: Update Singleton data complete.")
//                NSNotificationCenter.defaultCenter().postNotificationName(singletonUpdatedKey, object: self)
//                print("From Singleton.swift: Notification sent.")
//                
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//        
//    }
    
    



}
