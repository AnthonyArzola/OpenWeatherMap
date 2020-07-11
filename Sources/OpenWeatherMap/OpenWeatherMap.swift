import Foundation

enum HttpMethodType: String {
    case GET
}

public class OpenWeatherMap {
    // MARK: - Properties
    private let session: URLSession
    private let baseUrl: String
    var apiKey: String?
    
    // MARK: - Constructors
    public init(apiKey key: String) {
        if key.isEmpty {
            fatalError("API key required.")
        }
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        baseUrl = "https://api.openweathermap.org/data/2.5"
        apiKey = key
    }
    
    // MARK: - Public methods
    
    /**
     Retrieves weather at specified point (`latitude`, `longitude`).
     */
    public func weatherAt(latitude lat: Double, longitude long: Double, completion closure: @escaping (Bool, CityWeather?) -> Void) {
        // API Example: http://api.openweathermap.org/data/2.5/weather?lat=34.02&lon=-118.17&APPID={YOUR_API_KEY}
        guard let key = apiKey else { return }
        
        // Configure URL and request
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(long)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else { return }
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Handle response
                guard let data = data else
                {
                    closure(false, nil)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let weather = try decoder.decode(CityWeather.self, from: data)
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
                
        // Configure URL and request
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlQueryitems.append(URLQueryItem(name: "lon", value: "\(long)"))
        urlQueryitems.append(URLQueryItem(name: "cnt", value: "\(count)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        
        guard let url = createUrl(endpoint: "/find", urlQueryItems: urlQueryitems) else { return }
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Handle response
                guard let data = data else {
                    closure(false, nil)
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(CityWeatherList.self, from: data)
                    // Success
                    closure(true, results)
                }
                catch let error {
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
        
        // Configure URL and request
        var urlQueryitems = [URLQueryItem]()
        urlQueryitems.append(URLQueryItem(name: "q", value: "\(cityName)"))
        urlQueryitems.append(URLQueryItem(name: "appid", value: key))
        
        guard let url = createUrl(endpoint: "/weather", urlQueryItems: urlQueryitems) else { return }
        let request = createUrlRequest(url: url, httpMethodType: .GET)
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Handle response
                guard let data = data else {
                    closure(false, nil)
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(CityWeather.self, from: data)
                    // Success
                    closure(true, results)
                }
                catch let error {
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
        
        task.resume()
        session.finishTasksAndInvalidate()
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
    
}
