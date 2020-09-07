//
//  Coordinate.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 6/7/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

/*
 Model the following response:
 
 "coord": {
            "lon": -117.82,
            "lat": 34.06
        }
 */

public struct Coordinate: Codable {
    public let latitude: Double
    public let longitude: Double
    
    public init(lat: Double, lon: Double) {
        latitude = lat
        longitude = lon
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
