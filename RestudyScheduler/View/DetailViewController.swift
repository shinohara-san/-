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
        DispatchQueue.main.async { [weak self] in
            
            self?.titleLabel.text = "科目: \(self?.study.title ?? "")"
            self?.dateLabel.text = "初回学習日: \(self?.study.date ?? "")"
            self?.detailLabel.text = "詳細: \(self?.study.detail ?? "")"
            self?.firstDay.text = "第1回復習日: \(self?.study.firstDay ?? "")"
            self?.secondDay.text = "第2回復習日: \(self?.study.secondDay ?? "")"
            self?.thirdDay.text = "第3回復習日: \(self?.study.thirdDay ?? "")"
            self?.fourthDay.text = "第4回復習日: \(self?.study.fourthDay ?? "")"
            self?.fifthDay.text = "第5回復習日: \(self?.study.fifthDay ?? "")"
            
        }
        
        DispatchQueue.main.async {
            self.firstDaySwitch.isOn = self.study.firstDayDone
            self.secondDaySwitch.isOn = self.study.secondDayDone
            self.thirdDaySwitch.isOn = self.study.thirdDayDone
            self.fourthDaySwitch.isOn = self.study.fourthDayDone
            self.fifthDaySwitch.isOn = self.study.fifthDayDone
        }
    }
    
    @IBAction func firstDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.firstDayDone = study.firstDayDone ? false : true
        }
        checkAllTrue()
    }
    @IBAction func secondDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.secondDayDone = study.secondDayDone ? false : true
        }
        checkAllTrue()
    }
    @IBAction func thirdDaySwitchToggled(_ sender: Any) {
       let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.thirdDayDone = study.thirdDayDone ? false : true
        }
        checkAllTrue()
    }
    @IBAction func fourthDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.fourthDayDone = study.fourthDayDone ? false : true
        }
        checkAllTrue()
    }
    @IBAction func fifthDaySwitchToggled(_ sender: Any) {
        let realm = try! Realm()
        guard let updatedStudy = realm.objects(Study.self).filter("id = '\(study.id)'").first else {return}
        try! realm.write {
            updatedStudy.fifthDayDone = study.fifthDayDone ? false : true
        }
        checkAllTrue()
    }
    
    func checkAllTrue(){
        if study.firstDayDone == true, study.secondDayDone == true, study.thirdDayDone == true, study.fourthDayDone == true, study.fifthDayDone == true{ 
            let ac = UIAlertController(title: "復習完了！", message: "お疲れ様でした。", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    ///全部trueでアニメーション
    //    func completedCheck(string: String)-> NSMutableAttributedString{
    //        let attributeString =  NSMutableAttributedString(string: string)
    //        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    //        return attributeString
    //    }
}
