//
//  CategoryViewModel.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 17/09/2024.
//

import UIKit

class CategoryViewModel {
    var categories:[String] = []
    init() {
        Task {
            let categoriesItem = try await NetworkManager.shared.fetchCategories()
            updateCategories(categoriesItem)
        }
    }
    func updateCategories(_ categories: [String]){
        self.categories = categories
    }
}
