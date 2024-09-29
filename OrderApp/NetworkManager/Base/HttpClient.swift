//
//  HttpClient.swift
//  OrderApp
//
//  Created by Ahmed Fathi on 24/09/2024.
//

import Foundation

protocol HttpClient: AnyObject {
    func sendRequest<T: Decodable> (endpoint: EndPoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HttpClient {
    func sendRequest<T: Decodable> (endpoint: EndPoint, responseModel: T.Type) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
               print("Scheme: \(endpoint.scheme)")
               print("Host: \(endpoint.host)")
               print("Path: \(endpoint.path)")
        
        guard let url = urlComponents.url else {
            print("Error: Invalid URL - Scheme: \(endpoint.scheme), Host: \(endpoint.host), Path: \(urlComponents.path)")
            return .failure(RequestError.invalidURL)
        }
        print("This's the URL \(url)")
        
        let request = URLRequest(url: url)
        
        do {
            let (data,response) = try await URLSession.shared.data(for: request,delegate: nil)
            guard let response = response as? HTTPURLResponse else { return .failure(RequestError.notResponse)}
            
            switch response.statusCode {
            case 200 ... 299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw RequestError.decode}
                return .success(decodedResponse)
            case 401: throw RequestError.notAuthorized
            default: throw RequestError.unknown
                
            }
        } catch  {
            print("there's error in catch block.")
            return .failure(RequestError.unknown)
        }
    }
}
