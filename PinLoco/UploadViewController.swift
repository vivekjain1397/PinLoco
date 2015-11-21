//
//  UploadViewController.swift
//  PinLoco
//
//  Created by Nicholas Cai on 11/14/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import UIKit
import DKImagePickerController
import Parse

class UploadViewController: UIViewController {
    var doUpload = true
    var images = [DKAsset]()
    var x_coor = 0
    var y_coor = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
   
    
    override func viewDidAppear(animated: Bool) {
        let pickerController = DKImagePickerController()
        //pickerController.sourceType = .Camera
        
        pickerController.didCancel = { () in
            print("didCancel")
        }
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            for pic in assets {
                let imageView = UIImageView(image: pic.fullResolutionImage)
                imageView.frame = CGRect(x: self.x_coor, y: self.y_coor,width: 200,height: 200)
                self.y_coor += 200
                self.view.addSubview(imageView)
            }
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let doUpload = appDelegate.doUpload
        if  doUpload {
            self.presentViewController(pickerController, animated: true) {}
            appDelegate.doUpload = false
            print("images")
            print(images)
        }
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
