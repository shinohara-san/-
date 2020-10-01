//
//  MyTabBarController.swift
//  RestudyScheduler
//
//  Created by Yuki Shinohara on 2020/06/24.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UITabBar.appearance().tintColor = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 1.0)

        // 背景色
        UITabBar.appearance().barTintColor = UIColor(red: 51/255, green: 51/255, blue: 255/255, alpha: 1.0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
