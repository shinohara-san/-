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

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "科目: \(study.title)"
        dateLabel.text = "初回学習日: \(study.date)"
        detailLabel.text = "詳細: \(study.detail)"
        firstDay.text = "第一回復習日: \(study.firstDay)"
        secondDay.text = "第二回復習日: \(study.secondDay)"
        thirdDay.text = "第三回復習日: \(study.thirdDay)"
        fourthDay.text = "第四回復習日: \(study.forthDay)"
        fifthDay.text = "第五回復習日: \(study.fifthDay)"
    }
}
