import Foundation
import Combine

enum HttpMethodType: String {
    case GET
}

// MARK: - Base protocol for auth
public class OpenWeatherMapService: OpenWeatherMapAPI {
    // MARK: Properties
    private let baseUrl: String
    private(set) public var apiKey: String
    private let decoder = JSONDecoder()
    
    // MARK: Constructors
    public init(apiKey key: String) {
        if key.isEmpty {
            fatalError("API key required.")
        }
        baseUrl = "https://api.openweathermap.org/data/2.5"
        apiKey = key
    }
    
    // MARK: Private methods
    private func createUrl(endpoint: String, urlQueryItems: [URLQueryItem]?) -> URL? {
        var components = URLComponents(string: baseUrl)
        components?.path.append(endpoint)
        components?.queryItems = urlQueryItems
        return components?.url
    }
    
    private func createUrlRequest(url: URL, httpMethodType: HttpMethodType) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethodType.rawValue
        return urlRequest
    }
}

// MARK: - Closure support
extension OpenWeatherMapService {
    
    /// Gets current weather for geographic coordinates (`latitude`, `longitude`).
    public func currentWeatherAt(latitude: Double, longitude: Double, completion closure: @escaping (Bool, CityWeather?) -> Void) {
        Task {
            do {
                let result = try await self.currentWeatherAt(latitude: latitude, longitude: longitude)
                closure(true, result)
            } catch {
                closure(false, nil)
            }
        }
    }
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for number of cities defined by `resultCount`.
    /// The default number of cities is 10, the maximum is 50.
    public func currentWeatherAt(latitude: Double, longitude: Double, resultCount count: Int, completion closure: @escaping (Bool, CurrentCityWeatherResults?) -> Void) {
        Task {
            do {
                let result = try await self.currentWeatherAt(latitude: latitude, longitude: longitude, cityCount: count)
                closure(true, result)
            } catch {
                closure(false, nil)
            }
        }
    }

    /// Get current weather for specific city (e.g., "berkeley,ca").
    public func currentWeatherAt(cityName: String, completion closure: @escaping (Bool, CityWeather?) -> Void) {
        Task {
            do {
                let result = try await self.currentWeatherAt(cityName: cityName)
                closure(true, result)
            } catch {
                closure(false, nil)
            }
        }
    }
    
    /// Gets 5-day weather forecast with data every 3 hours for geographic coordinates.
    public func forecastWeatherAt(latitude: Double, longitude: Double, completion closure: @escaping (Bool, ForecastWeatherResults?) -> Void) {
        Task {
            do {
                let result = try await self.forecastWeatherAt(latitude: latitude, longitude: longitude)
                closure(true, result)
            } catch {
                closure(false, nil)
            }
        }
    }
}

// MARK: - Combine support
extension OpenWeatherMapService {
    
    /// Gets current weather for geographic coordinates (`latitude`, `longitude`).
    public func currentWeatherAt(latitude: Double, longitude: Double) -> AnyPublisher<CityWeather, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await self.currentWeatherAt(latitude: latitude, longitude: longitude)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for number of cities defined by `cityCount`.
    public func currentWeatherAt(latitude: Double, longitude: Double, cityCount: Int) -> AnyPublisher<CurrentCityWeatherResults, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await self.currentWeatherAt(latitude: latitude, longitude: longitude, cityCount: cityCount)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Get current weather for specific city (e.g., "berkeley,ca").
    public func currentWeatherAt(cityName: String) -> AnyPublisher<CityWeather, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await self.currentWeatherAt(cityName: cityName)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Gets 5-day weather forecast with data every 3 hours for geographic coordinates.
    public func forecastWeatherAt(latitude: Double, longitude: Double) -> AnyPublisher<ForecastWeatherResults, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await self.forecastWeatherAt(latitude: latitude, longitude: longitude)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Async-Await support
extension OpenWeatherMapService {
    
    // MARK: - Private helper
    private func performRequest<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        let result: (data: Data, response: URLResponse) = try await URLSession.shared.data(for: urlRequest)
        
        // Verify data was returned
        guard !result.data.isEmpty, let httpResponse = result.response as? HTTPURLResponse else {
            throw ApiError.missingData
        }
        // Verify valid status code
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
            throw ApiError.statusCode(httpResponse.statusCode)
        }
        
        // Attempt to decode
        return try decoder.decode(T.self, from: result.data)
    }
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for 10 cities.
    public func currentWeatherAt(latitude: Double, longitude: Double) async throws -> CityWeather {
        // API Example: GET http://api.openweathermap.org/data/2.5/find?lat=34.022&lon=-118.9&cnt=10&APPID={YOUR_API_KEY}
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else {
            throw ApiError.invalidUrl
        }
        
        // Create URL request
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        
        return try await performRequest(urlRequest: urlRequest)
    }
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for number of cities defined by `cityCount`.
    /// The default number of cities is 10, the maximum is 50.
    public func currentWeatherAt(latitude: Double, longitude: Double, cityCount: Int) async throws -> CurrentCityWeatherResults {
        // API Example: GET http://api.openweathermap.org/data/2.5/find?lat=34.02&lon=-118.9&cnt=10&APPID={YOUR_API_KEY}
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        urlQueryitems.append(URLQueryItem(name: "cnt", value: "\(cityCount)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        
        guard let url = createUrl(endpoint: "/find", urlQueryItems: urlQueryitems) else {
            throw ApiError.invalidUrl
        }
        
        // Create URL request
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        
        return try await performRequest(urlRequest: urlRequest)
    }
    
    /// Get current weather for specific city (e.g., "berkeley,ca").
    public func currentWeatherAt(cityName: String) async throws -> CityWeather {
        // API Examples:
        // GET api.openweathermap.org/data/2.5/weather?q={CityName}&appid={YOUR_API_KEY}
        // GET api.openweathermap.org/data/2.5/weather?q={CityName},{StateCode}&appid={YOUR_API_KEY}
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "q", value: "\(cityName)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else {
            throw ApiError.invalidUrl
        }
        
        // Create URL request
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        
        return try await performRequest(urlRequest: urlRequest)
    }
    
    /// Gets forecasted weather for geographic coordinates (`latitude`, `longitude`).
    public func forecastWeatherAt(latitude: Double, longitude: Double) async throws -> ForecastWeatherResults {
        // API example: GET http://api.openweathermap.org/data/2.5/forecast?lat=34.022&lon=-118.9&APPID={YOUR_API_KEY}
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
         
        guard let url = createUrl(endpoint: "/forecast", urlQueryItems: urlQueryitems) else {
            throw ApiError.invalidUrl
        }
    
        // Create URL request
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        
        return try await performRequest(urlRequest: urlRequest)
    }
    
}
