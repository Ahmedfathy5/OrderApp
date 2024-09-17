//
//  menuDetailViewModel.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 17/09/2024.
//

import UIKit

class MenuDetailViewModel {
    
    var menuItem: MenuItem
    
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
    }
    
    func fetchImage(menuItem: MenuItem, completion: @escaping (UIImage?)-> Void ) async {
            if let image = try? await NetworkManager.shared.fetchImage(from: menuItem.imageURL) {
                completion(image)
            }
    }
    
    func addItemToOrder(menuItem: MenuItem) {
        NetworkManager.shared.order.menuItems.append(menuItem)
    }
    
}
