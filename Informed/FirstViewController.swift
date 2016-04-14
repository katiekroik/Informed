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

//    let textCellIdentifier = "TextCell"
//    
    var articleArray = [(Article)]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        NewsGenre.text = "Changed News Genre";
        // genre.text = "Changed Genre in FVC!";
        // self.genre.text = "Changed Genre in FVC!";
//        self.newsArticles.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TextCell")
        let realm = try! Realm()
        let articles = realm.objects(Article)
        // tableView.delegate = self;
        for a in articles {
            articleArray.append(a)
        }
        print("** PRINTING ARTICLES **")
        print(articleArray)
//
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
        return articleArray.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // print(articleArray)
        return "Genre \(section)"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        // cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
//        let a = self.articleArray[indexPath]
//        print(a)
        // print(cellForRowAtIndexPath)
        print(indexPath.indexAtPosition(1))
        let i = indexPath.indexAtPosition(1)
        print(articleArray[i])
        // print(articleArray[indexPath.indexAtPostition(1)])
        // cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        cell.textLabel?.text = articleArray[i].articleName
        return cell
    }
}

