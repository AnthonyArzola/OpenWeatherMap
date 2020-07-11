import XCTest
@testable import OpenWeatherMap

final class OpenWeatherMapTests: XCTestCase {
    #warning("Warning - Please add your API here")
    let apiKey = ""

    func testInitFunction() {
        let service = OpenWeatherMap(apiKey: apiKey)
        XCTAssertNotNil(service)
    }

    func testGetWeatherAtLocation() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather at location")
        let weatherService = OpenWeatherMap(apiKey: apiKey)

        XCTAssertNotEqual(apiKey, "", "API Key is missing")

        weatherService.weatherAt(latitude: 37.7748, longitude: -122.4248, completion: { (success: Bool, results: CityWeather?) -> Void in
            if (success) {
                print("Success! \(String(describing: results))")
                XCTAssertNotNil(results)
                XCTAssertNotNil(results?.name)
                expectation.fulfill()
            } else {
                print("Failure!")
                XCTAssertNil(results)
                expectation.fulfill()
            }
        })
        
        self.wait(for: [expectation], timeout: 100.0)
    }
    
    func testGetCitiesAtCircle() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather at location")
        let weatherService = OpenWeatherMap(apiKey: apiKey)
        
        XCTAssertNotEqual(apiKey, "", "API Key is missing")
        weatherService.weatherAt(latitude: 34.0429, longitude: -118.2449, resultCount: 15, completion: { (success: Bool, weather: CityWeatherList?) -> Void in
            if (success) {
                print("Success! \(String(describing: weather))")
                XCTAssertNotNil(weather)
                XCTAssertNotNil(weather?.results)
                expectation.fulfill()
            } else {
                print("Failure!")
                XCTAssertNil(weather)
                expectation.fulfill()
            }
        })
        
        self.wait(for: [expectation], timeout: 100.0)
    }
    
    func testGetWeatherByName() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather by name")
        let weatherService = OpenWeatherMap(apiKey: apiKey)
        
        XCTAssertNotEqual(apiKey, "", "API Key is missing")
        weatherService.weatherAt(cityName: "Irvine,CA") { (success, weather) in
            if success {
                print("Success! \(String(describing: weather))")
                XCTAssertNotNil(weather)
                XCTAssertNotNil(weather?.results)
                expectation.fulfill()
            } else {
                print("Failure!")
                XCTAssertNil(weather)
                expectation.fulfill()
            }
        }
        
        self.wait(for: [expectation], timeout: 100.0)
    }
    
    static var allTests = [
        ("testInitFunction", testInitFunction),
        ("testGetWeatherAtLocation", testGetWeatherAtLocation),
        ("testGetCitiesAtCircle", testGetCitiesAtCircle),
    ]
}
