//
//  ImageTableViewController.swift
//  PinLoco
//
//  Created by Nicholas Cai on 11/14/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import UIKit
import DKImagePickerController
import Parse

class ImageTableViewController: UITableViewController {
    
    
    @IBOutlet weak var tabBar: UIToolbar!
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        print("Hello")
//        tabBar.backgroundColor = UIColor.whiteColor()
        imageSelectorFunction()
    }
    
    var imageList: [DKAsset] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        imageSelectorFunction()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func assetCheckHelper(pic: DKAsset?) -> Bool {
        for i in imageList {
            if pic!.isEqual(i) {
               
                return false // found lol
            }
        }
        return true // Not found in original
    }
    
    func imageSelectorFunction() {
        let pickerController = DKImagePickerController()
        //pickerController.sourceType = .Camera
        
        pickerController.didCancel = { () in
            print("didCancel")
        }
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            for pic in assets {
                print("Why")
                if self.assetCheckHelper(pic) {
                    print("Called")
                    let newPic = [pic]
                    self.imageList = self.imageList + newPic
                }

            }
//            self.imageList = self.imageList + assets
            //            for pic in assets {
            //                let imageView = UIImageView(image: pic.fullResolutionImage)
            //                imageView.frame = CGRect(x: self.x_coor, y: self.y_coor,width: 200,height: 200)
            //                self.y_coor += 200
            //                self.view.addSubview(imageView)
            //            }
        }
        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let doUpload = appDelegate.doUpload
        if  true {
            self.presentViewController(pickerController, animated: true) {}
//            appDelegate.doUpload = false
            print("images")
            //            print(images)
        }
    }

    @IBAction func uploadImages(sender: AnyObject) {
        print("From ImageTableViewController: Upload Images button pressed")
        print("HEllo")
        if sender.titleLabel!.text == "Upload" {
//            print("12323454")
            var visibility = "Not Set"
            //Create Alert to get privacy setting
            let alertController = UIAlertController(title: "Privacy?", message: "Please select visibility of photos", preferredStyle: .Alert)
            let priAction = UIAlertAction(title: "Private", style: .Default) { (action) in
                visibility = "private"
            }
            alertController.addAction(priAction)
            let pubAction = UIAlertAction(title: "Public", style: .Default) { (action) in
                visibility = "private"
            }
            alertController.addAction(pubAction)
            self.presentViewController(alertController, animated: true) {
            }
//            print("1")
                //Create Pin
                let pin = PFObject(className:"Pin")
                pin["user"] = PFUser.currentUser()
                PFGeoPoint.geoPointForCurrentLocationInBackground {
                    (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                    if error == nil {
                        pin["location"] = geoPoint
                    }
                }
//            print("2")
                pin["score"] = 0
//            print("2a")
                pin["photos"] = [1, 2, 3]
//                    self.imageList
//            print("2ab")
                pin["pinColor"] = "blue"
                pin["setting"] = visibility
//            print("2b")
                pin.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                }
//            print("3")
                //Create Photo for each photo
                for pic in self.imageList {
                    let photo = PFObject(className:"Photo")
                    photo["score"] = 0
                    photo["pin"] = pin
                    //access the textboxes
                    photo["locName"] = "Placeholder"
//                    print("3.1")
                    let imageData = UIImagePNGRepresentation(pic.fullResolutionImage!)
                    let imageFile = PFFile(name:"image.png", data:imageData!)
                    photo["imageFile"] = imageFile
//                    print("3.2")
                    photo.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            // There was a problem, check error.description
                        }
                    }
                }
//            print("4")
            
            
        }
        
        
    }
    
    @IBAction func uploadPhotos(sender: UIButton) {

        if sender.titleLabel!.text == "Upload" {
            var visibility = "Not Set"
            //Create Alert to get privacy setting
            let alertController = UIAlertController(title: "Privacy?", message: "Please select visibility of photos", preferredStyle: .Alert)
            let priAction = UIAlertAction(title: "Private", style: .Default) { (action) in
                visibility = "private"
            }
            alertController.addAction(priAction)
            let pubAction = UIAlertAction(title: "Public", style: .Default) { (action) in
                visibility = "private"
            }
            alertController.addAction(pubAction)
            self.presentViewController(alertController, animated: true) {
                //Create Pin
                let pin = PFObject(className:"Pin")
                pin["user"] = PFUser.currentUser()
                PFGeoPoint.geoPointForCurrentLocationInBackground {
                    (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                    if error == nil {
                        pin["location"] = geoPoint
                    }
                }
                pin["score"] = 0
                pin["photos"] = self.imageList
                pin["pinColor"] = "blue"
                pin["setting"] = visibility
                pin.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                }
                //Create Photo for each photo
                for pic in self.imageList {
                    let photo = PFObject(className:"Photo")
                    photo["score"] = 0
                    photo["pin"] = pin
                    //access the textboxes
                    photo["locName"] = "Placeholder"
                    photo["imageFile"] = pic.fullResolutionImage
                    photo.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                        } else {
                            // There was a problem, check error.description
                        }
                    }
                }
                
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ImageCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
        
        // Configure the cell...
        let imageItem = imageList[indexPath.row]
        
//        cell.itemTitle.text = imageItem.name
        cell.cellImage.image = imageItem.fullResolutionImage
//        cell.itemDescription.text = item.description
        
        return cell
    }
    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
