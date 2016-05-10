//
//  IndividualArticleViewController.swift
//  Informed
//
//  Created by Katie Kroik on 3/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift
import WebKit

class IndividualArticleViewController: UIViewController, UITextViewDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    var aUrl: String!
    var article: Article!
    var currentUser: User!
    var realm = try! Realm()
    var webView: WKWebView!
    
    var alreadyPassedThreshold = false

    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
//        webView.scrollView.delegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL (string: aUrl);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        
        
        var contains = false;
        
        if currentUser == nil {
            let facebookId = FBSDKAccessToken.currentAccessToken().userID
            let potentialUsers = realm.objects(User).filter("facebookId == %s", facebookId)
            if potentialUsers.count == 0 {
                navigationController?.popToRootViewControllerAnimated(true)
                
            }
            currentUser = potentialUsers.first
        }
        
        // Keep track of the genre and publishers of the article read
        var numReadOfGenre = [String: Int]()
        var numReadOfSource = [String: Int]()
        
        for a in currentUser.articlesRead {
            // If it's a new genre, add it
            if numReadOfGenre[a.genre.name] == nil {
                numReadOfGenre[a.genre.name] = 1
            } else {
                numReadOfGenre[a.genre.name] = numReadOfGenre[a.genre.name]! + 1
            }
            // If it's a new source, add it
            if numReadOfSource[a.publisher] == nil {
                numReadOfSource[a.publisher] = 1
            } else {
                numReadOfSource[a.publisher] = numReadOfSource[a.publisher]! + 1
            }
            
            if (a.linkTo == aUrl) {
                contains = true;
            }
        }
        
        // Create a multiplier based on how many articles you've read from that publisher
        var mult = max(0.6, 1.2 - Double(numReadOfSource[article.publisher]!))
        
        // If the user hasn't read the article
        if (contains == false) {
            // Get the new val
            let val = currentUser.points + Int(max(15, mult * Double(50 - (2 * numReadOfGenre[article.genre.name]!))))
            print(val)
            // Add to the user read article database
            try! realm.write {
                currentUser.articlesRead.append(article)
                currentUser.points = val
            }
        }
        else {
            print("Re-reading an article -> no points...")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //        articleName.text = aName;
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            
            let currentIndex = floor(scrollView.contentOffset.x / scrollView.bounds.size.width);
            let offset = CGPointMake(scrollView.bounds.size.width * currentIndex, 0)
            scrollView.setContentOffset(offset, animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var contains = false
        if (!alreadyPassedThreshold) {
            var numReadOfGenre = [String: Int]()
            var numReadOfSource = [String: Int]()
            
            for a in currentUser.articlesRead {
                // If it's a new genre, add it
                if numReadOfGenre[a.genre.name] == nil {
                    numReadOfGenre[a.genre.name] = 1
                } else {
                    numReadOfGenre[a.genre.name] = numReadOfGenre[a.genre.name]! + 1
                }
                // If it's a new source, add it
                if numReadOfSource[a.publisher] == nil {
                    numReadOfSource[a.publisher] = 1
                } else {
                    numReadOfSource[a.publisher] = numReadOfSource[a.publisher]! + 1
                }
                
                if (a.linkTo == aUrl) {
                    contains = true;
                }
            }
            
            // Create a multiplier based on how many articles you've read from that publisher
            var mult = max(0.6, 1.2 - Double(numReadOfSource[article.publisher]!))
            
            // If the user hasn't read the article
            if (contains == false) {
                // Get the new val
                let val = currentUser.points + Int(max(15, mult * Double(50 - (2 * numReadOfGenre[article.genre.name]!))))
                print(val)
                // Add to the user read article database
                try! realm.write {
                    currentUser.articlesRead.append(article)
                    currentUser.points = val
                }
            }
            else {
                print("Re-reading an article -> no points...")
            }
            print(currentUser)
            alreadyPassedThreshold = true
        }
//        print (scrollView.contentSize.height - scrollView.frame.size.height)
//        print( scrollView.contentOffset.y )
//        if (scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height) / 2)) {
//            // reached the bottom
//            print ("BOTTOM!!")
//            
//            var contains = false;
//            
//            var numReadOfGenre = [String: Int]()
//            numReadOfGenre["Politics"] = 0
//            numReadOfGenre["Sports"] = 0
//            numReadOfGenre["Entertainment"] = 0
//            numReadOfGenre["Tech"] = 0
//            // 0 = Politics, 1 = Sports, 2 = Entertainment, 3 = Tech
//            
//            if currentUser == nil {
//                let facebookId = FBSDKAccessToken.currentAccessToken().userID
//                let potentialUsers = realm.objects(User).filter("facebookId == %s", facebookId)
//                if potentialUsers.count == 0 {
//                    navigationController?.popToRootViewControllerAnimated(true)
//                    
//                }
//                currentUser = potentialUsers.first
//            }
//            
//            for a in currentUser.articlesRead {
//                //                numReadOfGenre["Politics"]
//                print (numReadOfGenre["Politics"])
//                if (a.linkTo == aUrl) {
//                    contains = true;
//                }
//            }
//            
//            if (contains == false) {
//                let val = currentUser.points + 25
//                // Add to the user read article database
//                try! realm.write {
//                    currentUser.articlesRead.append(article)
//                    currentUser.points = val
//                }
//            }
//            else {
//                print("Re-reading an article -> no points...")
//            }
//            
//            print(currentUser)
//        }
    }
    
    func options() {
        let ac = UIAlertController(title: "Options", message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "Add to Favorites", style: .Default, handler: favorite))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func favorite(action: UIAlertAction!) {
        try! realm.write {
            currentUser.favoriteArticles.append(article)
        }
    }
    
    func scrollToBotom() {
        //        let range = NSMakeRange(articleContents.text.characters.count - 1, 1);
        //        articleContents.scrollRangeToVisible(range);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    Check how fast the scrolling is
    */
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}