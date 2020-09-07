//
//  City.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 6/7/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

public struct City: Codable {
    public let id: Int
    public let name: String
    public let country: String
    public let coordinate: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case country
        case coordinate = "coord"
    }
}
