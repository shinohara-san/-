//
//  RestudySchedulerTests.swift
//  RestudySchedulerTests
//
//  Created by Yuki Shinohara on 2020/06/29.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import XCTest
@testable import RestudyScheduler

class RestudySchedulerTests: XCTestCase {
    
    let dateUtil = DateUtils() //インスタンスを作る

    func testDateUtils(){
        let today = DateUtils.stringFromDate(date: Date(), format: "yyyy/MM/dd")
        XCTAssertEqual(today, "2020/06/29")
    }

}
