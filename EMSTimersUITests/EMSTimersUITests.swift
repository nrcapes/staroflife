//
//  EMSTimersUITests.swift
//  EMSTimersUITests
//
//  Created by Nelson Capes on 4/29/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

import XCTest

class EMSTimersUITests: XCTestCase {
        
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
        
        let app = XCUIApplication()
        let pressAnyKeyToContinueButton = XCUIApplication().alerts["Legal Notice"].collectionViews.buttons["Press any key to continue"]
        pressAnyKeyToContinueButton.tap()
        
        XCTAssertTrue(app.tables.element.cells.elementBoundByIndex(0).exists)
        XCTAssertEqual(app.tables.element.cells.elementBoundByIndex(0).label, "")
        app.tables.element.cells.elementBoundByIndex(0).tap()
        sleep(5)
        
        XCTAssertTrue(app.tables.element.cells.elementBoundByIndex(1).exists)
        XCTAssertEqual(app.tables.element.cells.elementBoundByIndex(1).label, "")
        app.tables.element.cells.elementBoundByIndex(1).tap()
        sleep(5)
        
        //XCTAssertTrue(app.tables.element.cells.elementBoundByIndex(2).exists)
       // XCTAssertEqual(app.tables.element.cells.elementBoundByIndex(2).label, "")
        //app.tables.element.cells.elementBoundByIndex(2).tap()
        //sleep(5)
        
        XCTAssertTrue(app.tables.element.cells.elementBoundByIndex(3).exists)
        XCTAssertEqual(app.tables.element.cells.elementBoundByIndex(3).label, "")
        app.tables.element.cells.elementBoundByIndex(3).tap()
        sleep(5)
        
        XCTAssertTrue(app.tables.element.cells.elementBoundByIndex(4).exists)
        XCTAssertEqual(app.tables.element.cells.elementBoundByIndex(4).label, "")
        app.tables.element.cells.elementBoundByIndex(4).tap()
        sleep(5)
        
        XCTAssertTrue(app.tables.element.cells.elementBoundByIndex(5).exists)
        XCTAssertEqual(app.tables.element.cells.elementBoundByIndex(5).label, "")
        app.tables.element.cells.elementBoundByIndex(5).tap()
        sleep(5)
        
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["In Service"].tap()
        sleep(5)
        
        tablesQuery.staticTexts["5 minute re-assess"].tap()
        app.alerts["5 minute re-assess?"].collectionViews.buttons["Yes"].tap()
        sleep(5)
        
        
        tablesQuery.staticTexts["15 minute re-assess"].tap()
        app.alerts["15 minute re-assess?"].collectionViews.buttons["Yes"].tap()
        sleep(5)
        
        
      //  app.navigationBars["EMS Timers Pro v2"].buttons["Stop"].tap()
        
        
        let yesButton = app.alerts["Finished with this patient?"].collectionViews.buttons["Yes"]
        yesButton.tap()
        
        
    }
    
}
