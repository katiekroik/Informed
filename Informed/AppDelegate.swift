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
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //determine if session is active first
        if(FBSDKAccessToken.currentAccessToken() != nil){
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("TabViewController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        // if no session is active, prompt user to login through facebook
        else{
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("FBViewController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
        }

        
        
        // Lets the schema be accepted by Realm
        let config = Realm.Configuration(
            // Sets the new Schema version
            schemaVersion: 2,
            
            // Blocks older versions
            migrationBlock: { migration, oldSchemaVersion in
                // Old schema is less than 1
                if (oldSchemaVersion < 2) {
                    // And do nothing -> Realm will update it :D
                }
            }
        )
        // Set the config
        Realm.Configuration.defaultConfiguration = config

        let realm = try! Realm()
        
//        let articles = realm.objects(Article)
//        
//        var list = List<Article>()
//        list.append(articles[2])
//        
//        let katie = User();
//        katie.name = "Katie"
//        katie.points = 5
//        katie.id = 1
////        katie.favoriteArticles = list
//        
//        try! realm.write {
//            realm.add(katie, update: true)
//        }
        
//        let articles = realm.objects(Article)
//        let g = Genre()
//        g.name = "World News"
//        
//        let article = Article()
//        article.genre = realm.objects(Genre)[0]
//        article.name = "Really Long Article"
//        article.content = "Lorem ipsum dolor sit amet, in per aeterno suscipiantur, te nibh aperiam sit. Id albucius referrentur sea, an vis eirmod similique. Eos no oratio virtute, vel errem liberavisse cu. Verear albucius ex sed, erant dissentias in qui, in simul epicuri pri. Vis viderer feugiat appetere id, ipsum vidisse tritani ius ex. Rebum equidem et his, sed eius debet maiestatis te. An qui ludus facete iisque. Iriure corpora ut sed, inani error facilis mei ad. In maiorum oportere nec. Eos fierent accusamus consequuntur cu, reque eripuit menandri has eu. Vim consul aliquip suscipiantur id, mei vidisse ullamcorper ne. Eos nobis facilis prodesset et. Est in offendit percipit, te nec tibique theophrastus. In alienum recusabo vituperata vel, nec te ullum accommodare. In admodum luptatum eam, dicant aeterno maiestatis qui et, cu mel decore volumus argumentum. Duo dicta inermis ad, eum tale offendit no. Ne cetero detraxit nominati vim. Est oratio minimum at. Ex tempor putant pri, no elit oporteat sadipscing ius. Ornatus ceteros offendit mea no, eos et ancillae voluptua mandamus. Zril nonumy ad vix, prompta iuvaret mea te. Omnesque salutatus repudiandae nec ea, et usu vidit tollit reformidans. Est harum ridens maiorum an, ut cum omittam elaboraret. An natum dicta duo, labitur fabulas vis cu. Lorem ipsum dolor sit amet, in per aeterno suscipiantur, te nibh aperiam sit. Id albucius referrentur sea, an vis eirmod similique. Eos no oratio virtute, vel errem liberavisse cu. Verear albucius ex sed, erant dissentias in qui, in simul epicuri pri. Vis viderer feugiat appetere id, ipsum vidisse tritani ius ex. Rebum equidem et his, sed eius debet maiestatis te. An qui ludus facete iisque. Iriure corpora ut sed, inani error facilis mei ad. In maiorum oportere nec. Eos fierent accusamus consequuntur cu, reque eripuit menandri has eu. Vim consul aliquip suscipiantur id, mei vidisse ullamcorper ne. Eos nobis facilis prodesset et. Est in offendit percipit, te nec tibique theophrastus. In alienum recusabo vituperata vel, nec te ullum accommodare. In admodum luptatum eam, dicant aeterno maiestatis qui et, cu mel decore volumus argumentum. Duo dicta inermis ad, eum tale offendit no. Ne cetero detraxit nominati vim. Est oratio minimum at. Ex tempor putant pri, no elit oporteat sadipscing ius. Ornatus ceteros offendit mea no, eos et ancillae voluptua mandamus. Zril nonumy ad vix, prompta iuvaret mea te. Omnesque salutatus repudiandae nec ea, et usu vidit tollit reformidans. Est harum ridens maiorum an, ut cum omittam elaboraret. An natum dicta duo, labitur fabulas vis cu. Lorem ipsum dolor sit amet, in per aeterno suscipiantur, te nibh aperiam sit. Id albucius referrentur sea, an vis eirmod similique. Eos no oratio virtute, vel errem liberavisse cu. Verear albucius ex sed, erant dissentias in qui, in simul epicuri pri. Vis viderer feugiat appetere id, ipsum vidisse tritani ius ex. Rebum equidem et his, sed eius debet maiestatis te. An qui ludus facete iisque. Iriure corpora ut sed, inani error facilis mei ad. In maiorum oportere nec. Eos fierent accusamus consequuntur cu, reque eripuit menandri has eu. Vim consul aliquip suscipiantur id, mei vidisse ullamcorper ne. Eos nobis facilis prodesset et. Est in offendit percipit, te nec tibique theophrastus. In alienum recusabo vituperata vel, nec te ullum accommodare. In admodum luptatum eam, dicant aeterno maiestatis qui et, cu mel decore volumus argumentum. Duo dicta inermis ad, eum tale offendit no. Ne cetero detraxit nominati vim. Est oratio minimum at. Ex tempor putant pri, no elit oporteat sadipscing ius. Ornatus ceteros offendit mea no, eos et ancillae voluptua mandamus. Zril nonumy ad vix, prompta iuvaret mea te. Omnesque salutatus repudiandae nec ea, et usu vidit tollit reformidans. Est harum ridens maiorum an, ut cum omittam elaboraret. An natum dicta duo, labitur fabulas vis cu."
//        
//        try! realm.write {
////            realm.add(g);
//            realm.add(article)
//            
//        }
        
        
//        let sortedUsers = users.sorted("points", ascending: false)
        

        
        /* Adding articles to the DB */
//        let article1 = Article()
//        article1.articleName = "Lorem Ipsum";
//        article1.articleText = "Lorem ipsum dolor sit amet, in per aeterno suscipiantur, te nibh aperiam sit. Id albucius referrentur sea, an vis eirmod similique. Eos no oratio virtute, vel errem liberavisse cu. Verear albucius ex sed, erant dissentias in qui, in simul epicuri pri. Vis viderer feugiat appetere id, ipsum vidisse tritani ius ex. Rebum equidem et his, sed eius debet maiestatis te. An qui ludus facete iisque. Iriure corpora ut sed, inani error facilis mei ad. In maiorum oportere nec. Eos fierent accusamus consequuntur cu, reque eripuit menandri has eu. Vim consul aliquip suscipiantur id, mei vidisse ullamcorper ne. Eos nobis facilis prodesset et. Est in offendit percipit, te nec tibique theophrastus. In alienum recusabo vituperata vel, nec te ullum accommodare. In admodum luptatum eam, dicant aeterno maiestatis qui et, cu mel decore volumus argumentum. Duo dicta inermis ad, eum tale offendit no. Ne cetero detraxit nominati vim. Est oratio minimum at. Ex tempor putant pri, no elit oporteat sadipscing ius. Ornatus ceteros offendit mea no, eos et ancillae voluptua mandamus. Zril nonumy ad vix, prompta iuvaret mea te. Omnesque salutatus repudiandae nec ea, et usu vidit tollit reformidans. Est harum ridens maiorum an, ut cum omittam elaboraret. An natum dicta duo, labitur fabulas vis cu.";
//        try! realm.write {
//            realm.add(article1)
//        }
//
//        let list = List<Article>()
//        list.append(article1)
//
//        /* ADDS A NEW USER*/
//        let katie = User();
//        katie.name = "Katie"
//        katie.points = 5
//        katie.favoriteArticles = list
//        
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

