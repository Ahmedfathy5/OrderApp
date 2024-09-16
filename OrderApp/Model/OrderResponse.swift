//
//  OrderResponse.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import Foundation


struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
