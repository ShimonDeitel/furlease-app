import XCTest

final class FurleaseUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAddEntryFlow() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addEntryButton"].tap()
        let field1 = app.textFields["field1TextField"]
        XCTAssertTrue(field1.waitForExistence(timeout: 3))
        field1.tap()
        field1.typeText("UI Test Entry")
        app.buttons["saveEntryButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Entry"].waitForExistence(timeout: 3))
    }

    func testFreeLimitTriggersPaywall() throws {
        let app = XCUIApplication()
        app.launch()
        for i in 0..<45 {
            app.buttons["addEntryButton"].tap()
            let field1 = app.textFields["field1TextField"]
            if field1.waitForExistence(timeout: 2) {
                field1.tap()
                field1.typeText("Entry \(i)")
                app.buttons["saveEntryButton"].tap()
            } else {
                break
            }
        }
        XCTAssertTrue(app.buttons["unlockProButton"].waitForExistence(timeout: 3))
    }

    func testKeyboardDismissOnTapOutside() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addEntryButton"].tap()
        let field1 = app.textFields["field1TextField"]
        XCTAssertTrue(field1.waitForExistence(timeout: 3))
        field1.tap()
        field1.typeText("Dismiss Test")
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.firstMatch.tap()
        XCTAssertFalse(app.keyboards.element.exists)
    }

    func testSettingsOpens() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 3))
        app.buttons["settingsDoneButton"].tap()
    }

    func testCancelDoesNotAddEntry() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addEntryButton"].tap()
        app.buttons["cancelButton"].tap()
        XCTAssertFalse(app.staticTexts["Uncommitted Entry"].exists)
    }
}
