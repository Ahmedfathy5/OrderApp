//
//  RequestError.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 24/09/2024.
//
import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case notResponse
    case notAuthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode Error"
        case .invalidURL:
            return "Bad URL"
        case .notAuthorized: 
           return "notAuthorized"
        case.notResponse:
            return "notResponse"
        case .unexpectedStatusCode:
            return "unexpectedStatusCode"
        case .unknown:
            return "unknown"
        default:
            return "UnKnown Error"
        }
    }
}
