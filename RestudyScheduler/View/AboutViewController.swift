//
//  AboutViewController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/28.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }

}
