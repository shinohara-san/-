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
    var label = ""
    var study: Study!
    
    var filteredStudyArray = [Study](){ //tableviewをカレンダータップごとに表示更新
        didSet {
            tableView?.reloadData()
        }
    }

    var selectedDate = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        
        let today = DateUtils.stringFromDate(date: Date(), format: "yyyy/MM/dd")
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
//            self?.calendar.reloadData() calendarとtableviewの同時更新はできない？
            self?.subjectsLabel.text = today
            self?.filterTask(for: today)
            //self?.calendar.appearance.borderRadius = 0 //四角
            self?.calendar.backgroundColor = UIColor(red: 240/255, green: 255/255, blue: 255/255, alpha: 1)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        filterTask(for: DateUtils.stringFromDate(date: Date(), format: "yyyy/MM/dd"))
        guard let today = Calendar.current.date(byAdding: .hour, value: 9, to: Date()) else {return}
        selectedDate = DateUtils.stringFromDate(date: today, format: "yyyy/MM/dd")
        filterTask(for: selectedDate)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.calendar.reloadData()
        }
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
        let study = filteredStudyArray[indexPath.row]
//        print(study.firstDay)
        cell.contentView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        if study.firstDayDone, study.secondDayDone, study.thirdDayDone, study.fourthDayDone, study.fifthDayDone {
            cell.textLabel?.text = "終了済: \(study.title)"
            cell.textLabel?.textColor = .red
            cell.detailTextLabel?.textColor = .red
        } else {
            cell.textLabel?.text = study.title
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
        }
        
        cell.detailTextLabel?.text = study.detail
        
        return cell
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
             
             let ac = UIAlertController(title: "削除しました", message: "\(study.title)", preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in
                 self.filterTask(for: self.selectedDate)
             }))
             present(ac, animated: true)
             
             try! realm.write({
                filteredStudyArray.remove(at: index)
                 realm.delete(study)
             })
            
            tableView.reloadData()
             calendar.reloadData()
            
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
        let num = filteredStudyArray.count
        return num
    }

    
}
