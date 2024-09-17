//
//  OrderViewModel.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 17/09/2024.
//

import UIKit
class OrderViewModel {
    
    var menuItem = NetworkManager.shared.order.menuItems
    
    func fetchMenuItem(indexPath: IndexPath) -> MenuItem {
        let menuItem = NetworkManager.shared.order.menuItems[indexPath.row]
        return menuItem
    }
    
    func minutesToPrepareOrder() async  -> Int? {
            let menuIDs = NetworkManager.shared.order.menuItems.map { $0.id }
            let minutes = try? await NetworkManager.shared.submitOrder(forMenuIDs: menuIDs)
        return minutes 
    }
    
    func tableViewCount() -> Int {
        NetworkManager.shared.order.menuItems.count
    }
    
    func deleteRows(indexPath: IndexPath) {
        NetworkManager.shared.order.menuItems.remove(at: indexPath.row)
    }
    
    func fetchImage(menuItem: MenuItem, indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) async {
        if let image = try? await NetworkManager.shared.fetchImage(from:menuItem.imageURL) {
         completion(image)
        }
    }
    
}
