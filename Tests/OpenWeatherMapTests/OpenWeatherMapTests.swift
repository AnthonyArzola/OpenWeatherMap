import Combine
import XCTest
@testable import OpenWeatherMap

final class OpenWeatherMapTests: XCTestCase {
    #warning("Warning - Please add your API here")
    let apiKey = ""
    var weatherService: OpenWeatherMapService!
    
    func testInitFunction() {
        let service = OpenWeatherMapService(apiKey: apiKey)
        XCTAssertNotNil(service)
    }
    
    override func setUp() {
        super.setUp()
        XCTAssertNotEqual(apiKey, "", "API Key is missing")
        weatherService = OpenWeatherMapService(apiKey: apiKey)
    }
    
    // MARK: Closure tests
    func testGetWeatherAtCoordinatesSuccess() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather at lat/lon")

        weatherService.currentWeatherAt(latitude: 37.7748, longitude: -122.4248, completion: { (success: Bool, result: CityWeather?) -> Void in
            if (success) {
                XCTAssertNotNil(result)
                XCTAssertNotNil(result?.name)
                expectation.fulfill()
            } else {
                XCTFail("Failed unexpectedly")
                expectation.fulfill()
            }
        })
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWeatherForCitiesAtCircleSuccess() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather at location")
        
        weatherService.currentWeatherAt(latitude: 34.0429, longitude: -118.2449, resultCount: 15, completion: { (success: Bool, weather: CurrentCityWeatherResults?) -> Void in
            if (success) {
                XCTAssertNotNil(weather)
                XCTAssertNotNil(weather?.results)
                expectation.fulfill()
            } else {
                XCTFail("Failed unexpectedly")
                expectation.fulfill()
            }
        })
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWeatherByCityNameSuccess() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather by name")
        
        weatherService.currentWeatherAt(cityName: "Irvine,CA") { (success, cityWeather) in
            if success {
                XCTAssertNotNil(cityWeather)
                XCTAssert(cityWeather?.weatherDescriptions?.count ?? 0 > 0)
                expectation.fulfill()
            } else {
                XCTFail("Failed unexpectedly")
                expectation.fulfill()
            }
        }
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWeatherByCityNameFailure() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather by incorrect name")
        
        weatherService.currentWeatherAt(cityName: "FakeCity,CA") { (success, cityWeather) in
            if success {
                XCTFail("Unexpected success.")
                expectation.fulfill()
            } else {
                expectation.fulfill()
            }
        }
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWeatherForecastAtLocation() {
        let expectation = XCTestExpectation.init(description: "Retrieve current weather and forecast by location")
        
        weatherService.forecastWeatherAt(latitude: 37.7748, longitude: -122.4248, completion: { (success, forecast) in
            if success {
                XCTAssertNotNil(forecast)
                XCTAssertTrue(forecast?.cityForecast.count ?? 0 >= 0)
                expectation.fulfill()
            } else {
                XCTFail("Failed unexpectedly")
                expectation.fulfill()
            }
        })
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetCurrentWeatherAndForecastAtLocationSuccess() {
        let expectation = XCTestExpectation.init(description: "Retrieve current weather and forecast by location")
        let weatherService = OpenWeatherMapService(apiKey: apiKey)
        
        weatherService.currentWeatherAndForecastAt(latitude: 37.7748, longitude: -122.4248, completion: { (success, forecast) in
            if success {
                XCTAssertNotNil(forecast)
                XCTAssertTrue(forecast?.dailyForecast.count ?? 0 >= 0)
                expectation.fulfill()
            } else {
                XCTFail("Failed unexpectedly")
                expectation.fulfill()
            }
        })
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Combine tests
    func testCurrentWeatherAt() {
        let expectation = XCTestExpectation.init(description: "Retrieve current weather by location using Combine Publisher")
        var cancellable = Set<AnyCancellable>()
        let weatherPublisher = weatherService.currentWeatherAt(latitude: 37.7748, longitude: -122.4248)
        
        weatherPublisher.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("Failed unexpectedly. Error: \(error)")
                expectation.fulfill()
            }
        } receiveValue: { cityWeather in
            print(cityWeather)
            XCTAssertEqual(cityWeather.name.lowercased(), "San Francisco".lowercased())
            expectation.fulfill()
        }
        .store(in: &cancellable)
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Async tests
    
    @MainActor
    func testAsyncCurrentWeatherAt() async {
        do {
            let result = try await weatherService.currentWeatherAt(latitude: 37.7748, longitude: -122.4248)
            XCTAssertNotNil(result)
        } catch {
            XCTFail("\(error)")
        }
    }
}
