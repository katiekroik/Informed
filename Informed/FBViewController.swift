//
//  FBViewController.swift
//  Informed
//
//  Created by Megha Madan on 4/27/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift

class FBViewController: UIViewController,  FBSDKLoginButtonDelegate {
    
    @IBOutlet var cancelLogout: UIButton!
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    @IBAction func cancelLogoutAction(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("TabViewController")
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelLogout.hidden = true // cancel log out button should not appear on welcome page
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self

        
        if  FBSDKAccessToken.currentAccessToken() != nil {
            cancelLogout.hidden = false // show cancel log out button now that user is active
            fetchProfile()
        }
    }
    
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields": "email,first_name,last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            
            let currentUser = User()
            let realm = try! Realm()
            
            if let facebookId = result["id"] as? String {
                // This should probably be Double but YOLO
                let existing = realm.objects(User).filter("facebookId == %s", facebookId)
                if existing.count != 0 {
                    return
                }
                currentUser.facebookId = facebookId
            }
            
            if let email = result["email"] as? String{
                currentUser.email = email
            }
            
            var nameString = ""
            
            if let first_name = result["first_name"] as? String {
                nameString = first_name
            }
            
            if let last_name = result["last_name"] as? String {
                nameString += " " + last_name
                currentUser.name = nameString
            }
            
            if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String{
                currentUser.picture = url
            }
            
            try! realm.write {
                realm.add(currentUser)
            }
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
        cancelLogout.hidden = true // hide again when returning to log in page
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
