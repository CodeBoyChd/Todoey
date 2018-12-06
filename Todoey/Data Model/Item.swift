//
//  Item.swift
//  Todoey
//
//  Created by Anurag Garg on 06/12/18.
//  Copyright © 2018 U2opia Mobile. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title :  String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
