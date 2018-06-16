//
//  Item.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/16/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
