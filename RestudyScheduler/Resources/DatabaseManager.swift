//
//  DatabaseManager.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/10/01.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    public func registerData(newStudy: Study, completion: @escaping (Bool) -> Void){
        
        if newStudy.title == "" {
            completion(false)
            return
        }

        let realm = try! Realm()
        try! realm.write {
            realm.add(newStudy)
        }
        
        completion(true)
    }
}
