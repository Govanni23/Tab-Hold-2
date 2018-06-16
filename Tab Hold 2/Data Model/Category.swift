//
//  Category.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/16/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
