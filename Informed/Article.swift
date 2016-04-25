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
    dynamic var id = 0
    dynamic var name = ""
    dynamic var content = ""
    dynamic var publisher = ""
}