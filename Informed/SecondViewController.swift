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
    
    @IBOutlet weak var favArticlesScrollview: UIScrollView!
    
    var currentUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let facebookId = FBSDKAccessToken.currentAccessToken().userID
        let potentialUsers = try! Realm().objects(User).filter("facebookId==%s", facebookId)
        if potentialUsers.count > 0 {
            currentUser = potentialUsers[0]
        }
        welcomeMessage.text = "Welcome, " + currentUser.name
        userPoints.text = String(currentUser.points)
        userReadNumArticles.text = String(currentUser.articlesRead.count)
        //userPlaceInLeaderboard.text = String(index + 1)
        
        
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

