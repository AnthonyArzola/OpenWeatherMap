//
//  Wind.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 6/7/19.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

/*
 Model the following response:
 
 "wind": {
            "speed": 4.6,
            "deg": 260
        }
 */

public struct Wind: Codable {
    public let speed: Double
    public let degrees: Double
    
    private enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
    
}
