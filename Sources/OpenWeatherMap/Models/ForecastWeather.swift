//
//  ForecastWeather.swift
//  OpenWeatherMap
//  
//  Created by Anthony Arzola on 9/6/20.
//

import Foundation

/*
 Model the following response:
 
 "day": 313.38,
 "min": 308.61,
 "max": 313.38,
 "night": 308.61,
 "eve": 313.38,
 "morn": 313.38
 */
public struct ForecastTemperature: Codable {
    public let day: Float // in Kelvin
    public let minimum: Float // in Kelvin
    public let maximum: Float // in Kelvin
    public let night: Float // in Kelvin
    public let evening: Float // in Kelvin
    public let morning: Float // in Kelvin
    
    private enum CodingKeys: String, CodingKey {
        case day
        case minimum = "min"
        case maximum = "max"
        case night
        case evening = "eve"
        case morning = "morn"
    }
}

/*
 Model the following response:
 
 "day": 310.7,
 "night": 307.11,
 "eve": 310.7,
 "morn": 310.7
 */
public struct ForecastFeelsLikeTemperature: Codable {
    public let day: Float // in Kelvin
    public let night: Float // in Kelvin
    public let evening: Float // in Kelvin
    public let morning: Float // in Kelvin
    
    private enum CodingKeys: String, CodingKey {
        case day
        case night
        case evening = "eve"
        case morning = "morn"
    }
}

/*
 Model the following response: Daily Forecast used with `onecall` endpoint.
 
{
    "dt": 1599418800,
    "sunrise": 1599399018,
    "sunset": 1599444704,
    "temp": {
        "day": 313.38,
        "min": 308.61,
        "max": 313.38,
        "night": 308.61,
        "eve": 313.38,
        "morn": 313.38
    },
    "feels_like": {
        "day": 310.7,
        "night": 307.11,
        "eve": 310.7,
        "morn": 310.7
    },
    "pressure": 1008,
    "humidity": 16,
    "dew_point": 282.76,
    "wind_speed": 3.73,
    "wind_deg": 215,
    "weather": [
    {
    "id": 800,
    "main": "Clear",
    "description": "clear sky",
    "icon": "01d"
    }
    ],
    "clouds": 1,
    "pop": 0,
    "uvi": 9.22
}
 */
public struct ForecastWeather: Codable {
    public let dateTime: Date
    public let sunrise: Date
    public let sunset: Date
    public let temperatures: ForecastTemperature
    public let temperatureFeelsLike: ForecastFeelsLikeTemperature
    public let pressure: Int16
    public let humidity: Int16
    public let dewPoint: Float
    public let uvi: Float
    public let clouds: Int16
    public let windSpeed: Float
    public let windDegree: Int16
    public let weather: [WeatherDescriptions]
    
    private enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case sunrise
        case sunset
        case temperatures = "temp"
        case temperatureFeelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvi
        case clouds
        case windSpeed = "wind_speed"
        case windDegree = "wind_deg"
        case weather
    }
}
