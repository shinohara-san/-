//
//  InputViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/21.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
// https://grandbig.github.io/blog/2016/01/17/tabbarcontroller/

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
    var titlePlaceholder = " タイトル(必須)"
    var detailPlaceholder = "例) TOEIC単語1から20まで"
    
//    override func loadView() { //storyboardでレイアウト作ってるので使えない
//        print("loadView")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let today = Calendar.current.date(byAdding: .hour, value: 9, to: Date()) else { return }
        let aWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)
        let aWeekAhead = Calendar.current.date(byAdding: .day, value: 7, to: today)
        
        detailTextField.returnKeyType = .done
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.minimumDate = aWeekAgo
        datePicker.maximumDate = aWeekAhead
        
        detailTextField.delegate = self
        titleTextField.delegate = self
//        tabBarItem.selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal);
        
        DispatchQueue.main.async { [weak self] in
//            self?.titleTextField.textColor = UIColor.lightGray
            self?.titleTextField.layer.borderWidth = 1.0
            self?.titleTextField.layer.borderColor = UIColor.lightGray.cgColor
            self?.titleTextField.layer.cornerRadius = 8.0
            self?.titleTextField.attributedPlaceholder = NSAttributedString(string: self!.titlePlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            
            self?.detailTextField.text = self?.detailPlaceholder
            self?.detailTextField.textColor = UIColor.lightGray
            self?.detailTextField.layer.borderWidth = 1.0
            self?.detailTextField.layer.borderColor = UIColor.lightGray.cgColor
            self?.detailTextField.layer.cornerRadius = 8.0
//            self?.saveButton.layer.cornerRadius = 8.0
            self?.saveButton.layer.cornerRadius = 10
            self?.saveButton.layer.shadowColor = UIColor.black.cgColor
            self?.saveButton.layer.shadowOffset = .zero
            self?.saveButton.layer.shadowOpacity = 0.3
            self?.saveButton.layer.shadowRadius = 4
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let vc = storyboard?.instantiateViewController(identifier: "list") as? ListViewController else {return}
        guard let today = Calendar.current.date(byAdding: .hour, value: 9, to: Date()) else {return}
        vc.selectedDate = DateUtils.stringFromDate(date: today, format: "yyyy/MM/dd")
        print(vc.selectedDate)
        vc.filterTask(for: vc.selectedDate)
//        vc.tableView.reloadData()
//        vc.calendar.reloadData()
        
    }
    
    @IBAction func getDate(_ sender: Any) {
        dateString = DateUtils.stringFromDate(date: datePicker.date, format: "yyyy/MM/dd")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == detailPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        } else {
            return
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = detailPlaceholder
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
//        print(dateString)

        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            var detail = detailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if title == "" {
            let ac = UIAlertController(title: "エラー", message: "タイトルを入力してください", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        
        if detail == detailPlaceholder{
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
        
//        guard let vc = storyboard?.instantiateViewController(identifier: "list") as? ListViewController else {return}
//        guard let today = Calendar.current.date(byAdding: .hour, value: 9, to: Date()) else {return}
//        vc.filterTask(for: DateUtils.stringFromDate(date: today, format: "yyyy/MM/dd"))
//        vc.tableView.reloadData()
//        vc.calendar.reloadData()
        
        titleTextField.text = ""
        detailTextField.text = detailPlaceholder
        detailTextField.textColor = UIColor.lightGray
        
    }
    
//    @IBAction func didTapBarItem(_ sender: Any) {
//        guard let vc = storyboard?.instantiateViewController(identifier: "list") as? ListViewController else {return}
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    @IBAction func MoveToAboutVC(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "about") as? AboutViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
