//
//  Article.swift
//  Informed
//
//  Created by Katie Kroik on 4/11/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import Foundation
import RealmSwift

class Article: Object {
    dynamic var genre: Genre!
    dynamic var name = ""
    dynamic var publisher = ""
    dynamic var publishId = ""
    dynamic var linkTo = ""
    dynamic var datePublished = NSDate()
}