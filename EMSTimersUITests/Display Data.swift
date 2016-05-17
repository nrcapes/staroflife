//
//  Display Data.swift
//  EMS Timers Professional
//
//  Created by Nelson Capes on 4/30/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

import XCTest

class Display_Data: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.alerts["Legal Notice"].collectionViews.buttons["Press any key to continue"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        //tablesQuery.staticTexts["At Hospital"].tap()
        tablesQuery2.buttons["Show Data"].tap()
        XCTAssertTrue(tablesQuery.staticTexts.elementBoundByIndex(0).exists)
        tablesQuery.staticTexts.elementBoundByIndex(0).tap()
        XCTAssertTrue(tablesQuery2.buttons["Assessments"].exists)
        tablesQuery2.buttons["Assessments"].tap()
        XCTAssertTrue(tablesQuery.staticTexts.elementBoundByIndex(0).exists)
        tablesQuery.staticTexts.elementBoundByIndex(0).tap()
        tablesQuery2.buttons["Medical History"].tap()
        
        let doneButton = app.navigationBars.buttons["Done"]
        doneButton.tap()
        doneButton.tap()
        doneButton.tap()
        doneButton.tap()
        app.navigationBars["Contact Times"].buttons["Done"].tap()
        
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    }

