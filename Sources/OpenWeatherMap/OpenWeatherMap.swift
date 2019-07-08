import Foundation

public class OpenWeatherMap {
    private let session: URLSession
    private let baseUrl: String
    
    public init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        self.baseUrl = "http://api.openweathermap.org/data/2.5"
    }
    
    /**
     Retrieves weather at specified point (`latitude`, `longitude`).
     Completion handler takes a tuple (`Bool`, `WeatherResults`) with first parameter used to signify if weather was retrieved successfully.
     */
    public func weatherAt(latitude lat: Double, longitude long: Double, apiKey key: String, completion closure: @escaping (Bool, WeatherResults?) -> Void) -> Void {
        // API Example: http://api.openweathermap.org/data/2.5/weather?lat=34.02&lon=-118.17&APPID={YOUR_API_KEY}
        
        // Configure request
        guard let url = URL(string:"\(baseUrl)/weather?lat=\(lat)&lon=\(long)&APPID=\(key)") else { return }
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
                    let weather = try decoder.decode(WeatherResults.self, from: data)
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
     Completion handler takes a tuple (`Bool`, `WeatherList`) with first parameter used to signify if weather was retrieved successfully.
     The default number of cities is 10, the maximum is 50.
     */
    public func weatherAt(latitude lat: Double, longitude long: Double, resultCount count: Int, apiKey key: String, completion closure: @escaping (Bool, WeatherList?) -> Void) -> Void {
        // API Example: GET http://api.openweathermap.org/data/2.5/find?lat=34.022&lon=-118.9&cnt=10&APPID={YOUR_API_KEY}
        
        // Configure request
        guard let url = URL(string:"\(baseUrl)/find?lat=\(lat)&lon=\(long)&cnt=\(count)&APPID=\(key)") else { return }
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
