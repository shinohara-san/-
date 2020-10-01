//
//  Study.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation
import RealmSwift

class Study : Object{
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var detail: String = ""
    
    @objc dynamic var firstDay: String = ""
    @objc dynamic var secondDay: String = ""
    @objc dynamic var thirdDay: String = ""
    @objc dynamic var fourthDay: String = ""
    @objc dynamic var fifthDay: String = ""
    
    @objc dynamic var firstDayDone = false
    @objc dynamic var secondDayDone = false
    @objc dynamic var thirdDayDone = false
    @objc dynamic var fourthDayDone = false
    @objc dynamic var fifthDayDone = false
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
}
