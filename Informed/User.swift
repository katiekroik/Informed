//
//  User.swift
//  Informed
//
//  Created by Katie Kroik on 4/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var points = 0
    let articlesRead = List<Article>()
    let favoriteArticles = List<Article>()
    let friends = List<User>()
}