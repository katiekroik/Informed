//
//  AppDelegate.swift
//  Informed
//
//  Created by Megha Madan on 3/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentUser: User!
    var realm: Realm!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Lets the schema be accepted by Realm
        let config = Realm.Configuration(
            // Sets the new Schema version
            schemaVersion: 3,
            
            // Blocks older versions
            migrationBlock: { migration, oldSchemaVersion in
                // Old schema is less than 1
                if (oldSchemaVersion < 3) {
                    // And do nothing -> Realm will update it :D
                }
            }
        )
        // Set the config
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.path!)
        
//        let genre = realm!.objects(Genre)[0]
//        
//        let article1 = Article()
//        article1.genre = genre
//        article1.name = "Obama Takes Aim At Trump"
//        article1.publisher = "The Guardian"
//        article1.linkTo = "http://www.theguardian.com/us-news/2016/may/01/obama-takes-aim-at-trump-and-republicans-at-final-correspondents-dinner"
//        article1.publishId = "5533982"
//        article1.datePublished = NSDate()
//        
//        try! realm!.write {
//            realm!.add(article1)
//        }
//
        
        let users = realm!.objects(User)
        if users.count == 0 {
            populateUsers()
        }
//        populateUsers()
        
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //determine if session is active first
        if(FBSDKAccessToken.currentAccessToken() != nil){
            // This may be unnecessary. Potentially inverse the if statement?
            let facebookId = FBSDKAccessToken.currentAccessToken().userID
            let potentialUsers = realm!.objects(User).filter("facebookId==%s", facebookId)
            if potentialUsers.count > 0 {
                currentUser = potentialUsers.first
            }
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("TabViewController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        } else {
            // if no session is active, prompt user to login through facebook
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("FBViewController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    // Function populates Realm DB on phone with dummy values for testing purposes.
    // Yes, I've been watching too much Parks & Rec.
    func populateUsers() {
        
        // Add the Genres
        let politics = Genre()
        politics.name = "Politics"
        let sports = Genre()
        sports.name = "Sports"
        let entertainment = Genre()
        entertainment.name = "Entertainment"
        let technology = Genre()
        technology.name = "Technology"
        
        let calendar = NSCalendar.currentCalendar()
        let twoDaysAgo = calendar.dateByAddingUnit(.Day, value: -2, toDate: NSDate(), options: [])
        let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
        let lastYear = calendar.dateByAddingUnit(.Year, value: -1, toDate: NSDate(), options: [])
        
        let article1 = Article()
        article1.genre = politics
        article1.name = "Knope Wins on Recount"
        article1.publisher = "Pawnee Sun"
        article1.linkTo = "http://international.sueddeutsche.de/post/143690739565/ttippapiere"
        article1.publishId = "8675309"
        article1.datePublished = NSDate()
        
        let article2 = Article()
        article2.genre = sports
        article2.name = "Cone of Dunshire goes Viral!"
        article2.datePublished = NSDate()
        article2.linkTo = "https://peter.bourgon.org/go-best-practices-2016/"
        article2.publisher = "New York Times"
        article2.publishId = "xYzLmnOp"
        
        let leslie = User()
        leslie.name = "Leslie Knope"
        leslie.facebookId = "1337"
        leslie.articlesRead.append(article1)
        leslie.articlesRead.append(article2)
        leslie.favoriteArticles.append(article1)
        leslie.email = "knope@indiana.gov"
        leslie.picture = "http://media.salon.com/2012/11/knope_campaign_rect.jpg"
        leslie.points = 40000
        leslie.startOfStreak = twoDaysAgo!
        leslie.lastLogin = yesterday!
        
        let ron = User()
        ron.name = "Ron Swanson"
        ron.facebookId = "42"
        ron.email = "dukeSilver@aol.com"
        ron.picture = "http://i.huffpost.com/gen/1264888/thumbs/o-RON-SWANSON-570.jpg?6"
        ron.points = 100
        ron.startOfStreak = lastYear!
        ron.lastLogin = lastYear!
        
        let april = User()
        april.name = "April Ludgate"
        april.facebookId = "93861"
        april.email = "death@gmail.com"
        april.picture = "https://img.buzzfeed.com/buzzfeed-static/static/2015-01/7/11/campaign_images/webdr10/if-april-ludgate-had-instagram-2-24018-1420646599-0_dblbig.jpg"
        april.points = 500
        april.articlesRead.append(article2)
        april.startOfStreak = twoDaysAgo!
        april.lastLogin = twoDaysAgo!
        
        let andy = User()
        andy.name = "Andy Dwyer"
        andy.facebookId = "12346789"
        andy.email = "mouserat@hotmail.com"
        andy.picture = "https://img.buzzfeed.com/buzzfeed-static/static/2014-08/5/10/campaign_images/webdr10/10-reasons-andy-dwyer-from-parks-and-recreation-s-2-26656-1407248996-0_dblbig.jpg"
        andy.points = 720
        andy.articlesRead.append(article1)
        andy.articlesRead.append(article2)
        andy.favoriteArticles.append(article1)
        andy.startOfStreak = lastYear!
        andy.lastLogin = yesterday!
        
        try! realm.write {
            realm.add(politics)
            realm.add(sports)
            realm.add(entertainment)
            realm.add(technology)
            
            realm.add(article1)
            realm.add(article2)
            
            realm.add(leslie)
            realm.add(ron)
            realm.add(april)
            realm.add(andy)
        }
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

