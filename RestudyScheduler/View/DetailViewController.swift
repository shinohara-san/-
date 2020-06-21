//
//  DetailViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import RealmSwift

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
    
    @IBOutlet var firstDaySwitch: UISwitch!
    @IBOutlet var secondDaySwitch: UISwitch!
    @IBOutlet var thirdDaySwitch: UISwitch!
    @IBOutlet var fourthDaySwitch: UISwitch!
    @IBOutlet var fifthDaySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        titleLabel.attributedText = attributeString 取り消し線引くならこれ使う
        titleLabel.text = "科目: \(study.title)"
        dateLabel.text = "初回学習日: \(study.date)"
        detailLabel.text = "詳細: \(study.detail)"
        firstDay.text = "第一回復習日: \(study.firstDay)"
        secondDay.text = "第二回復習日: \(study.secondDay)"
        thirdDay.text = "第三回復習日: \(study.thirdDay)"
        fourthDay.text = "第四回復習日: \(study.fourthDay)"
        fifthDay.text = "第五回復習日: \(study.fifthDay)"
        
        firstDaySwitch.isOn = study.firstDayDone
        secondDaySwitch.isOn = study.secondDayDone
        thirdDaySwitch.isOn = study.thirdDayDone
        fourthDaySwitch.isOn = study.fourthDayDone
        fifthDaySwitch.isOn = study.fifthDayDone
    }
    
    @IBAction func firstDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.firstDayDone = study.firstDayDone ? false : true
        }
    }
    @IBAction func secondDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.secondDayDone = study.secondDayDone ? false : true
        }
    }
    @IBAction func thirdDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.thirdDayDone = study.thirdDayDone ? false : true
        }
    }
    @IBAction func fourthDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.fourthDayDone = study.fourthDayDone ? false : true
        }
    }
    @IBAction func fifthDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.fifthDayDone = study.fifthDayDone ? false : true
        }
    }
    
    ///全部trueでアニメーション
    //    func completedCheck(string: String)-> NSMutableAttributedString{
    //        let attributeString =  NSMutableAttributedString(string: string)
    //        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    //        return attributeString
    //    }
}
