import Foundation
import Combine

enum HttpMethodType: String {
    case GET
}

public class OpenWeatherMapService {
    // MARK: - Properties
    private let session: URLSession
    private let baseUrl: String
    private (set) var apiKey: String?
    
    // MARK: - Constructors
    public init(apiKey key: String) {
        if key.isEmpty {
            fatalError("API key required.")
        }
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        baseUrl = "https://api.openweathermap.org/data/2.5"
        apiKey = key
    }
    
    // MARK: - Public methods (Closure based)
    
    /**
     Retrieves weather at specified point (`latitude`, `longitude`).
     */
    public func weatherAt(latitude lat: Double, longitude long: Double, completion closure: @escaping (Bool, CityWeather?) -> Void) {
        // API Example: http://api.openweathermap.org/data/2.5/weather?lat=34.02&lon=-118.17&APPID={YOUR_API_KEY}
        guard let key = apiKey else { return }
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(long)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else { return }
        // Create URL request
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        // Create task
        let task = createRequestAndDecodeUrlSessionDataTask(urlRequest: request, completion: closure)
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    /**
     Creates circle around specified point (`latitude`, `longitude`) and returns weather for expected number of cities defined by `resultCount`.
     The default number of cities is 10, the maximum is 50.
     */
    public func weatherAt(latitude lat: Double, longitude long: Double, resultCount count: Int, completion closure: @escaping (Bool, CityWeatherList?) -> Void) {
        // API Example: GET http://api.openweathermap.org/data/2.5/find?lat=34.022&lon=-118.9&cnt=10&APPID={YOUR_API_KEY}
        guard let key = apiKey else { return }
                
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(long)"))
        urlQueryitems.append(URLQueryItem(name: "cnt", value: "\(count)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        guard let url = createUrl(endpoint: "/find", urlQueryItems: urlQueryitems) else { return }
        // Create URL request
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        // Create task
        let task = createRequestAndDecodeUrlSessionDataTask(urlRequest: request, completion: closure)
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    public func weatherForecastAt(latitude lat: Double, longitude long: Double, completion closure: @escaping (Bool,Forecast?) -> Void) {
        guard let key = apiKey else { return }
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(long)"))
        urlQueryitems.append(URLQueryItem(name: "exclude", value: "minutely,hourly"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        
        guard let url = createUrl(endpoint: "/onecall", urlQueryItems: urlQueryitems) else { return }
        // Create URL request
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        // Create task
        let task = createRequestAndDecodeUrlSessionDataTask(urlRequest: request, completion: closure)
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    /**
     Retrieves weather for specific city (e.g., "berkeley,ca).
     */
    public func weatherAt(cityName: String, completion closure: @escaping (Bool, CityWeather?) -> Void) {
        /// API Examples:
        /// GET api.openweathermap.org/data/2.5/weather?q={CityName}&appid={YOUR_API_KEY}
        /// GET api.openweathermap.org/data/2.5/weather?q={CityName},{StateCode}&appid={YOUR_API_KEY}
        guard let key = apiKey else { return }
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "q", value: "\(cityName)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else { return }
        // Create URL request
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        // Create URL request
        let task = createRequestAndDecodeUrlSessionDataTask(urlRequest: request, completion: closure)
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // MARK: - Public Methods (Combined based)
    
    public func weatherAt(lat: Double, long: Double) -> AnyPublisher<CityWeather, Error> {
        // API Example: http://api.openweathermap.org/data/2.5/weather?lat=34.02&lon=-118.17&APPID={YOUR_API_KEY}
        
        // Ensure API was set
        guard let key = self.apiKey else {
            return Fail(error: ApiError.missingApiKeyError).eraseToAnyPublisher()
        }
        
        // Create and configure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(long)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else {
            return Fail(error: URLError(URLError.unsupportedURL)).eraseToAnyPublisher()
        }
        
        // Create URL request
        let urlRequest = createUrlRequest(url: url, httpMethodType: .GET)
        
        // Create publisher that wraps Url Session Data task and return decoded entity or error
        return self.session.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw ApiError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                }
                return data
        }
        .decode(type: CityWeather.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    public func weatherAt(lat: Double, long: Double, cityCount: Int) -> AnyPublisher<CityWeatherList, Error> {
        // API Example: GET http://api.openweathermap.org/data/2.5/find?lat=34.022&lon=-118.9&cnt=10&APPID={YOUR_API_KEY}

        // Ensure API was set
        guard let key = self.apiKey else {
            return Fail(error: ApiError.missingApiKeyError).eraseToAnyPublisher()
        }
        
        // Create and cofigure URL
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(long)"))
        urlQueryitems.append(URLQueryItem(name: "cnt", value: "\(cityCount)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        guard let url = self.createUrl(endpoint: "/find", urlQueryItems: urlQueryitems) else {
            return Fail(error: URLError(URLError.unsupportedURL)).eraseToAnyPublisher()
        }
        
        // Create URL request
        let urlRequest = self.createUrlRequest(url: url, httpMethodType: .GET)
        
        // Create publisher that wraps Url Session Data task
        return self.session.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw ApiError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                }
                return data
        }
        .decode(type: CityWeatherList.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private methods
    
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
    
    private func createRequestAndDecodeUrlSessionDataTask<T: Decodable>(urlRequest: URLRequest, completion closure: @escaping (Bool, T?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Handle response
                guard let data = data else {
                    closure(false, nil)
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let weather = try decoder.decode(T.self, from: data)
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
