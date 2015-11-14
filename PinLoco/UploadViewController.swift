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
            print(assets)
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }
    
    override func viewDidDisappear(animated: Bool) {
        
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
