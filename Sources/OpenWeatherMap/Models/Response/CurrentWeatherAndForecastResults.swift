//
//  Forecast.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 9/6/20.
//

import Foundation

/*
Model the following response:
{
    "lat": 34.02,
    "lon": -118.17,
    "timezone": "America/Los_Angeles",
    "timezone_offset": -25200,
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
        "weather": [
            {
                "id": 800,
                "main": "Clear",
                "description": "clear sky",
                "icon": "01d"
            }
        ]
    },
    "daily": [
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
    ]
}
*/

/// DTO for``CurrentWeather`` and ``ForecastWeather``.
public struct CurrentWeatherAndForecastResults: Codable {
    public let latitude: Float
    public let longitude: Float
    public let timezone: String
    public let timezoneOffset: Int16
    public let currentWeather: CurrentWeather
    public let dailyForecast: [ForecastWeather]
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timezone
        case timezoneOffset = "timezone_offset"
        case currentWeather = "current"
        case dailyForecast = "daily"
    }
}
