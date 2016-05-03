//
//  SecondViewController.swift
//  Informed
//
//  Created by Megha Madan on 3/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift

// User Data View
class SecondViewController: UIViewController {

    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var userPoints: UILabel!
//    @IBOutlet weak var userLikedArticles: UILabel!
    @IBOutlet weak var userReadNumArticles: UILabel!
    @IBOutlet weak var userPlaceInLeaderboard: UILabel!
    
    @IBOutlet weak var userMostEducatedIn: UILabel!
    @IBOutlet weak var userReadingStreak: UILabel!
    
    @IBOutlet weak var dateLastLoggedIn: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var favArticlesScrollview: UIScrollView!
    
    var currentUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the FB ID and find the user
        let facebookId = FBSDKAccessToken.currentAccessToken().userID
        let potentialUsers = try! Realm().objects(User).filter("facebookId==%s", facebookId)
        if potentialUsers.count > 0 {
            currentUser = potentialUsers[0]
        }
        // Fill in the user info
        welcomeMessage.font = UIFont(name: "AmericanTypeWriter", size: 20)
        welcomeMessage.text = "Welcome, " + currentUser.name + "!"
        userPoints.font = UIFont(name: "AmericanTypeWriter", size: 15)
        userPoints.text = String(currentUser.points)
        userReadNumArticles.font = UIFont(name: "AmericanTypeWriter", size: 15)
        userReadNumArticles.text = String(currentUser.articlesRead.count)
        
        // Sort the users and get what place they're in
        let realm = try! Realm()
        let users = realm.objects(User)
        let sortedUsers = users.sorted("points", ascending: false)
        
        var count = 0;
        
        // Fill in the place
        for u in sortedUsers {
            count += 1;
            if (u.email == currentUser.email) {
                userPlaceInLeaderboard.font = UIFont(name: "AmericanTypeWriter", size: 15)
                userPlaceInLeaderboard.text = String(count);
            }
        }

        // Get the string of when the user last logged in
        let stringDate = String(currentUser.lastLogin)
        // Split the string date
        _ = stringDate.characters.split{$0 == " "}.map(String.init)
        
        // If the URL resolves
        if let url = NSURL(string: currentUser.picture) {
            // Insert that data
            if let data = NSData(contentsOfURL: url) {
                image.image = UIImage(data: data)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func Logout(sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("FBViewController")
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

