import Foundation
import Combine

enum HttpMethodType: String {
    case GET
}

// MARK: - Base protocol for auth
public class OpenWeatherMapService: OpenWeatherMapAPI {
    // MARK: Properties
    private let session: URLSession
    private let baseUrl: String
    private(set) public var apiKey: String
    private let decoder = JSONDecoder()
    
    // MARK: Constructors
    public init(apiKey key: String) {
        if key.isEmpty {
            fatalError("API key required.")
        }
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
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
        // API Example: http://api.openweathermap.org/data/2.5/weather?lat=34.02&lon=-118.9&APPID={YOUR_API_KEY}
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else { return }
        // Create URL request
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        // Create task
        let task = createRequestAndDecodeUrlSessionDataTask(urlRequest: request, completion: closure)
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for number of cities defined by `resultCount`.
    /// The default number of cities is 10, the maximum is 50.
    public func currentWeatherAt(latitude: Double, longitude: Double, resultCount count: Int, completion closure: @escaping (Bool, CurrentCityWeatherResults?) -> Void) {
        // API Example: GET http://api.openweathermap.org/data/2.5/find?lat=34.02&lon=-118.9&cnt=10&APPID={YOUR_API_KEY}
                
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        urlQueryitems.append(URLQueryItem(name: "cnt", value: "\(count)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        guard let url = createUrl(endpoint: "/find", urlQueryItems: urlQueryitems) else { return }
        // Create URL request
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        // Create task
        let task = createRequestAndDecodeUrlSessionDataTask(urlRequest: request, completion: closure)
        task.resume()
    }

    /// Get current weather for specific city (e.g., "berkeley,ca").
    public func currentWeatherAt(cityName: String, completion closure: @escaping (Bool, CityWeather?) -> Void) {
        /// API Examples:
        /// GET api.openweathermap.org/data/2.5/weather?q={CityName}&appid={YOUR_API_KEY}
        /// GET api.openweathermap.org/data/2.5/weather?q={CityName},{StateCode}&appid={YOUR_API_KEY}
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "q", value: "\(cityName)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else { return }
        // Create URL request
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        // Create URL request
        let task = createRequestAndDecodeUrlSessionDataTask(urlRequest: request, completion: closure)
        task.resume()
    }
    
    /// Gets 5-day weather forecast with data every 3 hours for geographic coordinates.
    public func forecastWeatherAt(latitude: Double, longitude: Double, completion closure: @escaping (Bool, ForecastWeatherResults?) -> Void) {
        // API Example: GET http://api.openweathermap.org/data/2.5/forecast?lat=34.02&lon=-118.9&APPID=
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        
        guard let url = createUrl(endpoint: "/forecast", urlQueryItems: urlQueryitems) else { return }
        // Create URL request
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        // Create task
        let task = createRequestAndDecodeUrlSessionDataTask(urlRequest: request, completion: closure)
        task.resume()
    }
    
    // MARK: - Private methods
    private func createRequestAndDecodeUrlSessionDataTask<T: Decodable>(urlRequest: URLRequest, completion closure: @escaping (Bool, T?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let self = self else {
                closure(false, nil)
                return
            }
            
            if (error == nil) {
                // Handle response
                guard let data = data else {
                    closure(false, nil)
                    return
                }
                
                do {
                    let weather = try self.decoder.decode(T.self, from: data)
                    // Success
                    closure(true, weather)
                } catch let error {
                    // Decoding error
                    print("Unable to decode. Error is: \(error)")
                    closure(false, nil)
                }
            } else {
                // Failure
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL request failed with code:\(statusCode) and error:\(error!.localizedDescription)")
                closure(false, nil)
            }
        }
    }
}

// MARK: - Combine support
extension OpenWeatherMapService {
    
    /// Gets current weather for geographic coordinates (`latitude`, `longitude`).
    public func currentWeatherAt(latitude: Double, longitude: Double) -> AnyPublisher<CityWeather, Error> {
        // API Example: http://api.openweathermap.org/data/2.5/weather?lat=34.02&lon=-118.17&APPID={YOUR_API_KEY}
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else {
            return Fail(error: URLError(URLError.unsupportedURL)).eraseToAnyPublisher()
        }
        
        // Create URL request
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        
        // Create publisher that wraps URL Session Data Task and return decoded entity or error
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw ApiError.statusCode((response as? HTTPURLResponse)?.statusCode ?? 500)
                }
                return data
        }
        .decode(type: CityWeather.self, decoder: decoder)
        .eraseToAnyPublisher()
    }
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for number of cities defined by `cityCount`.
    public func currentWeatherAt(latitude: Double, longitude: Double, cityCount: Int) -> AnyPublisher<CurrentCityWeatherResults, Error> {
        // API Example: GET http://api.openweathermap.org/data/2.5/find?lat=34.022&lon=-118.9&cnt=10&APPID={YOUR_API_KEY}
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        urlQueryitems.append(URLQueryItem(name: "cnt", value: "\(cityCount)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: apiKey))
        guard let url = createUrl(endpoint: "/find", urlQueryItems: urlQueryitems) else {
            return Fail(error: URLError(URLError.unsupportedURL)).eraseToAnyPublisher()
        }
        
        // Create URL request
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        
        // Create publisher that wraps URL Session Data Task
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw ApiError.statusCode((response as? HTTPURLResponse)?.statusCode ?? 500)
                }
                return data
        }
        .decode(type: CurrentCityWeatherResults.self, decoder: decoder)
        .eraseToAnyPublisher()
    }
}

// MARK: - Async-Await support
extension OpenWeatherMapService {
    
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
        
        var task: (data: Data, response: URLResponse)
        task = try await session.data(for: urlRequest, delegate: nil)
        
        // Verify data was returned
        guard !task.data.isEmpty, let httpResponse = task.response as? HTTPURLResponse else {
            throw ApiError.missingData
        }
        // Verify valid status code
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
            throw ApiError.statusCode(httpResponse.statusCode)
        }
        
        return try decoder.decode(CityWeather.self, from: task.data)
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
        
        var task: (data: Data, response: URLResponse)
        task = try await session.data(for: urlRequest, delegate: nil)
        
        // Verify data was returned
        guard !task.data.isEmpty, let httpResponse = task.response as? HTTPURLResponse else {
            throw ApiError.missingData
        }
        // Verify valid status code
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
            throw ApiError.statusCode(httpResponse.statusCode)
        }
        
        return try decoder.decode(ForecastWeatherResults.self, from: task.data)
    }
    
}
