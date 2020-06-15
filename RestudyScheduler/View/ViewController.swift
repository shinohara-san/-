//
//  ViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, FSCalendarDelegate {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var detailTextField: UITextView!
    @IBOutlet var calendar: FSCalendar!
    
    @IBOutlet var saveButton: UIButton!
    var dateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextField.text = "勉強したことを記入してください"
        detailTextField.textColor = UIColor.lightGray
        detailTextField.returnKeyType = .done
        detailTextField.delegate = self
        titleTextField.delegate = self
        
        calendar.delegate = self
        
        detailTextField.layer.borderWidth = 1.0
        detailTextField.layer.borderColor = UIColor.lightGray.cgColor
        detailTextField.layer.cornerRadius = 8.0
        
        saveButton.layer.cornerRadius = 8.0
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
        
        let realm = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        try! realm.write {
            realm.add(newStudy)
        }
        
        titleTextField.text = ""
        detailTextField.text = "勉強したことを記入してください"
        detailTextField.textColor = UIColor.lightGray
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 9, to: date)!
        
        dateString = DateUtils.stringFromDate(date: modifiedDate, format: "yyyy/MM/dd")
        }
    
    @IBAction func didTapBarItem(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "list") as? ListViewController else {return}
        navigationController?.pushViewController(vc, animated: true)
    }
}

