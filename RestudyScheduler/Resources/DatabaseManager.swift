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
    
    private init() {} //これ使うと同時にいろんなところで使えなくすることができる
    
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
    
    public func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    public func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public func getRestudyDay(study: Study, value: Int) -> String{
        
        let d = dateFromString(string: study.date, format: "yyyy/MM/dd")
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 9, to: d)! //日本時間
        //print("オリジナル: \(modifiedDate)") //original
        let calculated = Calendar.current.date(byAdding: .day, value: value, to: modifiedDate)
        return  stringFromDate(date: calculated!, format: "yyyy/MM/dd")
    }
}
