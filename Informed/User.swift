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
    dynamic var name = ""
    dynamic var points = 0
    public var favoriteArticles = List<Article>()
}