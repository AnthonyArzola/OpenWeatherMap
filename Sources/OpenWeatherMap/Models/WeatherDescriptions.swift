//
//  Weather.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 6/7/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

public enum WeatherIconType: String, Codable {
    case clearSkyDay = "01d"
    case clearSkyNight = "01n"
    case fewCloudsDay = "02d"
    case fewCloudsNight = "02n"
    case scatteredCloudsDay = "03d"
    case scatteredCloudsNight = "03n"
    case brokenCloudsDay = "04d"
    case brokenCloudsNight = "04n"
    case showerRainDay = "09d"
    case showerRainNight = "09n"
    case rainDay = "10d"
    case rainNight = "10n"
    case thunderstormDay = "11d"
    case thunderstormNigth = "11n"
    case snowDay = "13d"
    case snowNigth = "13n"
    case mistDay = "50d"
    case mistNigth = "50n"
}

/*
 Model the following response:
    {
        "id": 800,
        "main": "Clear",
        "description": "clear sky",
        "icon": "01n"
    }
*/

public struct WeatherDescriptions: Codable {
    public let Id: Int
    public let shortDescription: String
    public let longDescription: String
    public let iconName: WeatherIconType
    
    private enum CodingKeys: String, CodingKey {
        case Id = "id"
        case shortDescription = "main"
        case longDescription = "description"
        case iconName = "icon"
    }
    
}
