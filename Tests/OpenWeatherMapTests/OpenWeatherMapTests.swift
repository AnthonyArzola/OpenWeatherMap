import XCTest
@testable import OpenWeatherMap

final class OpenWeatherMapTests: XCTestCase {
    #warning("Warning - Please add your API here")
    let apiKey = ""

    func testInitFunction() {
        let service = OpenWeatherMapService(apiKey: apiKey)
        XCTAssertNotNil(service)
    }

    func testGetWeatherAtLocation() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather at location")
        let weatherService = OpenWeatherMapService(apiKey: apiKey)

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
        let weatherService = OpenWeatherMapService(apiKey: apiKey)
        
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
        let weatherService = OpenWeatherMapService(apiKey: apiKey)
        
        XCTAssertNotEqual(apiKey, "", "API Key is missing")
        weatherService.weatherAt(cityName: "Irvine,CA") { (success, cityWeather) in
            if success {
                print("Success! \(String(describing: cityWeather))")
                XCTAssertNotNil(cityWeather)
                XCTAssert(cityWeather?.weatherDescriptions?.count ?? 0 > 0)
                expectation.fulfill()
            } else {
                print("Failure!")
                XCTAssertNil(cityWeather)
                XCTFail()
                expectation.fulfill()
            }
        }
        
        self.wait(for: [expectation], timeout: 100.0)
    }
    
    func testWeatherForecastAtLocation() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather forecast by location")
        let weatherService = OpenWeatherMapService(apiKey: apiKey)
        
        XCTAssertNotEqual(apiKey, "", "API Key is missing")
        weatherService.weatherForecastAt(latitude: 37.7748, longitude: -122.4248, completion: { (success, forecast) in
            if success {
                print("Success! \(String(describing: forecast))")
                XCTAssertNotNil(forecast)
                XCTAssertTrue(forecast?.dailyForecast.count ?? 0 >= 0)
                expectation.fulfill()
            } else {
                print("Failure!")
                XCTAssertNil(forecast)
                XCTFail()
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
