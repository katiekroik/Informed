//
//  FBViewController.swift
//  Informed
//
//  Created by Megha Madan on 4/27/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit

class FBViewController: UIViewController,  FBSDKLoginButtonDelegate {
    
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        
        
        if  FBSDKAccessToken.currentAccessToken() != nil {
            fetchProfile()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func fetchProfile(){
        print("fetch profile")
        
        let parameters = ["fields": "email,first_name,last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            
//            
//            if let email = result["email"] as? String{
//                print(email)
//            }
//            
//            if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String{
//                print(url)
//            }
            
            // prints out all fields (email, first name, last name, and picture url)
            print(result)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("completed login")
        fetchProfile()
        
        // after log in, send to main page
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("TabViewController")
        print(nextViewController)
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
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
