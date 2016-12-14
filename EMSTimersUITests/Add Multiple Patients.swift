//
//  Add Multiple Patients.swift
//  EMS Timers Professional
//
//  Created by Nelson Capes on 5/1/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

import XCTest

class Add_Multiple_Patients: XCTestCase {
    
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
        
        
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        app.alerts["Legal Notice"].collectionViews.buttons["Press any key to continue"].tap()
        
        // patient #1
        let patientContactTimeStaticText = app.tables.staticTexts["Patient Contact Time"]
        patientContactTimeStaticText.tap()
        let yesButton = app.alerts["Enter Patient Data?"].collectionViews.buttons["Yes"]
        yesButton.tap()
        let doneButton = app.navigationBars["NRCPatientDataTableView"].buttons["Done"]
        doneButton.tap()
        app.navigationBars["EMS Timers Pro v2"].buttons["Stop"].tap()
        let yesButton2 = app.alerts["Finished with this patient?"].collectionViews.buttons["Yes"]
        yesButton2.tap()
        patientContactTimeStaticText.tap()
        yesButton.tap()
        doneButton.tap()
        
        // patient #2
        let patientContactTimeStaticText1 = app.tables.staticTexts["Patient Contact Time"]
        patientContactTimeStaticText1.tap()
        let yesButton3 = app.alerts["Enter Patient Data?"].collectionViews.buttons["Yes"]
        yesButton3.tap()
        let doneButton1 = app.navigationBars["NRCPatientDataTableView"].buttons["Done"]
        doneButton1.tap()
        app.navigationBars["EMS Timers Pro v2"].buttons["Stop"].tap()
        let yesButton4 = app.alerts["Finished with this patient?"].collectionViews.buttons["Yes"]
        yesButton4.tap()
        patientContactTimeStaticText.tap()
        yesButton.tap()
        doneButton.tap()
 
    }

    
}
