//
//  OrderEndpoint.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 24/09/2024.
//

import Foundation

enum OrderEndpoint {
    case Categorey
    case MenuItem
    case Order
}

extension OrderEndpoint: EndPoint {
    
    var scheme: String {
        return "http"
    }
    var host: String {
        return "://localhost:8080"
    }
    var path: String {
        switch self {
        case .Categorey:
            return "/categories"
        case .MenuItem:
            return "/menu"
        case .Order:
            return "/order"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .Categorey, .MenuItem:
                .Get
        case .Order:
                .post
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .Order:
           [ "Content-Type":"application/json" ]
        case .Categorey, .MenuItem:
                nil
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .Categorey:
            nil
        case .MenuItem:
            nil
        case .Order:
            nil
        }
    }
}
