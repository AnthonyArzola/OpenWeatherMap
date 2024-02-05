//
//  OpenWeatherMapAPI.swift
//  
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
    func currentWeatherAt(latitude: Double, longitude: Double, completion closure: @escaping (Bool, CityWeather?) -> Void)
    func currentWeatherAt(latitude: Double, longitude: Double, resultCount count: Int, completion closure: @escaping (Bool, CurrentCityWeatherResults?) -> Void)
    func currentWeatherAt(cityName: String, completion closure: @escaping (Bool, CityWeather?) -> Void)
    func forecastWeatherAt(latitude: Double, longitude: Double, completion closure: @escaping (Bool, ForecastWeatherResults?) -> Void)
    func currentWeatherAndForecastAt(latitude lat: Double, longitude long: Double, completion closure: @escaping (Bool, CurrentWeatherAndForecastResults?) -> Void)
}

// MARK: - Combine API
public protocol OpenWeatherMapCombine {
    func currentWeatherAt(latitude: Double, longitude: Double) -> AnyPublisher<CityWeather, Error>
    func currentWeatherAt(latitude: Double, longitude: Double, cityCount: Int) -> AnyPublisher<CurrentCityWeatherResults, Error>
}

// MARK: - Async API
public protocol OpenWeatherMapAsync {
    func currentWeatherAt(latitude: Double, longitude: Double) async throws -> CityWeather
}
