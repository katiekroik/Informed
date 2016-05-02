//
//  FirstViewController.swift
//  Informed
//
//  Created by Megha Madan on 3/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import MBProgressHUD

class FirstViewController: UITableViewController {
    
    
    @IBOutlet weak var genreTitle: UILabel!
    // Genre of News
    var articleArray = [(Article)]();
    var selectedArticle = 0
    
    var currentUser: User!
    var realm: Realm!
    var date: NSDate!
    var currentGenre: Genre!
    var allGenres = List<Genre>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let facebookId = FBSDKAccessToken.currentAccessToken().userID
        realm = try! Realm()
        let potentialUsers = realm.objects(User).filter("facebookId==%s", facebookId)
        if potentialUsers.count > 0 {
            currentUser = potentialUsers.first
        }
        date = NSDate()
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
        
        var i = 0
        
        let realm = try! Realm()
        let genres = realm.objects(Genre)
        currentGenre = genres.first
        
        genreTitle.text! = currentGenre.name
        
        while i < genres.count {
            allGenres.append(genres[i])
            i += 1
        }
        
        return populateForGenre(currentGenre.name)
    }
    
    // TODO: Attach button to this so that when a new genre is selected, we pull the articles from the database.
    func populateForGenre(inGenre: String) -> Int {
        var i = 0
        currentGenre = realm.objects(Genre).filter("name == %s", inGenre).first
        let articlesForGenre = realm.objects(Article).filter("genre.name ==%s", currentGenre.name)
        articleArray.removeAll()
        
        while i < articlesForGenre.count {
            articleArray.append(articlesForGenre[i])
            i += 1
        }
        
        return articlesForGenre.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let titleText = currentGenre?.name {
            return titleText
        } else {
            return "Oops"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
//        print(indexPath.indexAtPosition(1))
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

