//
//  InputViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/21.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
// https://grandbig.github.io/blog/2016/01/17/tabbarcontroller/

import UIKit

class InputViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var detailTextField: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var saveButton: UIButton!
    
    var dateString = ""
    var studyArrayForNotification = [Study]()
    var tomorrow:Date?
    var titlePlaceholder = "タイトル(必須)"
    var detailPlaceholder = "例) TOEIC単語1から20まで"
    
//    override func loadView() { //storyboardでレイアウト作ってるので使えない
//        print("loadView")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDatePicker()
        setUpTitleTextField()
        setUpDetailTextField()
        setUpSaveButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setUpDatePicker(){
        
        guard let today = Calendar.current.date(byAdding: .hour, value: 9, to: Date()) else { return }
        let aWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)
//        let aWeekAhead = Calendar.current.date(byAdding: .day, value: 7, to: today)
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.minimumDate = aWeekAgo
//        datePicker.maximumDate = aWeekAhead
    }
    
    private func setUpTitleTextField(){
        titleTextField.delegate = self
        titleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        titleTextField.leftViewMode = .always
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.cornerRadius = 8.0
        titleTextField.attributedPlaceholder = NSAttributedString(string: titlePlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    private func setUpDetailTextField(){
        detailTextField.returnKeyType = .done
        detailTextField.delegate = self
        detailTextField.text = detailPlaceholder
        detailTextField.textColor = UIColor.lightGray
        detailTextField.layer.borderWidth = 1.0
        detailTextField.layer.borderColor = UIColor.lightGray.cgColor
        detailTextField.layer.cornerRadius = 8.0
    }
    
    private func setUpSaveButton(){
        saveButton.layer.cornerRadius = 10
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOffset = .zero
        saveButton.layer.shadowOpacity = 0.3
        saveButton.layer.shadowRadius = 4
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let vc = storyboard?.instantiateViewController(identifier: "list") as? ListViewController else {return}
        guard let today = Calendar.current.date(byAdding: .hour, value: 9, to: Date()) else {return}
        vc.selectedDate = DateUtils.stringFromDate(date: today, format: "yyyy/MM/dd")
//        print(vc.selectedDate)
        vc.filterTask(for: vc.selectedDate)
        
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
        
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            var detail = detailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
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
        
        
        DatabaseManager.shared.registerData(newStudy: newStudy) { [weak self](success) in
            if success {
                self?.showAlert(title: "カレンダーに登録しました。", message: "忘れずに復習しましょう！")
                self?.titleTextField.text = ""
                self?.detailTextField.text = self?.detailPlaceholder
                self?.detailTextField.textColor = UIColor.lightGray
                return
            } else {
                self?.showAlert(title: "エラー", message: "タイトルを入力してください。")
                return
            }
        }
    }
    
    private func showAlert(title: String, message: String ){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        return
    }
    
    @IBAction func MoveToAboutVC(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "about") as? AboutViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension InputViewController: UIGestureRecognizerDelegate{
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            titleTextField.resignFirstResponder()
            detailTextField.resignFirstResponder()
        }
    }
    
}
