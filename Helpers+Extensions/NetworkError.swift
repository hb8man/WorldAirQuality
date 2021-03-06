//
//  NetworkError.swift
//  WorldAirQualityAPI
//
//  Created by William Bateman on 8/5/21.
//

import Foundation

enum NetworkError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        
        case .invalidURL:
            return "Unable to reach the server."
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case.noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "There was an error trying to decode the data."
        }
    }
} // End of Enum
