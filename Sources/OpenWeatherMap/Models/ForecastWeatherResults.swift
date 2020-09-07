//
//  ForecastWeatherResults.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 9/7/20.
//

import Foundation

public struct ForecastWeatherResults: Codable {
    public let count: Int16
    public let cityForecast: [CityForecast]
    public let city: City
    
    enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case cityForecast = "list"
        case city
    }
}


public struct CityForecast: Codable {
    public let dateTime: Date
    public let weatherAttributes: WeatherAttributes
    public let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case weatherAttributes = "main"
        case wind
    }
}
