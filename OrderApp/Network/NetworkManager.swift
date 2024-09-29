//
//  NetworkManager.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 14/09/2024.
//

import UIKit

class NetworkManager {
    //MARK: -  Singelton.
    static let shared = NetworkManager()
    
    //MARK: - Properties.
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdate")
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: NetworkManager.orderUpdateNotification, object: nil)
        }
    }
    let baseURL = URL(string: "http://localhost:8080/")
    typealias MinutesToPrepare = Int
   
    
    func fetchCategories() async throws -> [String] {
        guard let categoriesURL = baseURL?.appendingPathComponent("categories") else { throw APIError.categoriesNotFound }
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        
        guard let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 else {
            throw APIError.menuItemNotFound
        }
        
        let categoryResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
        return categoryResponse.categories
    }
    
    
    func fetchMenuItem(forCategory categoryName: String) async throws -> [MenuItem] {
        guard let initialMenuURL = baseURL?.appendingPathComponent("menu") else { throw APIError.menuURLFailed }
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        guard let menuURL = components?.url else { throw APIError.menuURLFailed }
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.menuItemNotFound
        }
        
        let menuResponse = try JSONDecoder().decode(MenuResponse.self, from: data)
        return menuResponse.items
    }
    
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        guard let orderURL = baseURL?.appendingPathComponent("order") else { throw APIError.orderRequestFailed }
        var request = URLRequest(url: orderURL)
        request.httpMethod = RequestMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let menuIDsDict = ["menuIds": menuIDs]
        let jsonData = try JSONEncoder().encode(menuIDsDict)
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.orderRequestFailed
        }
        
        let orderResponse = try JSONDecoder().decode(OrderResponse.self, from: data)
        return orderResponse.prepTime
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw APIError.imageDataMissing
        }
        guard let image = UIImage(data: data) else {
            throw APIError.imageDataMissing
        }
        return image
    }
}
