//
//  CityWeatherList.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/7/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

/*
 Model the following response:
 {
    "message": "accurate",
    "cod": "200",
    "count": 10,
    "list": [{...}, {...}]
 }
 */

public struct CityWeatherList: Codable {
    public let message: String
    public let cod: String
    public let count: Int
    public let results: [CityWeather]?
    
    private enum CodingKeys: String, CodingKey {
        case message
        case cod
        case count
        case results = "list"
    }
    
}
