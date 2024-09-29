//
//  CategoryViewModel.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 17/09/2024.
//

import UIKit

class CategoryViewModel: HttpClient {
    var categories: [String] = []
    
    init()  {
        Task {
           let result = await sendRequest(endpoint: OrderEndpoint.Categorey, responseModel: CategoryResponse.self)
            switch result {
            case .success(let success):
                print("The data is \(success)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateCategories(_ categories: [String]){
        self.categories = categories
    }
}
