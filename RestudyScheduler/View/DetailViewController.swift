//
//  DetailViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var study: Study!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    @IBOutlet var firstDay: UILabel!
    @IBOutlet var secondDay: UILabel!
    @IBOutlet var thirdDay: UILabel!
    @IBOutlet var fourthDay: UILabel!
    @IBOutlet var fifthDay: UILabel!
    
    var firstReview: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        stringToDate()
        
        titleLabel.text = "科目: \(study.title)"
        dateLabel.text = "初回学習日: \(study.date)"
        detailLabel.text = "詳細: \(study.detail)"
        firstDay.text = "第一回復習日: \(stringToDate(value: 1))"
        secondDay.text = "第二回復習日: \(stringToDate(value: 7))"
        thirdDay.text = "第三回復習日: \(stringToDate(value: 16))"
        fourthDay.text = "第四回復習日: \(stringToDate(value: 35))"
        fifthDay.text = "第五回復習日: \(stringToDate(value: 62))"
        
    }
    
    func stringToDate(value: Int) -> String{
        
        let d = DateUtils.dateFromString(string: study.date, format: "yyyy/MM/dd")
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 9, to: d)!
        print("オリジナル: \(modifiedDate)") //original
        //1日プラス
        let calculated = Calendar.current.date(byAdding: .day, value: value, to: modifiedDate)
        return  DateUtils.stringFromDate(date: calculated!, format: "yyyy/MM/dd")
        
    
        
    }

}
