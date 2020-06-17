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
    @objc dynamic var forthDay: String = ""
    @objc dynamic var fifthDay: String = ""
    
    //dayごとにboolつけて完了かまだかをtoggleさせたいなー。後々。
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
}
