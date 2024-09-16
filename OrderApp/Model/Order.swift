//
//  Order.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import Foundation


struct Order: Codable {
    var menuItems: [MenuItem]
    
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
