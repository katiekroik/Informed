//
//  User.swift
//  Informed
//
//  Created by Katie Kroik on 4/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//
// User object to hold information fetched from facebook and used in realm database


import Foundation
import RealmSwift

class User: Object {
    dynamic var facebookId = ""
    dynamic var name = ""
    dynamic var email = ""
    dynamic var startOfStreak = NSDate()
    dynamic var lastLogin = NSDate()
    dynamic var points = 0
    dynamic var picture = ""
    let articlesRead = List<Article>()
    let favoriteArticles = List<Article>()
}
