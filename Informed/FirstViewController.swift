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

class FirstViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Genre of News
    var articleArray = [(Article)]();
    var selectedArticle = 0
    @IBOutlet var articleTable: UITableView!
    @IBOutlet var genrePicker: UIPickerView!
    
    var currentUser: User!
    var realm: Realm!
    var date: NSDate!
    var currentGenre: Genre!
    var allGenres = List<Genre>()
    var lastTimeChecked: NSDate!
    
    // variables for picker view
    var genreArray = [Genre]()
    var pickedGenre = 0
    
    // The following two dictionaries use our genre naming conventions as keys,
    // and the corresponding news outlet's naming conventions as the values.
    // This makes for slightly more elegant code when requests are made to either.
    let nprIds = [
        "politics" : 1014,
        "entertainment" : 1048,
        "sports" : 1055,
        "technology" : 1019
    ]
    
    let guardianIds = [
        "politics" : "politics",
        "entertainment" : "culture",
        "sports" : "sport",
        "technology" : "technology"
    ]
    
    
    // When a new genre is selected, we pull the articles from the database.
    // At the moment, this determines the number of table cells we need.
    func populateForGenre() -> Int {
        var i = 0
        currentGenre = realm.objects(Genre).filter("name == %s", currentGenre.name).first
        let articlesForGenre = realm.objects(Article).filter("genre.name == %s", currentGenre.name)
        articleArray.removeAll()
        
        while i < articlesForGenre.count {
            articleArray.append(articlesForGenre[i])
            i += 1
        }
        
        
        return articlesForGenre.count
    }
    
    // When called, this function checks for how long ago we made a request to the APIs of each news outlet.
    // If it's been over five minutes, run another request. Otherwise, ignore the request (we don't want to overuse our API limits!!)
    private func loadNewArticles() {
        let calendar = NSCalendar.currentCalendar()
        let fiveMinutesAgo = calendar.dateByAddingUnit(.Minute, value: -5, toDate: NSDate(), options: [])
        
        if lastTimeChecked.compare(fiveMinutesAgo!) == NSComparisonResult.OrderedAscending || realm.objects(Article).count < 100 {
            lastTimeChecked = NSDate()
            print("It's been more than five minutes!")
            showLoadingHUD()
            loadGuardianArticles(currentGenre.name.lowercaseString)
            loadNprArticles(currentGenre.name.lowercaseString)
            hideLoadingHUD()
        }
        
        currentGenre = genreArray[pickedGenre]
        populateForGenre()
        self.articleTable.reloadData()
    }
    
    // Use NPR API to load stories pertaining to the passed genre.
    private func loadNprArticles(inGenre: String) {
        let newArticles = List<Article>()
        let id = nprIds[inGenre]
        let nprParameters = [
            "apiKey" : "MDIzNzk1Mjk1MDE0NjA1NzU0ODg1Y2ZlZQ000", // Our API Key (Shh!!)
            "format" : "json",                                  // Easiest format for parsing.
            "id" : String(id!),                                 // NPR's ID corresponding to said category.
            "hideChildren" : "1",                               // Tailor our results.
            "fields" : "titles,dates",                          // Continue to tailor our results.
            "requiredAssets" : "text",                          // Unsure, but necessary.
            "dateType" : "story",                               // They have a few different DateTypes for articles.
            "searchType" : "mainText"                           // We want articles, not comments or related.
        ]
        Alamofire.request(.GET, "http://api.npr.org/query", parameters: nprParameters)
            .responseJSON { (_,_,result) in
                switch result {
                case .Success(let data):
                    // This path executes if Alamofire's attempt to make a connection is successful.
                    let json = JSON(data)
                    let filteredResults = json["list"]["story"]
                    
                    // We use our own custom date formatter to convert the NPR API's
                    // into something more consistent in our own database.
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "EEE, dd MMMM yyyy HH:mm:ss -0400"
                    
                    for(_, subJson):(String, JSON) in filteredResults {
                        // Traverse each returned article,
                        // and first ensure that we do not already have it in the database.
                        if self.realm.objects(Article).filter("publishId == %s", subJson["id"].string!).count > 0 {
                            break
                        }
                        // Otherwise, create a new article and populate with information.
                        let thisArticle = Article()
                        let thisDate = dateFormatter.dateFromString(subJson["pubDate"]["$text"].string!)
                        thisArticle.datePublished = thisDate!
                        thisArticle.genre = self.currentGenre
                        thisArticle.linkTo = subJson["link"][2]["$text"].string!
                        thisArticle.name = subJson["title"]["$text"].string!
                        thisArticle.publisher = "NPR"
                        thisArticle.publishId = subJson["id"].string!
                        newArticles.append(thisArticle)
                    }
                    // Only add to the database if there is at least one new article.
                    if newArticles.count > 0 {
                        try! self.realm.write {
                            self.realm.add(newArticles)
                        }
                    }
                case .Failure(_, let error):
                    // This should never happen.
                    print("Request failed with error \(error)")
                }
        }
    }
    
    // Function which makes a request out to The Guardian's API using Alamofire.
    // When completed, it should add new articles to the database.
    private func loadGuardianArticles(inGenre: String) {
        let newArticles = List<Article>()
        let id = guardianIds[inGenre]!  // Get The Guardian's ID corresponding to this genre from our earlier defined dictionary.
        
        let guardianParameters = [
            "api-key" : "e7fccd80-1524-44c8-aabb-7db8a8921872", // Our API Key (Shh! Don't tell anyone!)
            "section" : id
        ]
        
        // Make the request.
        Alamofire.request(.GET, "http://content.guardianapis.com/search",parameters: guardianParameters)
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    // If successful, parse the JSON
                    let json = JSON(data)
                    let filteredResults = json["response"]["results"]
                    
                    // Reformat their date to correspond to the existing format used in our database.
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    
                    for (_, subJson):(String, JSON) in filteredResults {
                        // Only add to our array if there isn't already a corresponding record in the database.
                        // Don't worry about updated articles, as they will have the same link as the old ones
                        // (This is the benefit of storing links, not whole stories).
                        if self.realm.objects(Article).filter("publishId == %s", subJson["id"].string!).count > 0 {
                            break
                        }
                        let thisArticle = Article()
                        let thisDate = dateFormatter.dateFromString(subJson["webPublicationDate"].string!)
                        thisArticle.datePublished = thisDate!
                        thisArticle.genre = self.currentGenre
                        thisArticle.name = subJson["webTitle"].string!
                        thisArticle.publisher = "The Guardian"
                        thisArticle.publishId = subJson["id"].string!
                        thisArticle.linkTo = subJson["webUrl"].string!
                        newArticles.append(thisArticle)
                    }
                    // Only add to the database if there's something worth adding.
                    if newArticles.count > 0 {
                        try! self.realm.write {
                            self.realm.add(newArticles)
                        }
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
    
    // This just displays a loading HUD in the middle of the page. May be redundant.
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(articleTable, animated: true)
        hud.labelText = "Loading..."
    }
    // Hides the loading HUD from the previous function. Mostly implemented MBProgressHUD as a means to experiment with CocoaPods.
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(articleTable, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let facebookId = FBSDKAccessToken.currentAccessToken().userID
        realm = try! Realm()
        let potentialUsers = realm.objects(User).filter("facebookId == %s", facebookId)
        if potentialUsers.count > 0 {
            currentUser = potentialUsers.first
        }
        date = NSDate()
        lastTimeChecked = NSDate()
        
        var i = 0
        let genres = realm.objects(Genre)
        currentGenre = genres.first
        
        //genreTitle.text! = currentGenre.name
        
        genrePicker.delegate = self
        genrePicker.dataSource = self
        
        while i < genres.count {
            allGenres.append(genres[i])
            i += 1
        }
        
        let refreshControl = UIRefreshControl()
        // refreshControl.addTarget(self, action: #selector(FirstViewController.refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        loadNewArticles()
        refreshControl.endRefreshing()
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
        currentGenre = genreArray[pickedGenre]
        return populateForGenre()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        let i = indexPath.indexAtPosition(1)
        cell.textLabel?.font = UIFont(name: "AmericanTypeWriter", size: 15)
        cell.textLabel?.text = articleArray[i].name
        
        return cell
    }
    
    func didSelectRowAtIndexPath(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            print ("CALLING DIDSELECT");
            let row = indexPath.row
            print("Row: \(row)")
            selectedArticle = row
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        selectedArticle = row
        // performSegueWithIdentifier("ShowIndivSegue", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        tableView(this, )
        print("in prepare for segue")
        print(segue.identifier)
        if segue.identifier == "ShowIndivSegue" {
            if let cell = sender as? UITableViewCell {
                let i = selectedArticle

                selectedArticle = (articleTable.indexPathForCell(cell)?.item)!
                if segue.identifier == "ShowIndivSegue" {
                    let vc = segue.destinationViewController as! IndividualArticleViewController
                    
                    vc.article = articleArray[selectedArticle]
                    vc.aUrl = articleArray[selectedArticle].linkTo
                    vc.currentUser = currentUser
                }
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // create the genre array which will populate picker view
        for Genre in allGenres{
            // add each genre from realm to array
            genreArray.append(Genre)
        }
        return genreArray[row].name // return the names of the genres
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // set up number of rows in picker view according to number of genres from realm
        let genres = realm.objects(Genre)
        return genres.count
    }
    
    // only one column of choices for genre
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // function to determine what to do when something is picked on picker view
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedGenre = row
        // the index of picker view should align with index in genre array
        currentGenre = genreArray[pickedGenre]
        // reload articles when picked
        loadNewArticles()
    }
}

