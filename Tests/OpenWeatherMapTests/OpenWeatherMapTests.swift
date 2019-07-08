import XCTest
@testable import OpenWeatherMap

final class OpenWeatherMapTests: XCTestCase {
    
    func testInitFunction() {
        let service = OpenWeatherMap.init()
        XCTAssertNotNil(service)
    }
    
    func testGetWeatherAtLocation() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather at location")
        #warning("Warning - Please add your API here")
        let apiKey = ""
        let weatherService = OpenWeatherMap.init()
        
        XCTAssertNotEqual(apiKey, "", "API Key is missing")
        
        weatherService.weatherAt(latitude: 37.7748, longitude: -122.4248, apiKey: apiKey, completion: { (success: Bool, results: WeatherResults?) -> Void in
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
        #warning("Warning - Please add your API here")
        let apiKey = ""
        let weatherService = OpenWeatherMap.init()
        
        XCTAssertNotEqual(apiKey, "", "API Key is missing")
        weatherService.weatherAt(latitude: 34.0429, longitude: -118.2449, resultCount: 15, apiKey: apiKey, completion: { (success: Bool, weather: WeatherList?) -> Void in
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
    
    static var allTests = [
        ("testInitFunction", testInitFunction),
        ("testGetWeatherAtLocation", testGetWeatherAtLocation),
        ("testGetCitiesAtCircle", testGetCitiesAtCircle),
    ]
}
