//
//  EndPoint.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 24/09/2024.
//

import Foundation

protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String:String]? { get }
    var body: [String:String]? { get }
}

extension EndPoint {
    var scheme: String {
        return "http"
    }
    var host: String {
        return "://localhost:8080"
    }
    var path: String {
        return "/categories"
    }
}
