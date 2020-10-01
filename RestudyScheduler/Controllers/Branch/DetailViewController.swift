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
            
            self?.titleLabel.text = self?.study.title ?? ""
            self?.dateLabel.text = "初回学習日: \(self?.study.date ?? "")"
            self?.detailLabel.text = "詳細: \(self?.study.detail ?? "")"
            self?.firstDay.text = "第1回復習日: \(self?.study.firstDay ?? "")"
            self?.secondDay.text = "第2回復習日: \(self?.study.secondDay ?? "")"
            self?.thirdDay.text = "第3回復習日: \(self?.study.thirdDay ?? "")"
            self?.fourthDay.text = "第4回復習日: \(self?.study.fourthDay ?? "")"
            self?.fifthDay.text = "第5回復習日: \(self?.study.fifthDay ?? "")"
            
            self?.view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
            
        }
        
        DispatchQueue.main.async {
            
            self.firstDaySwitch.isOn = self.study.firstDayDone
            self.firstDaySwitch.onTintColor = .systemYellow
            self.secondDaySwitch.isOn = self.study.secondDayDone
            self.secondDaySwitch.onTintColor = .systemBlue
            self.thirdDaySwitch.isOn = self.study.thirdDayDone
            self.thirdDaySwitch.onTintColor = .systemRed
            self.fourthDaySwitch.isOn = self.study.fourthDayDone
            self.fourthDaySwitch.onTintColor = .systemGreen
            self.fifthDaySwitch.isOn = self.study.fifthDayDone
            self.fifthDaySwitch.onTintColor = .systemOrange
            
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
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            
            ac.addAction(UIAlertAction(title: "Twitterでつぶやく", style: .default, handler: { (_) in
                self.tweet()
            }))
            
            present(ac, animated: true)
            
        }
    }
    
    func tweet(){
        let text = "復習サイクルAppで復習5回終了しましたー！皆さんも使ってみて😄\nhttps://apps.apple.com/jp/app/%E5%BE%A9%E7%BF%92%E3%82%B5%E3%82%A4%E3%82%AF%E3%83%AB/id1524236844?l=en"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
