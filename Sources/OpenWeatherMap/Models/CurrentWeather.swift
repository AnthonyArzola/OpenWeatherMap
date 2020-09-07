//
//  CurrentWeather.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 9/6/20.
//

import Foundation

/*
 Model the following response. Used with `onecall` endpoint.
 
"current": {
    "dt": 1599439252,
    "sunrise": 1599399018,
    "sunset": 1599444704,
    "temp": 313.38,
    "feels_like": 310.79,
    "pressure": 1008,
    "humidity": 16,
    "dew_point": 282.76,
    "uvi": 9.22,
    "clouds": 1,
    "visibility": 10000,
    "wind_speed": 3.6,
    "wind_deg": 270,
    "weather": [{
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01d"
                }]
}
*/

public struct CurrentWeather: Codable {
    public let dateTime: Date
    public let sunrise: Date
    public let sunset: Date
    public let temperature: Float // in Kelvin
    public let feelsLike: Float // in Kelvin
    public let pressure: Int16
    public let humidity: Int16
    public let dewPoint: Float
    public let uvi: Float
    public let clouds: Int16
    public let visibility: Int
    public let windSpeed: Float
    public let windDegrees: Int16
    public let weatherDescription: [WeatherDescriptions]
    
    private enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case sunrise
        case sunset
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvi
        case clouds
        case visibility
        case windSpeed = "wind_speed"
        case windDegrees = "wind_deg"
        case weatherDescription = "weather"
    }
}
