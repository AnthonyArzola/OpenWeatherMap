//
//  File.swift
//  
//
//  Created by Anthony Arzola on 7/7/19.
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

public struct WeatherList: Codable {
    public let message: String
    public let cod: String
    public let count: Int
    public let results: [WeatherResults]?
    
    private enum CodingKeys: String, CodingKey {
        case message
        case cod
        case count
        case results = "list"
    }
    
}
