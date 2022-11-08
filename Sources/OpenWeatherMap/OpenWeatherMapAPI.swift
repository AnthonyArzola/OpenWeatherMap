//
//  OpenWeatherMapAPI.swift
//  
//
//  Created by Anthony on 11/7/22.
//

import Foundation
import Combine

typealias OpenWeatherMapAPI = (OpenWeatherMapAuthentication & OpenWeatherMapClosure & OpenWeatherMapCombine & OpenWeatherMapAsync)

// MARK: - Authentication
public protocol OpenWeatherMapAuthentication {
    var apiKey: String { get }
}

// MARK: - Closure based
public protocol OpenWeatherMapClosure {
    func currentWeatherAt(latitude lat: Double, longitude long: Double, completion closure: @escaping (Bool, CityWeather?) -> Void)
    func currentWeatherAt(latitude lat: Double, longitude long: Double, resultCount count: Int, completion closure: @escaping (Bool, CurrentCityWeatherResults?) -> Void)
    func forecastWeatherAt(latitude lat: Double, longitude long: Double, completion closure: @escaping (Bool, ForecastWeatherResults?) -> Void)
    func currentWeatherAndForecastAt(latitude lat: Double, longitude long: Double, completion closure: @escaping (Bool, CurrentWeatherAndForecastResults?) -> Void)
    func currentWeatherAt(cityName: String, completion closure: @escaping (Bool, CityWeather?) -> Void)
}

// MARK: - Combine
public protocol OpenWeatherMapCombine {
    func weatherAt(lat: Double, long: Double) -> AnyPublisher<CityWeather, Error>
    func weatherAt(lat: Double, long: Double, cityCount: Int) -> AnyPublisher<CurrentCityWeatherResults, Error>
}

// MARK: - Async
public protocol OpenWeatherMapAsync {
    func weatherAt(lat: Double, long: Double) async throws -> CityWeather
}
