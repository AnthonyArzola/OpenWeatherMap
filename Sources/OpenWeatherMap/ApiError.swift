//
//  ApiError.swift
//  
//
//  Created by Anthony Arzola on 7/11/20.
//

import Foundation

enum ApiError: Error, LocalizedError{
    case responseError(Int)
    case decodingError(DecodingError)
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .responseError(let statusCode):
            return "Error. Response status code:\(statusCode)"
        case .decodingError(let decodeError):
            return decodeError.localizedDescription
        case .unknownError:
            return "Unknown error occured. 😢"
        }
    }
}
