//
//  Add Patient and Assess.swift
//  EMS Timers Professional
//
//  Created by Nelson Capes on 4/30/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

import XCTest

class Add_Patient_and_Assess: XCTestCase {
        
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
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // This test is for navigation from the initial splash screen to pressing the Contact row, going to the patient data controller,
        // pressing the Assess button, entering a systolic BP of 120, then clicking all the way back to the initial screen.
        
        let app = XCUIApplication()
        app.alerts["Legal Notice"].collectionViews.buttons["Press any key to continue"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        
        tablesQuery.staticTexts["Patient Contact Time"].exists
        tablesQuery.staticTexts["Patient Contact Time"].tap()
        
        let yesButton = app.alerts["Enter Patient Data?"].collectionViews.buttons["Yes"]
        XCTAssert(yesButton.exists, "Enter Data button not found")
        yesButton.tap()
        
        XCTAssert(tablesQuery2.buttons["Assess"].exists, "Assess Button not found")
        tablesQuery2.buttons["Assess"].tap()
        
        
        
        tablesQuery.textFields["120"].tap()
        tablesQuery2.cells.containing(.staticText, identifier:"Systolic BP").children(matching: .textField).element
        
        app.buttons["Return"].tap()
        //app.typeText("\n")
        app.navigationBars["NRCAssessmentView"].buttons["Done"].tap()
        app.navigationBars["NRCPatientDataTableView"].buttons["Done"].tap()
        
    }
    
}
