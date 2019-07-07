import Foundation

public class OpenWeatherMap {
    private let session: URLSession //(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
    private let baseUrl: String //"http://api.openweathermap.org/data/2.5/weather"
    
    public init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        self.baseUrl = "http://api.openweathermap.org/data/2.5/weather"
    }
    
    public func weatherAt(latitude lat: Double, longitude long: Double, apiKey key: String, completion closure: @escaping (Bool, WeatherResults?) -> Void ) -> Void {
        // API Example: http://api.openweathermap.org/data/2.5/weather?lat=34.02&lon=-118.17&APPID={YOUR_APIKEY}
        
        // Configure request
        guard let url = URL(string:"\(baseUrl)?lat=\(lat)&lon=\(long)&APPID=\(key)") else { return }
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
}
