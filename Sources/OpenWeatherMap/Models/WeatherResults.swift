//
//  WeatherResults.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/6/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

public struct WeatherResults: Codable {
    public let name: String
    public let Id: Int
    public let timezone: Int?
    public let coordinate: Coordinate
    public let weather: [Weather]
    public let attributes: WeatherAttributes
    public let wind: Wind

    private enum CodingKeys: String, CodingKey {
        case name
        case Id = "id"
        case timezone
        case coordinate = "coord"
        case weather
        case attributes = "main"
        case wind
    }
}
