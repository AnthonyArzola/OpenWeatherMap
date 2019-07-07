import XCTest
@testable import OpenWeatherMap

final class OpenWeatherMapTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OpenWeatherMap().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
