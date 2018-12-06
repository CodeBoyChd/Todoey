//
//  Category.swift
//  Todoey
//
//  Created by Anurag Garg on 06/12/18.
//  Copyright © 2018 U2opia Mobile. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String  = ""
    let items = List<Item>()
}
