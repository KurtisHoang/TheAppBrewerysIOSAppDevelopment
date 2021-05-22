//
//  Category.swift
//  ToDoList-Realm
//
//  Created by Kurtis Hoang on 4/21/21.
//

import Foundation
import RealmSwift

class Category: Object {
    //dynamic monitor for changes during runtime
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var backgroundColor: String = ""
    let items = List<Item>()
}
