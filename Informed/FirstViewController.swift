//
//  FirstViewController.swift
//  Informed
//
//  Created by Megha Madan on 3/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UITableViewController {

    @IBOutlet weak var genre: UILabel!
    // Genre of News
    @IBOutlet var webView: UIWebView!
    var articleArray = [(Article)]();
    var selectedArticle = 0
    
    var currentUser = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let facebookId = FBSDKAccessToken.currentAccessToken().userID
        let potentialUsers = try! Realm().objects(User).filter("facebookId==%s", facebookId)
        if potentialUsers.count > 0 {
            currentUser = potentialUsers[0]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        var count = 0
        
        let realm = try! Realm()
        let genre = realm.objects(Genre)[0]
        let genreName = genre.name
//        let genreFilter = NSPredicate(format: "genre = @%", genre)
        let articles = realm.objects(Article)
        
        for a in articles {
            if (a.genre == genre) {
                count++
                articleArray.append(a);
            }
        }
        
//        print(puppies)

        return count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pawnee Politics"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        print(indexPath.indexAtPosition(1))
        let i = indexPath.indexAtPosition(1)
//        print(articleArray[i])
        cell.textLabel?.text = articleArray[i].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        selectedArticle = row
        // performSegueWithIdentifier("ShowIndivSegue", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        print("in prepare for segue")
        print(segue.identifier)
        if segue.identifier == "ShowIndivSegue" {
            print("preparing")
            if let cell = sender as? UITableViewCell {
                let i = selectedArticle
                if segue.identifier == "ShowIndivSegue" {
                    /* Right now I have it set to NavLeaderViewController, bc I'm playing around
                    with it and idk what's wrong... */
                    let vc = segue.destinationViewController as! IndividualArticleViewController
                    print(articleArray[i])
                    vc.name = articleArray[i].name
                    
                    vc.article = articleArray[i]
                    vc.aUrl = articleArray[i].linkTo
                    vc.currentUser = currentUser
                    
//                    vc.articleName.text = articleArray[i].articleName
//                    vc.articleContents.text = articleArray[i].articleText
                    
//                    let vc = segue.destinationViewController as! NavLeaderViewController
//                    vc.articleName = articleArray[i].articleName
//                    vc.articleContents = articleArray[i].articleText
                }
            }
        }
    }
}

