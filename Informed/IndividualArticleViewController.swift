//
//  IndividualArticleViewController.swift
//  Informed
//
//  Created by Katie Kroik on 3/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift

class IndividualArticleViewController: UIViewController, UITextViewDelegate {
    

    // Name of article
//    @IBOutlet weak var articleName: UILabel!
//    // Article contents
//    @IBOutlet weak var articleContents: UITextView!

    @IBOutlet weak var webView: UIWebView!
    
    var name = String()
    var contents = String()
    var aName = String()
    var aUrl = String()
    var article = Article()
    
    var currentUser = User()
    override func viewDidLoad() {
        super.viewDidLoad()
//        articleContents.delegate = self;
//
//
//        articleContents.decelerationRate = UIScrollViewDecelerationRateFast;
//        articleContents.userInteractionEnabled = true;
//        articleContents.scrollEnabled = true;
//
//        print(articleName.text)
//        
//        articleName.text = aName
//        articleContents.text = contents
//
//        let frame = self.view.frame;
        let url = NSURL (string: aUrl);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);

        
        var contains = false;
        // TODO : ACTUALLY GET THE USER THATS LOGGED IN RIGHT NOW - HOW DO I DO THAT
        //            var user = users[0];
        //            currentUser
        for a in currentUser.articlesRead {
            if (a.name == name) {
                contains = true;
            }
        }
        
        let realm = try! Realm()
        
        if (contains == false) {
            let val = currentUser.points + 25
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
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {

//        //This is the index of the "page" that we will be landing at
//        let nearestIndex = Int(CGFloat(targetContentOffset.memory.x) / scrollView.bounds.size.width + 0.5)
//        
//        //Just to make sure we don't scroll past your content
//        let clampedIndex = 100.5;
//        // TODO : REPLACE 100.5 WITH : max( min(nearestIndex, yourPagesArray.count - 1 ), 0 )
//        
//        //This is the actual x position in the scroll view
//        var xOffset = CGFloat(clampedIndex) * scrollView.bounds.size.width
//        
//        //I've found that scroll views will "stick" unless this is done
//        xOffset = xOffset == 0.0 ? 1.0 : xOffset
//        
//        //Tell the scroll view to land on our page
//        targetContentOffset.memory.x = xOffset
//        
        
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
        print (scrollView.contentSize.height - scrollView.frame.size.height)
        print( scrollView.contentOffset.y )
        if (scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height) / 2)) {
            // reached the bottom
            print ("BOTTOM!!")

            let realm = try! Realm()
//            let users = realm.objects(User)
            
            var contains = false;
            // TODO : ACTUALLY GET THE USER THATS LOGGED IN RIGHT NOW - HOW DO I DO THAT
//            var user = users[0];
//            currentUser
            for a in currentUser.articlesRead {
                if (a.name == name) {
                    contains = true;
                }
            }
            
            if (contains == false) {
                let val = currentUser.points + 25
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
