//
//  LeaderboardViewController.swift
//  Informed
//
//  Created by Katie Kroik on 4/4/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import RealmSwift


class LeaderboardViewController: UIViewController {

    @IBOutlet weak var leader1: UILabel!
    @IBOutlet weak var leader2: UILabel!
    @IBOutlet weak var leader3: UILabel!
    @IBOutlet weak var leader4: UILabel!
    @IBOutlet weak var leader5: UILabel!
    @IBOutlet weak var points1: UILabel!
    @IBOutlet weak var points2: UILabel!
    @IBOutlet weak var points3: UILabel!
    @IBOutlet weak var points4: UILabel!
    @IBOutlet weak var points5: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let users = realm.objects(User)
        
        let sortedUsers = users.sorted("points", ascending: false)
        
        
        leader1.text = sortedUsers[0].name
        points1.text = String(sortedUsers[0].points)
        
        leader2.text = sortedUsers[1].name
        points2.text = String(sortedUsers[1].points)
        
        leader3.text = sortedUsers[2].name
        points3.text = String(sortedUsers[2].points)
        
        leader4.text = sortedUsers[3].name
        points4.text = String(sortedUsers[3].points)
        
        leader5.text = sortedUsers[4].name
        points5.text = String(sortedUsers[4].points)
        // leader2.text = sortedArticles[1]
        // let sortedDogs = realm.objects(Dog).filter("color = 'tan' AND name BEGINSWITH 'B'").sorted("name")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
