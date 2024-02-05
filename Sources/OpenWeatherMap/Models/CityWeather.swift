//
//  CityWeather.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/6/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

public struct CityWeather: Codable {
    public let name: String
    public let Id: Int
    public let timezone: Int?
    public let coordinate: Coordinate?
    public let weatherDescriptions: [WeatherDescriptions]?
    public let attributes: WeatherAttributes?
    public let wind: Wind?

    public init(name: String, id: Int, timezone: Int?, coordinate: Coordinate?, weatherDescriptions: [WeatherDescriptions]?, attributes: WeatherAttributes?, wind: Wind?) {
        self.name = name
        self.Id = id
        self.timezone = timezone
        self.coordinate = coordinate
        self.weatherDescriptions = weatherDescriptions
        self.attributes = attributes
        self.wind = wind
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case Id = "id"
        case timezone = "timezone"
        case coordinate = "coord"
        case weatherDescriptions = "weather"
        case attributes = "main"
        case wind
    }
}
