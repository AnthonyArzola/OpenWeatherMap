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
    public let coordinate: Coordinate
    public let weather: [Weather]
    public let attributes: WeatherAttributes
    public let wind: Wind

    init(name: String, id: Int, timezone: Int?, coordinate: Coordinate, weather: [Weather], attributes: WeatherAttributes, wind: Wind) {
        self.name = name
        self.Id = id
        self.timezone = timezone
        self.coordinate = coordinate
        self.weather = weather
        self.attributes = attributes
        self.wind = wind
    }
    
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
