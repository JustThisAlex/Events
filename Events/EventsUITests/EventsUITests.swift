//
//  EventsUITests.swift
//  EventsUITests
//
//  Created by Alexander Supe on 05.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import XCTest

class EventsUITests: XCTestCase {
    func testRegister() {
        let app = XCUIApplication()
        app.launch()
        addUIInterruptionMonitor(withDescription: "System Dialog") {alert -> Bool in
          alert.buttons["Allow"].tap()
          return true
        }
        app.tabBars.buttons["Events"].tap()
        app.navigationBars["Events"].buttons["Test Login"].tap()
        app.buttons["Next"].tap()
        app.textFields.element(boundBy: 0).tap()
        app.textFields.element(boundBy: 0).typeText("end")
        app.buttons["continue"].tap()
        app.sheets["Please select your address"].scrollViews.otherElements.buttons.element(boundBy: 0).tap()
        app.buttons["Sign Up"].tap()
        app.textFields["email"].tap()
        let randomMail = String(Int.random(in: 10000...999999))
        app.textFields["email"].typeText(randomMail)
        app.textFields["username"].tap()
        app.textFields["username"].typeText(String(Int.random(in: 10000...999999)))
        app.buttons["Return"].tap()
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("test")
        app.buttons["Return"].tap()
        app.buttons.containing(.staticText, identifier: "Sign Up").element.tap()
        app.buttons["Start"].tap()
        app.tabBars.buttons["Settings"].tap()
        XCTAssert(app.staticTexts[randomMail].exists)
    }
    func testLogin() {
        let app = XCUIApplication()
        app.launch()
        addUIInterruptionMonitor(withDescription: "System Dialog") { alert -> Bool in
          alert.buttons["Allow"].tap()
          return true
        }
        app.tabBars.buttons["Events"].tap()
        app.navigationBars["Events"].buttons["Test Login"].tap()
        app.buttons["Next"].tap()
        app.textFields.element(boundBy: 0).tap()
        app.textFields.element(boundBy: 0).typeText("end")
        app.buttons["continue"].tap()
        app.sheets["Please select your address"].scrollViews.otherElements.buttons.element(boundBy: 0).tap()
        app.textFields["email"].tap()
        app.textFields["email"].typeText("test")
        app.buttons["Return"].tap()
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("test")
        app.buttons.containing(.staticText, identifier: "Login").element.tap()
        app.buttons["Start"].tap()
        app.tabBars.buttons["Settings"].tap()
        XCTAssert(app.staticTexts["test"].exists)
    }

    func testTempChange() {
        let app = XCUIApplication()
        app.launch()
        let temp = app.staticTexts.element(boundBy: 1)
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons.element(boundBy: 0).tap()
        tabBarsQuery.buttons["End"].tap()
        XCTAssertFalse(app.staticTexts.element(boundBy: 1) == temp)
    }

    func testTabbar() {
        let app = XCUIApplication()
        app.launch()
        let first = app.staticTexts.element(boundBy: 0)
        XCUIApplication().tabBars.buttons["Events"].tap()
        XCTAssertFalse(app.staticTexts.element(boundBy: 0) == first)
    }

    func testLogout() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Settings"].tap()
        app.staticTexts.element(boundBy: 2).tap()
        app.buttons["Log out"].tap()
        sleep(1)
        XCTAssert(app.buttons["Sign In"].exists)

    }

}
