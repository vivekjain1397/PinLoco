//
//  SignUpViewController.swift
//  PinLoco
//
//  Created by Naman Priyadarshi on 11/14/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import UIKit
import Parse
import MapKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPass: UITextField!
    
    let singleton = Singleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func checkLogin() {
        let email = loginEmail.text!
        let password = loginPass.text!
        
        if email == ""  {
            let alertController = UIAlertController(title: "Login Error", message: "Please enter email", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        else if password == "" {
            let alertController = UIAlertController(title: "Login Error", message: "Please enter password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
            
        }
            //check case that the email has not been verified.
        else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            // Send a request to login
            PFUser.logInWithUsernameInBackground(email, password: password, block: { (user, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((user) != nil) {
                    let alertController = UIAlertController(title: "Success", message: "Logged In", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                            self.presentViewController(viewController, animated: true, completion: nil)
                        })
                    }
                    
//                    self.singleton.updateSingletonData()
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Wrong Email/Password Combination", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "Dismiss", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
            })
        }
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
