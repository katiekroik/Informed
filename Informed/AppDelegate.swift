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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Lets the schema be accepted by Realm
        let config = Realm.Configuration(
            // Sets the new Schema version
            schemaVersion: 1,
            
            // Blocks older versions
            migrationBlock: { migration, oldSchemaVersion in
                // Old schema is less than 1
                if (oldSchemaVersion < 1) {
                    // And do nothing -> Realm will update it :D
                }
            }
        )
        // Set the config
        Realm.Configuration.defaultConfiguration = config

        let realm = try! Realm()

        
        /* Adding articles to the DB */
//        let article1 = Article()
//        article1.articleName = "Article 2";
//        article1.articleText = "YAY WE HAVE A SECOND ARTICLE!!!";
//        try! realm.write {
//            realm.add(article1)
//        }

//        let list = List<Article>()
//        list.append(article1)
//
//        /* ADDS A NEW USER*/
//        let katie = User();
//        katie.name = "Katie"
//        katie.points = 5
//        katie.favoriteArticles = list
        
//        print("katie exists: \(katie.name)")
//
//        let users = realm.objects(User)
//        print(users.count)
//        
//        try! realm.write{
//            realm.add(katie)
//        }
        
        /* ADDS AN ARTICLE */
//        let article = Article()
//        article.articleName = "I love Articles";
//        article.articleText = "That's why we're making this news app called Informed!";
//        
        
        /* Prints the objects */
         print(realm.objects(User))
         print(realm.objects(Article))
//
//         print(users.count)
        
        
        return true
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

