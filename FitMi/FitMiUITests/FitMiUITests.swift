//
//  FitMiUITests.swift
//  FitMiUITests
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import XCTest

class FitMiUITests: XCTestCase {
        
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
		app.otherElements.containing(.image, identifier:"icon").element.tap()
		app.buttons["home goal"].tap()
		app.buttons["EDIT GOAL"].tap()
		app.buttons["DONE"].tap()
		
		let dismissButton = app.buttons["DISMISS"]
		dismissButton.tap()
		
		let element = app.otherElements.containing(.button, identifier:"=").children(matching: .other).element.children(matching: .other).element(boundBy: 1)
		element.tap()
		element.press(forDuration: 0.9);
		element.tap()
		element.tap()
		element.tap()
		element.tap()
		element.tap()
		element.tap()
		element.tap()
		element.press(forDuration: 0.4);
		app.buttons["home booth"].tap()
		
		let tablesQuery = app.tables
		tablesQuery.staticTexts["Polar Bear"].tap()
		tablesQuery.staticTexts["Brown Bear"].tap()
		dismissButton.tap()
    }
    
}
