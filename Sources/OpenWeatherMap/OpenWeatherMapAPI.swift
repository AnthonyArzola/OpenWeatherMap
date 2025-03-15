//
//  OpenWeatherMapAPI.swift
//  
//  Created by Anthony on 11/7/22.
//

import Foundation
import Combine

public typealias OpenWeatherMapAPI = (OpenWeatherMapAuthentication & OpenWeatherMapClosure & OpenWeatherMapCombine & OpenWeatherMapAsync)

// MARK: - Authentication
public protocol OpenWeatherMapAuthentication {
    var apiKey: String { get }
}

// MARK: - Closure API
public protocol OpenWeatherMapClosure {
    /// Gets current weather for geographic coordinates (`latitude`, `longitude`).
    func currentWeatherAt(latitude: Double, longitude: Double, completion closure: @escaping (Bool, CityWeather?) -> Void)
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for number of cities defined by `resultCount`.
    func currentWeatherAt(latitude: Double, longitude: Double, resultCount count: Int, completion closure: @escaping (Bool, CurrentCityWeatherResults?) -> Void)
    
    /// Get current weather for specific city (e.g., "berkeley,ca").
    func currentWeatherAt(cityName: String, completion closure: @escaping (Bool, CityWeather?) -> Void)
    
    /// Gets 5-day weather forecast with data every 3 hours for geographic coordinates.
    func forecastWeatherAt(latitude: Double, longitude: Double, completion closure: @escaping (Bool, ForecastWeatherResults?) -> Void)    
}

// MARK: - Combine API
public protocol OpenWeatherMapCombine {
    /// Gets current weather for geographic coordinates (`latitude`, `longitude`).
    func currentWeatherAt(latitude: Double, longitude: Double) -> AnyPublisher<CityWeather, Error>
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for number of cities defined by `cityCount`.
    func currentWeatherAt(latitude: Double, longitude: Double, cityCount: Int) -> AnyPublisher<CurrentCityWeatherResults, Error>
}

// MARK: - Async API
public protocol OpenWeatherMapAsync {
    
    /// Creates circle around geographic coordinates (`latitude`, `longitude`) and returns weather for 10 cities.
    func currentWeatherAt(latitude: Double, longitude: Double) async throws -> CityWeather
    
    /// Gets forecasted weather for geographic coordinates (`latitude`, `longitude`).
    func forecastWeatherAt(latitude: Double, longitude: Double) async throws -> ForecastWeatherResults
    
}
