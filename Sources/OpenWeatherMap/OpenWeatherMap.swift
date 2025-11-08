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
    
    /// Creates URL query items for API requests
    /// - Parameters:
    ///   - latitude: Optional latitude coordinate
    ///   - longitude: Optional longitude coordinate
    ///   - cityName: Optional city name
    ///   - cityCount: Optional number of cities to return
    /// - Returns: Array of URLQueryItem including API key
    private func createQueryItems(
        latitude: Double? = nil,
        longitude: Double? = nil,
        cityName: String? = nil,
        cityCount: Int? = nil
    ) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        
        if let lat = latitude {
            items.append(URLQueryItem(name: "lat", value: "\(lat)"))
        }
        if let lon = longitude {
            items.append(URLQueryItem(name: "lon", value: "\(lon)"))
        }
        if let name = cityName {
            items.append(URLQueryItem(name: "q", value: name))
        }
        if let count = cityCount {
            items.append(URLQueryItem(name: "cnt", value: "\(count)"))
        }
        
        // Always include API key
        items.append(URLQueryItem(name: "appid", value: apiKey))
        
        return items
    }
}

// MARK: - Closure support
extension OpenWeatherMapService {
    
    /// Gets current weather for geographic coordinates using closure-based API.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    ///   - completion: Closure called with Result containing CityWeather or Error
    public func currentWeatherAt(latitude: Double, longitude: Double, completion: @escaping (Result<CityWeather, Error>) -> Void) {
        Task {
            do {
                let result = try await self.currentWeatherAt(latitude: latitude, longitude: longitude)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Gets weather for multiple cities around specified coordinates using closure-based API.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    ///   - resultCount: Number of cities to return (default: 10, maximum: 50)
    ///   - completion: Closure called with Result containing CurrentCityWeatherResults or Error
    public func currentWeatherAt(latitude: Double, longitude: Double, resultCount count: Int, completion: @escaping (Result<CurrentCityWeatherResults, Error>) -> Void) {
        Task {
            do {
                let result = try await self.currentWeatherAt(latitude: latitude, longitude: longitude, cityCount: count)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Gets current weather for a specific city using closure-based API.
    /// - Parameters:
    ///   - cityName: City name (e.g., "San Francisco,CA" or "London,UK")
    ///   - completion: Closure called with Result containing CityWeather or Error
    public func currentWeatherAt(cityName: String, completion: @escaping (Result<CityWeather, Error>) -> Void) {
        Task {
            do {
                let result = try await self.currentWeatherAt(cityName: cityName)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Gets 5-day weather forecast with data every 3 hours using closure-based API.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    ///   - completion: Closure called with Result containing ForecastWeatherResults or Error
    public func forecastWeatherAt(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastWeatherResults, Error>) -> Void) {
        Task {
            do {
                let result = try await self.forecastWeatherAt(latitude: latitude, longitude: longitude)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Combine support
extension OpenWeatherMapService {
    
    /// Gets current weather for geographic coordinates using Combine.
    /// Results are delivered on the main thread.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    /// - Returns: Publisher that emits CityWeather or Error
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
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    /// Gets weather for multiple cities around specified coordinates using Combine.
    /// Results are delivered on the main thread.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    ///   - cityCount: Number of cities to return (default: 10, maximum: 50)
    ///   - Returns: Publisher that emits CurrentCityWeatherResults or Error
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
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    /// Gets current weather for a specific city using Combine.
    /// Results are delivered on the main thread.
    /// - Parameter cityName: City name (e.g., "San Francisco,CA" or "London,UK")
    /// - Returns: Publisher that emits CityWeather or Error
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
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    /// Gets 5-day weather forecast with data every 3 hours using Combine.
    /// Results are delivered on the main thread.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    /// - Returns: Publisher that emits ForecastWeatherResults or Error
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
        .receive(on: DispatchQueue.main)
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
        do {
            return try decoder.decode(T.self, from: result.data)
        } catch {
            throw ApiError.decoding(error)
        }
    }
    
    /// Gets current weather for geographic coordinates.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    /// - Returns: CityWeather object containing current weather data
    /// - Throws: ApiError.invalidUrl if URL construction fails
    ///           ApiError.missingData if no data received
    ///           ApiError.statusCode if HTTP status code is not 2xx
    ///           ApiError.decoding if response cannot be decoded
    public func currentWeatherAt(latitude: Double, longitude: Double) async throws -> CityWeather {
        let queryItems = createQueryItems(latitude: latitude, longitude: longitude)
        
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: queryItems) else {
            throw ApiError.invalidUrl
        }
        
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        return try await performRequest(urlRequest: urlRequest)
    }
    
    /// Gets weather for multiple cities around specified coordinates.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    ///   - cityCount: Number of cities to return (default: 10, maximum: 50)
    /// - Returns: CurrentCityWeatherResults containing weather for multiple cities
    /// - Throws: ApiError.invalidUrl if URL construction fails
    ///           ApiError.missingData if no data received
    ///           ApiError.statusCode if HTTP status code is not 2xx
    ///           ApiError.decoding if response cannot be decoded
    public func currentWeatherAt(latitude: Double, longitude: Double, cityCount: Int) async throws -> CurrentCityWeatherResults {
        let queryItems = createQueryItems(latitude: latitude, longitude: longitude, cityCount: cityCount)
        
        guard let url = createUrl(endpoint: "/find", urlQueryItems: queryItems) else {
            throw ApiError.invalidUrl
        }
        
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        return try await performRequest(urlRequest: urlRequest)
    }
    
    /// Gets current weather for a specific city.
    /// - Parameter cityName: City name (e.g., "San Francisco,CA" or "London,UK")
    /// - Returns: CityWeather object containing current weather data
    /// - Throws: ApiError.invalidUrl if URL construction fails
    ///           ApiError.missingData if no data received
    ///           ApiError.statusCode if HTTP status code is not 2xx (e.g., 404 for city not found)
    ///           ApiError.decoding if response cannot be decoded
    public func currentWeatherAt(cityName: String) async throws -> CityWeather {
        let queryItems = createQueryItems(cityName: cityName)
        
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: queryItems) else {
            throw ApiError.invalidUrl
        }
        
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        return try await performRequest(urlRequest: urlRequest)
    }
    
    /// Gets 5-day weather forecast with data every 3 hours for specified coordinates.
    /// - Parameters:
    ///   - latitude: Latitude coordinate (e.g., 37.7749)
    ///   - longitude: Longitude coordinate (e.g., -122.4194)
    /// - Returns: ForecastWeatherResults containing forecast data
    /// - Throws: ApiError.invalidUrl if URL construction fails
    ///           ApiError.missingData if no data received
    ///           ApiError.statusCode if HTTP status code is not 2xx
    ///           ApiError.decoding if response cannot be decoded
    public func forecastWeatherAt(latitude: Double, longitude: Double) async throws -> ForecastWeatherResults {
        let queryItems = createQueryItems(latitude: latitude, longitude: longitude)
        
        guard let url = createUrl(endpoint: "/forecast", urlQueryItems: queryItems) else {
            throw ApiError.invalidUrl
        }
    
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        return try await performRequest(urlRequest: urlRequest)
    }
    
}
