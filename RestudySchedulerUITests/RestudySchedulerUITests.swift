//
//  RestudySchedulerUITests.swift
//  RestudySchedulerUITests
//
//  Created by Yuki Shinohara on 2020/06/29.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import XCTest

class RestudySchedulerUITests: XCTestCase {

    func testExample() throws {
        // UI tests must launch the application that they test.
        
        let app = XCUIApplication()
        app.activate()
        let textField = app.textFields[" タイトル(必須)"]
        textField.tap()
        textField.tap()
        textField.tap()
        textField.tap()
        
        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        
        tKey.tap()
        
        let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        textView.tap()
        app/*@START_MENU_TOKEN@*/.keys["C"]/*[[".keyboards.keys[\"C\"]",".keys[\"C\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()
        tKey.tap()
        eKey.tap()
        nKey.tap()
        tKey.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let datePickersQuery = app.datePickers
        datePickersQuery/*@START_MENU_TOKEN@*/.pickerWheels["29"].press(forDuration: 0.5);/*[[".pickers.pickerWheels[\"29\"]",".tap()",".press(forDuration: 0.5);",".pickerWheels[\"29\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
//        datePickersQuery/*@START_MENU_TOKEN@*/.pickerWheels["30"]/*[[".pickers.pickerWheels[\"30\"]",".pickerWheels[\"30\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        app.buttons["登録"].tap()
        app.tabBars.buttons["カレンダー"].tap()
        
        
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
