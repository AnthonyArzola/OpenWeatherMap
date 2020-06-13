import Foundation

public class OpenWeatherMap {
    private let session: URLSession
    private let baseUrl: String
    var apiKey: String?
    
    public init(apiKey key: String) {
        if key.isEmpty {
            fatalError("API key required.")
        }
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        baseUrl = "https://api.openweathermap.org/data/2.5"
        apiKey = key
    }
    
    /**
     Retrieves weather at specified point (`latitude`, `longitude`).
     */
    public func weatherAt(latitude lat: Double, longitude long: Double, completion closure: @escaping (Bool, WeatherResult?) -> Void) {
        // API Example: http://api.openweathermap.org/data/2.5/weather?lat=34.02&lon=-118.17&APPID={YOUR_API_KEY}
        
        // Configure request
        guard let key = apiKey else { return }
        guard let url = URL(string:"\(baseUrl)/weather?lat=\(lat)&lon=\(long)&appid=\(key)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
                    let weather = try decoder.decode(WeatherResult.self, from: data)
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
    public func weatherAt(latitude lat: Double, longitude long: Double, resultCount count: Int, completion closure: @escaping (Bool, WeatherList?) -> Void) {
        // API Example: GET http://api.openweathermap.org/data/2.5/find?lat=34.022&lon=-118.9&cnt=10&APPID={YOUR_API_KEY}
        
        // Configure request
        guard let key = apiKey else { return }
        guard let url = URL(string:"\(baseUrl)/find?lat=\(lat)&lon=\(long)&cnt=\(count)&appid=\(key)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Handle response
                guard let data = data else {
                    closure(false, nil)
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(WeatherList.self, from: data)
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
    public func weatherAt(cityName: String, completion closure: @escaping (Bool, WeatherList?) -> Void) {
        /// API Examples:
        /// GET api.openweathermap.org/data/2.5/weather?q={CityName}&appid={YOUR_API_KEY}
        /// GET api.openweathermap.org/data/2.5/weather?q={CityName},{StateCode}&appid={YOUR_API_KEY}
        guard let key = apiKey else { return }
        guard let url = URL(string:"\(baseUrl)/weather?q=\(cityName)&appid=\(key)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Handle response
                guard let data = data else {
                    closure(false, nil)
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(WeatherList.self, from: data)
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
}
