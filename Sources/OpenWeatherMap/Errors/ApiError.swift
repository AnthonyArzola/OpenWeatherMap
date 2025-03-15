//
//  ApiError.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/11/20.
//

import Foundation

enum ApiError: Error, LocalizedError{
    case decoding
    case invalidUrl
    case generic(Error)
    case emptyResponse
    case missingApiKey
    case missingData
    case statusCode(Int)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .decoding:
            return "Decoding error."
        case .invalidUrl:
            return "Invalid URL."
        case .generic(let error):
            return error.localizedDescription
        case .emptyResponse:
            return "API succeeded, but returned empty response."
        case .missingApiKey:
            return "Missing API key."
        case .missingData:
            return "Missing data"
        case .statusCode(let statusCode):
            return "HTTP response error. Status code:\(statusCode)"
        case .unknown:
            return "Unknown error occured. 😢"
        }
    }
}
