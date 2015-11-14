//
//  SignupViewController.swift
//  PinLoco
//
//  Created by Naman Priyadarshi on 11/14/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {

    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        firstName.attributedPlaceholder(string: "First Name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
//        lastName.attributedPlaceholder(string: "Last Name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
//        email.attributedPlaceholder(string: "Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
//        pass.attributedPlaceholder(string: "Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
//        confirmPass.attributedPlaceholder(string: "Confirm Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func register() {
        let userFirstName = self.firstName.text
        let userLastName = self.lastName.text
        let email = self.email.text
        let password = self.pass.text
        let confirm_pass = self.confirmPass.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Validate the text fields
        if userFirstName!.characters.count == 0 {
            let alertController = UIAlertController(title: "Sign Up Error", message: "Please enter your first name.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else if userLastName!.characters.count == 0 {
            let alertController = UIAlertController(title: "Sign Up Error", message: "Please enter your last name.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else if email!.characters.count < 8 {
            //Alert: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            let alertController = UIAlertController(title: "Sign Up Error", message: "Please enter a valid email address", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else if password!.characters.count < 8 {
            //Alert: "Password must be greater than 8 characters"
            let alertController = UIAlertController(title: "Sign Up Error", message: "Password must be greater than 8 characters", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else if password! != confirm_pass! {
            //Alert: "Password Confirmation does not match Password"
            let alertController = UIAlertController(title: "Sign Up Error", message: "Password Confirmation does not match Password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
            
            //add check for existing account
            
            
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            
            newUser.username = email
            newUser["firstName"] = userFirstName
            newUser["lastName"] = userLastName
            newUser.password = password
            newUser.email = finalEmail
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                } else {
                    let alertController = UIAlertController(title: "Success", message: "Signed Up, Please check email to confirm account", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        PFUser.logOut()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                            self.presentViewController(viewController, animated: true, completion: nil)
                        })
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
            })
        }
    }
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
