//
//  APIError.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 16/09/2024.
//

import Foundation

enum APIError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemNotFound
    case orderRequestFailed
    case menuURLFailed
    case imageDataMissing
}
