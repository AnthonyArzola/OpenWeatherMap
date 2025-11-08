//
//  ApiError.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/11/20.
//

import Foundation

public enum ApiError: Error, LocalizedError {
    case decoding(Error)
    case invalidUrl
    case generic(Error)
    case emptyResponse
    case missingApiKey
    case missingData
    case statusCode(Int)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidUrl:
            return "Invalid URL configuration"
        case .generic(let error):
            return "Request failed: \(error.localizedDescription)"
        case .emptyResponse:
            return "API succeeded, but returned empty response"
        case .missingApiKey:
            return "API key is required but was not provided"
        case .missingData:
            return "No data received from server"
        case .statusCode(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    public var localizedDescription: String {
        return errorDescription ?? "Unknown error"
    }
}
