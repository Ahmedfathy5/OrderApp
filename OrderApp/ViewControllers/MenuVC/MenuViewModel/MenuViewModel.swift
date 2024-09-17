//
//  MenuViewModel.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 17/09/2024.
//

import UIKit
class MenuViewModel {
    
    var category: String
    var menuItems: [MenuItem] = []
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    var onDataLoaded: (() -> Void)?
    
    init(category: String = "") {
        self.category = category
    }
    
    func fetchMenuItems() async {
        do {
            let items = try await NetworkManager.shared.fetchMenuItem(forCategory: category)
            self.menuItems = items
            onDataLoaded?()
        } catch  {
            
        }
    }
    
    func fetchImage(for indexPath: IndexPath, menuItem: MenuItem, completion: @escaping (UIImage?)-> Void) async {
         
            if let image = try? await NetworkManager.shared.fetchImage(from: menuItem.imageURL) {
                completion(image)
            }
            
      
    }
    
    func cancelImageTask(for indexPath: IndexPath){
        imageLoadTasks[indexPath]?.cancel()
    }
    
    
    
}
