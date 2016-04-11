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
    dynamic var name = "";
    // TODO : How are we representing Articles?
//    let articles = List<Object>()
//    let favorites = List<Object>()
    dynamic var points = 0;
}