//
//  CommonMethods.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation
import UIKit

class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

class Calculate {
    class func getRestudyDay(study: Study, value: Int) -> String{
        
        let d = DateUtils.dateFromString(string: study.date, format: "yyyy/MM/dd")
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 9, to: d)! //日本時間
        //print("オリジナル: \(modifiedDate)") //original
        
        let calculated = Calendar.current.date(byAdding: .day, value: value, to: modifiedDate)
        return  DateUtils.stringFromDate(date: calculated!, format: "yyyy/MM/dd")
    }
}
