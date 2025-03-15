//
//  WeatherAttributes.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/6/19.
//

import Foundation

/*
 Model the following response:
 
 "main": {
             "temp": 302.28,
             "feels_like": 302.7,
             "temp_min": 299.15,
             "temp_max": 304.82,
             "pressure": 1009,
             "humidity": 47
        }
 */

public struct WeatherAttributes: Codable {
    public let temperature: Double // in Kelvin
    public let feelsLike: Double // in Kelvin
    public let tempMimimum: Double // in Kelvin
    public let tempMaximum: Double // in Kelvin
    public let pressure: Double
    public let humidity: Double
    
    private enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case temperature = "temp"
        case tempMimimum = "temp_min"
        case tempMaximum = "temp_max"
        case pressure
        case humidity
    }
    
}
