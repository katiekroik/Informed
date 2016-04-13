//
//  FirstViewController.swift
//  Informed
//
//  Created by Megha Madan on 3/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Genre of News
    @IBOutlet weak var NewsGenre: UILabel!
    
    @IBOutlet var newsArticles: UITableView!
    
    @IBOutlet weak var eachArticle: UITableView!
    
    let textCellIdentifier = "TextCell"
    
    var articleArray = [(Article)]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NewsGenre.text = "Changed News Genre";
        self.newsArticles.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TextCell")

        let realm = try! Realm()
        let articles = realm.objects(Article)
        // tableView.delegate = self;
        for a in articles {
            // print(user)
            articleArray.append(a)
        }
       //  print(realm.objects(User))
        print(articleArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.newsArticles.dequeueReusableCellWithIdentifier("TextCell")! as UITableViewCell
        
        cell.textLabel?.text = articleArray[indexPath.row].articleName
        
        return cell    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }


}

