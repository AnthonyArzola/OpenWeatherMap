//
//  ForecastWeatherResults.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 9/7/20.
//

import Foundation

/*
Model the follwing response:

{
    "cod": "200",
    "message": 0,
    "cnt": 40,
    "list": [
        {
            "dt": 1599469200,
            "main": {
            "temp": 301.58,
            "feels_like": 302.42,
            "temp_min": 301.58,
            "temp_max": 303.49,
            "pressure": 1009,
            "sea_level": 1010,
            "grnd_level": 1003,
            "humidity": 46,
            "temp_kf": -1.91
        },
        "weather": [
            {
                "id": 800,
                "main": "Clear",
                "description": "clear sky",
                "icon": "01n"
            }
        ],
        "clouds": {
            "all": 1
        },
        "wind": {
            "speed": 1.46,
            "deg": 170
        },
        "visibility": 10000,
        "pop": 0,
        "sys": {
            "pod": "n"
        },
        "dt_txt": "2020-09-07 09:00:00"
        }
    ],
    "city": {
        "id": 5344994,
        "name": "East Los Angeles",
        "coord": {
            "lat": 34.0239,
            "lon": -118.172
        },
        "country": "US",
        "population": 126496,
        "timezone": -25200,
        "sunrise": 1599485459,
        "sunset": 1599531022
    }
}
*/

public struct ForecastWeatherResults: Codable {
    public let count: Int16
    public let cityForecast: [CityForecast]
    public let city: City
    
    public init(count: Int16, cityForecast: [CityForecast], city: City) {
        self.count = count
        self.cityForecast = cityForecast
        self.city = city
    }
    
    enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case cityForecast = "list"
        case city
    }
}

public struct CityForecast: Codable {
    public let dateTime: Date
    public let weatherAttributes: WeatherAttributes
    public let weatherDescriptions: [WeatherDescriptions]
    public let wind: Wind
    
    public init(date: Date, weatherAttributes: WeatherAttributes, wind: Wind, weatherDescriptions: [WeatherDescriptions]) {
        self.dateTime = date
        self.weatherAttributes = weatherAttributes
        self.weatherDescriptions = weatherDescriptions
        self.wind = wind
    }
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case weatherAttributes = "main"
        case weatherDescriptions = "weather"
        case wind
    }
}
