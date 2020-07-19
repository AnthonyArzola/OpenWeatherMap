//
//  ApiError.swift
//  OpenWeatherMap
//
//  Created by Anthony Arzola on 7/11/20.
//  Copyright © 2019 Anthony Arzola. All rights reserved.
//

import Foundation

enum ApiError: Error, LocalizedError{
    case responseError(Int)
    case decodingError(DecodingError)
    case invalidUrlError(URLError)
    case genericError(Error)
    case emptyResponseError
    case missingApiKeyError
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .responseError(let statusCode):
            return "HTTP response error. Status code:\(statusCode)"
        case .decodingError(let decodeError):
            return decodeError.localizedDescription
        case .invalidUrlError(let urlError):
            return "Invalid URL. Error is:\(urlError.localizedDescription)"
        case .genericError(let error):
            return error.localizedDescription
        case .emptyResponseError:
            return "API succeeded, but returned empty response."
        case .missingApiKeyError:
            return "Missing API key."
        case .unknownError:
            return "Unknown error occured. 😢"
        }
    }
}
