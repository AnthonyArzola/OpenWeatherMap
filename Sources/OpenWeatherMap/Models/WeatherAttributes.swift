//
//  WeatherAttributes.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/6/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

/*
 Model the following response:
 
 "main": {
         "temp": 289.47,
         "temp_min": 289.47,
         "temp_max": 291.646,
         "pressure": 1011.71,
         "sea_level": 1011.71,
         "grnd_level": 998.71,
         "humidity": 71,
         "temp_kf": -2.18
        }
 */

public struct WeatherAttributes: Codable {
    public let temperature: Double //in Kelvin
    public let tempMimimum: Double //in Kelvin
    public let tempMaximum: Double //in Kelvin
    public let pressure: Double
    public let humidity: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case tempMimimum = "temp_min"
        case tempMaximum = "temp_max"
        case pressure
        case humidity
    }
    
}
