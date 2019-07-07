//
//  WeatherResults.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/6/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

public struct WeatherResults: Codable {
    public var name: String
    public var Id: Int
    public var timezone: Int
    public var coordinate: Coordinate
    public var weather: [Weather]
    public var attributes: WeatherAttributes
    public var wind: Wind

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
