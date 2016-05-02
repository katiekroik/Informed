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
    
    var genreArray = [Genre]()
    //var genreArray = ["Politics", "Sports", "Entertainment", "Technology"]
    
    var pickedGenre = 0
    
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
    
    
    // TODO: Attach button to this so that when a new genre is selected, we pull the articles from the database.
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
    
    private func loadNprArticles(inGenre: String) {
        let newArticles = List<Article>()
        let id = nprIds[inGenre]
        let nprParameters = [
            "apiKey" : "MDIzNzk1Mjk1MDE0NjA1NzU0ODg1Y2ZlZQ000",
            "format" : "json",
            "id" : String(id!),
            "hideChildren" : "1",
            "fields" : "titles,dates",
            "requiredAssets" : "text",
            "dateType" : "story",
            "searchType" : "mainText"
        ]
        Alamofire.request(.GET, "http://api.npr.org/query", parameters: nprParameters)
            .responseJSON { (_,_,result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    let filteredResults = json["list"]["story"]
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "EEE, dd MMMM yyyy HH:mm:ss -0400"
                    for(_, subJson):(String, JSON) in filteredResults {
                        if self.realm.objects(Article).filter("publishId == %s", subJson["id"].string!).count > 0 {
                            break
                        }
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
    
    private func loadGuardianArticles(inGenre: String) {
        let newArticles = List<Article>()
        let id = guardianIds[inGenre]!
        
        let guardianParameters = [
            "api-key" : "e7fccd80-1524-44c8-aabb-7db8a8921872",
            "section" : id
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
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(articleTable, animated: true)
        hud.labelText = "Loading..."
    }
    
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
        refreshControl.addTarget(self, action: #selector(FirstViewController.refresh(_:)), forControlEvents: .ValueChanged)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        selectedArticle = row
        // performSegueWithIdentifier("ShowIndivSegue", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        print(segue.identifier)
        if segue.identifier == "ShowIndivSegue" {
            if let cell = sender as? UITableViewCell {
                selectedArticle = (articleTable.indexPathForCell(cell)?.item)!
                if segue.identifier == "ShowIndivSegue" {
                    /* Right now I have it set to NavLeaderViewController, bc I'm playing around
                    with it and idk what's wrong... */
                    let vc = segue.destinationViewController as! IndividualArticleViewController
                    
                    vc.article = articleArray[selectedArticle]
                    vc.aUrl = articleArray[selectedArticle].linkTo
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        for Genre in allGenres{
            genreArray.append(Genre)
        }
        
        return genreArray[row].name
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let genres = realm.objects(Genre)

        return genres.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedGenre = row
        currentGenre = genreArray[pickedGenre]
        loadNewArticles()
    }


}

