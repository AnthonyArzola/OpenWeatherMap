import Combine
import XCTest
@testable import OpenWeatherMap

final class OpenWeatherMapTests: XCTestCase {
    #warning("Warning - Please add your API here")
    let apiKey = ""
    var weatherService: OpenWeatherMapService!
    
    func testInit() {
        let service = OpenWeatherMapService(apiKey: apiKey)
        XCTAssertNotNil(service)
    }
    
    override func setUp() {
        super.setUp()
        XCTAssertNotEqual(apiKey, "", "API Key is missing")
        weatherService = OpenWeatherMapService(apiKey: apiKey)
    }
    
    // MARK: - Closure tests
    func test_closure_currentWeatherAt() {
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
    
    func test_closure_currentWeatherAt_with_count() {
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
    
    func test_closure_currentWeatherAt_by_city_name() {
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
    
    func test_closure_currentWeatherAt_by_city_name_failure() {
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
    
    func test_closure_forecastWeatherAt() {
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
    
    // MARK: - Combine tests
    func test_combine_currentWeatherAt() {
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
    
    func test_combine_currentWeatherAt_with_city_count() {
        let expectation = XCTestExpectation.init(description: "Retrieve weather for multiple cities using Combine Publisher")
        var cancellable = Set<AnyCancellable>()
        let weatherPublisher = weatherService.currentWeatherAt(latitude: 34.0429, longitude: -118.2449, cityCount: 15)
        
        weatherPublisher.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("Failed unexpectedly. Error: \(error)")
                expectation.fulfill()
            }
        } receiveValue: { cityWeatherResults in
            XCTAssertNotNil(cityWeatherResults)
            XCTAssertNotNil(cityWeatherResults.results)
            
            guard let results = cityWeatherResults.results else {
                XCTFail("Should not be nil")
                return
            }
            
            XCTAssertTrue(results.count > 0, "Should return at least one city")
            XCTAssertTrue(results.count <= 15, "Should not exceed requested count")
            expectation.fulfill()
        }
        .store(in: &cancellable)
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func test_combine_currentWeatherAt_by_city_name() {
        let expectation = XCTestExpectation.init(description: "Retrieve current weather by city name using Combine Publisher")
        var cancellable = Set<AnyCancellable>()
        let weatherPublisher = weatherService.currentWeatherAt(cityName: "San Francisco")
        
        weatherPublisher.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("Failed unexpectedly. Error: \(error)")
                expectation.fulfill()
            }
        } receiveValue: { cityWeather in
            XCTAssertNotNil(cityWeather)
            XCTAssertNotNil(cityWeather.name)
            XCTAssertTrue(cityWeather.weatherDescriptions?.count ?? 0 > 0, "Should have weather descriptions")
            expectation.fulfill()
        }
        .store(in: &cancellable)
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func test_combine_forecastWeatherAt() {
        let expectation = XCTestExpectation.init(description: "Retrieve forecast weather by location using Combine Publisher")
        var cancellable = Set<AnyCancellable>()
        let forecastPublisher = weatherService.forecastWeatherAt(latitude: 37.7748, longitude: -122.4248)
        
        forecastPublisher.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("Failed unexpectedly. Error: \(error)")
                expectation.fulfill()
            }
        } receiveValue: { forecastResults in
            XCTAssertNotNil(forecastResults)
            XCTAssertTrue(forecastResults.cityForecast.count > 0, "Should have forecast data")
            expectation.fulfill()
        }
        .store(in: &cancellable)
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Async tests
    
    @MainActor
    func test_async_currentWeatherAt() async {
        do {
            let result = try await weatherService.currentWeatherAt(latitude: 37.7748, longitude: -122.4248)
            XCTAssertNotNil(result)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    @MainActor
    func test_async_currentWeatherAt_with_city_count() async {
        do {
            let cityWeather = try await weatherService.currentWeatherAt(latitude: 34.0429, longitude: -118.2449, cityCount: 15)
            XCTAssertNotNil(cityWeather)
            XCTAssertNotNil(cityWeather.results)
            
            guard let results = cityWeather.results else {
                XCTFail("Should not be nil")
                return
            }
            
            XCTAssertTrue(results.count > 0, "Should return at least one city")
            XCTAssertTrue(results.count <= 15, "Should not exceed requested count")
        } catch {
            XCTFail("Failed unexpectedly. Error: \(error)")
        }
    }
    
    @MainActor
    func test_async_currentWeatherAt_by_city_name() async {
        do {
            let result = try await weatherService.currentWeatherAt(cityName: "Irvine,CA")
            XCTAssertNotNil(result)
            XCTAssertNotNil(result.name)
            XCTAssertTrue(result.weatherDescriptions?.count ?? 0 > 0, "Should have weather descriptions")
        } catch {
            XCTFail("Failed unexpectedly. Error: \(error)")
        }
    }
    
    @MainActor
    func test_async_currentWeatherAt_by_city_name_failure() async {
        do {
            let _ = try await weatherService.currentWeatherAt(cityName: "FakeCity,CA")
            XCTFail("Should have thrown an error for invalid city")
        } catch {
            // Expected to fail
            XCTAssertNotNil(error, "Should receive an error for invalid city name")
        }
    }
    
    @MainActor
    func test_async_forecastWeatherAt() async {
        do {
            let result = try await weatherService.forecastWeatherAt(latitude: 37.7748, longitude: -122.4248)
            XCTAssertNotNil(result)
            XCTAssertTrue(result.cityForecast.count > 0, "Forecast data should not be empty")
        } catch {
            XCTFail("Failed unexpectedly. Error: \(error)")
        }
    }
}
