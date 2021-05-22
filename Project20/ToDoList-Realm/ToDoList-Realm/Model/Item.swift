//
//  Item.swift
//  ToDoList-Realm
//
//  Created by Kurtis Hoang on 4/21/21.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //link from Category with the property items
}
