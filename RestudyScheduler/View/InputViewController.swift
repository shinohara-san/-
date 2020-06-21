//
//  InputViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/21.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var detailTextField: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var saveButton: UIButton!
    
    var dateString = ""
    var studyArrayForNotification = [Study]()
    var tomorrow:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
//                print("success")
            }else if let error = error{
                print(error.localizedDescription)
            }
        }
        
        
        let config = Realm.Configuration(schemaVersion: 3)
        Realm.Configuration.defaultConfiguration = config
        //      print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        datePicker.datePickerMode = .date
        
        detailTextField.text = "勉強したことを記入してください"
        detailTextField.textColor = UIColor.lightGray
        detailTextField.returnKeyType = .done
        detailTextField.delegate = self
        titleTextField.delegate = self
        
        detailTextField.layer.borderWidth = 1.0
        detailTextField.layer.borderColor = UIColor.lightGray.cgColor
        detailTextField.layer.cornerRadius = 8.0
        
        saveButton.layer.cornerRadius = 8.0
        
        checkRealm()
        if studyArrayForNotification.isEmpty{
            print("no study tmr")
        } else {
//            print("you have study plans")
            let content = UNMutableNotificationContent()
            content.title = "復習しましょう"
            content.sound = .default
            content.body = "今日は\(String(studyArrayForNotification.count))科目！"
            
            guard let targetDate = tomorrow else { return }//当日とdbから引っ張ってきた日付が一致したら発動
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
            let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {
                error in
                if error != nil{
                    print(error?.localizedDescription as Any)
                }
                //エラーがなければrequestが通る
            })
            
        }
    }
    
    @IBAction func getDate(_ sender: Any) {
        dateString = DateUtils.stringFromDate(date: datePicker.date, format: "yyyy/MM/dd")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "勉強したことを記入してください"{
            textView.text = ""
            textView.textColor = UIColor.black
        } else {
            return
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "勉強したことを記入してください"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            var detail = detailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if title == "" {
            let ac = UIAlertController(title: "エラー", message: "タイトルを入力してください", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
        if detail == "勉強したことを記入してください"{
            detail = ""
        }
        
        if dateString == ""{
            dateString = DateUtils.stringFromDate(date: Date(), format: "yyyy/MM/dd")
        }
        
        let newStudy = Study()
        newStudy.id = UUID().uuidString
        newStudy.title = title
        newStudy.detail = detail
        newStudy.date = dateString
        newStudy.firstDay = Calculate.getRestudyDay(study: newStudy, value: 1)
        newStudy.secondDay = Calculate.getRestudyDay(study: newStudy, value: 7)
        newStudy.thirdDay = Calculate.getRestudyDay(study: newStudy, value: 16)
        newStudy.fourthDay = Calculate.getRestudyDay(study: newStudy, value: 35)
        newStudy.fifthDay = Calculate.getRestudyDay(study: newStudy, value: 62)
        
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(newStudy)
        }
        
        titleTextField.text = ""
        detailTextField.text = "勉強したことを記入してください"
        detailTextField.textColor = UIColor.lightGray
        
    }
    
    
    
    //    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    //        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 9, to: date)!
    //
    //        dateString = DateUtils.stringFromDate(date: modifiedDate, format: "yyyy/MM/dd")
    //        }
    
    
    @IBAction func didTapBarItem(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "list") as? ListViewController else {return}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkRealm(){
        let realm = try! Realm()
        let today = Date()
        let comps = DateComponents(day: 1, hour: 9)
        tomorrow = Calendar.current.date(byAdding: comps, to: today)
        guard let checkedTmr = tomorrow else { return }
        let adjustedTmr = Calendar.current.date(byAdding: .day, value: -1, to: checkedTmr)
        let tomorrowString = DateUtils.stringFromDate(date: adjustedTmr!, format: "yyyy/MM/dd") //-1日したい
        let studies = realm.objects(Study.self).filter("firstDay = '\(tomorrowString)' OR secondDay = '\(tomorrowString)' OR thirdDay = '\(tomorrowString)' OR fourthDay = '\(tomorrowString)' OR fifthDay = '\(tomorrowString)'")
//        print(studies)
        studyArrayForNotification = Array(studies) //RealmのResultをArrayに変換
        print(adjustedTmr!)
        print(tomorrowString)
//        print(studyArrayForNotification)
    }
    
}
