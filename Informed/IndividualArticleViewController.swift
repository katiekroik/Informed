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
    @IBOutlet weak var articleName: UILabel!
    // Article contents
    @IBOutlet weak var articleContents: UITextView!

    var name = String()
    var contents = String()
    var aName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleContents.delegate = self;


        articleContents.decelerationRate = UIScrollViewDecelerationRateFast;
        articleContents.userInteractionEnabled = true;
        articleContents.scrollEnabled = true;
//        articleContents.scrollRangeToVisible(NSRange(location:0, length:0))

        print(articleName.text)
        
        articleName.text = aName
        articleContents.text = contents
        
//        articleContents.frame
        let frame = self.view.frame;
    
        print(articleContents.frame)
        print(frame)
        // articleContents.frame = frame

        if (articleContents.contentOffset.y >= articleContents.contentSize.height - articleContents.frame.size.height)
        {
            NSLog("at bottom");
        }
        NSLog("Did load Individual Article");
//        scrollToBotom()
    }
    
    override func viewWillAppear(animated: Bool) {
        articleName.text = aName;
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
        if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
            // reached the bottom
            print ("BOTTOM!!")

            let realm = try! Realm()
            let users = realm.objects(User)
            
            
            let u = users[0]
            print(u)
            let val = u.points + 50
            print(val)
            
            try! realm.write {
                u.points = val
            }
        }
    }
    
    func scrollToBotom() {
        let range = NSMakeRange(articleContents.text.characters.count - 1, 1);
        articleContents.scrollRangeToVisible(range);
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
