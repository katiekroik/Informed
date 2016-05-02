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
import SwiftyJSON

class FirstViewController: UITableViewController {
    
    
    @IBOutlet weak var genreTitle: UILabel!
    // Genre of News
    var articleArray = [(Article)]();
    var selectedArticle = 0
    @IBOutlet var articleTable: UITableView!
    
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
        
        var i = 0
        let genres = realm.objects(Genre)
        currentGenre = genres.first
        
        genreTitle.text! = currentGenre.name
        
        while i < genres.count {
            allGenres.append(genres[i])
            i += 1
        }
        
        loadNewArticles()
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
        return populateForGenre(currentGenre.name)
    }
    
    // TODO: Attach button to this so that when a new genre is selected, we pull the articles from the database.
    func populateForGenre(inGenre: String) -> Int {
        var i = 0
        currentGenre = realm.objects(Genre).filter("name == %s", inGenre).first
        let articlesForGenre = realm.objects(Article).filter("genre.name == %s", currentGenre.name)
        articleArray.removeAll()
        
        while i < articlesForGenre.count {
            articleArray.append(articlesForGenre[i])
            i += 1
        }
        
        return articlesForGenre.count
    }
    
    private func loadNewArticles() {
        showLoadingHUD()
        loadGuardianArticles()
        hideLoadingHUD()
    }
    
    private func loadGuardianArticles() {
        let mostRecent = realm.objects(Article).sorted("datePublished", ascending: false).first
        let newArticles = List<Article>()
        
        // GUARDIAN REQUEST
        let guardianParameters = [
            "api-key" : "e7fccd80-1524-44c8-aabb-7db8a8921872",
            "section" : currentGenre.name.lowercaseString
        ]
        Alamofire.request(.GET, "http://content.guardianapis.com/search",parameters: guardianParameters)
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    let filteredResults = json["response"]["results"]
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    for (_, subJson):(String, JSON) in filteredResults {
                        let thisArticle = Article()
                        let thisDate = dateFormatter.dateFromString(subJson["webPublicationDate"].string!)
                        thisArticle.datePublished = thisDate!
                        thisArticle.genre = self.currentGenre
                        thisArticle.name = subJson["webTitle"].string!
                        thisArticle.publisher = "The Guardian"
                        thisArticle.publishId = subJson["id"].string!
                        if thisArticle.publishId == mostRecent?.datePublished {
                            break
                        }
                        thisArticle.linkTo = subJson["webUrl"].string!
                        newArticles.append(thisArticle)
                    }
                    try! self.realm.write {
                        self.realm.add(newArticles)
                    }
                case .Failure(_, let error):
                    print("Request failed with error \(error)")
                }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let titleText = currentGenre?.name {
            return titleText
        } else {
            return "Oops"
        }
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(articleTable, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(articleTable, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        let i = indexPath.indexAtPosition(1)
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

