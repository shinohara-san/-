//
//  DetailViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import RealmSwift
import Accounts
import Social

class DetailViewController: UIViewController {
    
    var study: Study!
    
    var accountStore = ACAccountStore() //Twitter、Facebookなどの認証を行うクラス
    var twitterAccount: ACAccount? //Twitterのアカウントデータを格納する
    
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
        print("あああ")
    }
    
    private func getTwitterAccount() {
    
           //アカウントを取得するタイプをTwitterに設定する
           let accountType =
            accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
    
           //Twitterのアカウントを取得する
        accountStore.requestAccessToAccounts(with: accountType, options: nil)
           { (granted:Bool?, error:Error?)-> () in
                   
               if error != nil {
                   // エラー処理
                   print("error! \(error)")
                   return
               }
            guard let granted = granted else {return}
               if !granted {
                   print("error! Twitterアカウントの利用が許可されていません")
                   return
               }
               
               // Twitterアカウント情報を取得
            let accounts = self.accountStore.accounts(with: accountType)
                   as! [ACAccount]
    
               if accounts.count == 0 {
                   print("error! 設定画面からアカウントを設定してください")
                   return
               }
               
               // ActionSheetを表示
//               self.selectTwitterAccount(accounts)
           }
       }

}
