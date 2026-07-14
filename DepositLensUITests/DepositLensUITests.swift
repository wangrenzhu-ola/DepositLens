import XCTest
final class DepositLensUITests: XCTestCase {
    func testCoreTabsLaunch() { let app = XCUIApplication(); app.launch(); XCTAssertTrue(app.tabBars.buttons["Sweep"].waitForExistence(timeout: 5)); XCTAssertTrue(app.tabBars.buttons["Review"].exists); XCTAssertTrue(app.tabBars.buttons["Privacy"].exists); XCTAssertTrue(app.staticTexts["Below kitchen sink"].exists) }
}
