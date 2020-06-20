//
//  ListViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var subjectsLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var doneResult = false
    
    var filteredStudyArray = [Study](){ //tableviewをカレンダータップごとに表示更新
        didSet {
            tableView?.reloadData()
        }
    }
    
    var num = 0
    
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.borderRadius = 0 //資格
        
        let today = DateUtils.stringFromDate(date: Date(), format: "yyyy/MM/dd")
        self.subjectsLabel.text = today
        
        DispatchQueue.main.async {
            self.filterTask(for: today)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd")
        subjectsLabel.text = selectedDate
        filterTask(for: selectedDate)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStudyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(didChangeSwitch), for: .valueChanged)
        
        
        cell.detailTextLabel?.text = filteredStudyArray[indexPath.row].detail
        cell.textLabel?.text = filteredStudyArray[indexPath.row].title
        
//        mySwitch.isOn = filteredStudyArray[indexPath.row].firstDayDone
        
        
        mySwitch.isOn = getCorrectDayDone(index: indexPath)
        
        cell.accessoryView = mySwitch
        return cell
    }
    
    @objc func didChangeSwitch(_ sender: UISwitch){
           if sender.isOn{
               print("completed")
           } else {
               print("not completed yet")
           }
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let study = filteredStudyArray[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.study = study
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let realm = try! Realm()
            let studies = realm.objects(Study.self)
            let study = studies[indexPath.row]
            guard let index = filteredStudyArray.firstIndex(of: study) else { return }
            filteredStudyArray.remove(at: index)
            
            try! realm.write({
                realm.delete(study)
            })
            
            calendar.reloadData()
            ///応急処置
            let ac = UIAlertController(title: "削除しました", message: "\(study.title)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in
                self.filterTask(for: self.selectedDate)
            }))
            present(ac, animated: true)
        }
    }
    
    func filterTask(for day: String){
        let realm = try! Realm()
        let filteredStudyResult = realm.objects(Study.self)
            .filter("firstDay = '\(day)' OR secondDay = '\(day)' OR thirdDay = '\(day)' OR fourthDay = '\(day)' OR fifthDay = '\(day)'")
        filteredStudyArray = Array(filteredStudyResult) //RealmのResultをArrayに変換
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
        let filteredDate = DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd")
        filterTask(for: filteredDate)
        num = filteredStudyArray.count
        return num
    }
    
    //   selectedDateと同じものをfilteredStudyArray[indexPath.row]のfirst〜fifthの中でループして、同じだったらその名前と同じやつのdaydoneを代入
    func getCorrectDayDone(index: IndexPath) -> Bool {
        let task = filteredStudyArray[index.row]
        var dayArray = [String]()
        dayArray.append(task.firstDay)
        dayArray.append(task.secondDay)
        dayArray.append(task.thirdDay)
        dayArray.append(task.fourthDay)
        dayArray.append(task.fifthDay)
//        print(dayArray)
        
        dayArray.forEach{_ in
            if dayArray[0] == selectedDate {
                doneResult = task.firstDayDone
            } else if dayArray[1] == selectedDate{
                doneResult = task.secondDayDone
            } else if dayArray[2] == selectedDate{
                doneResult = task.thirdDayDone
            } else if dayArray[3] == selectedDate{
                doneResult = task.fourthDayDone
            } else if dayArray[4] == selectedDate{
                doneResult = task.fifthDayDone
            }
            
        }
        
        return doneResult
    }
    
}
