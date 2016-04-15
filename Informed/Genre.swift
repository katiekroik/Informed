//
//  Genre.swift
//  Informed
//
//  Created by Katie Kroik on 4/15/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import Foundation
import RealmSwift

class Genre: Object {
    dynamic var name = ""
    dynamic var numAricles = 0
    public var articles = List<Article>()
}