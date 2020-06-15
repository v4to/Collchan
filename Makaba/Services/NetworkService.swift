//
//  NetworkService.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 31.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct NetworkService {
    // MARK: - Properties
    let baseURL = BaseUrls.dvach

    // MARK: - Static properties
    static let shared = NetworkService()
    
    // MARK: - Initializtaion
    private init() {}
    
    // MARK: - HTTPMethods
    private enum HTTPMethods: String {
        case GET
        case POST
    }
        
    // MARK: - Instance Methods
    func GET<Model: Decodable>(
        endPoint: String,
        parameters: [String: String],
        decodeModelType: Model.Type,
        onSuccess: @escaping (Model) -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        let urlString = "\(baseURL)\(endPoint)"
        var urlComponents = URLComponents(string: urlString)!
        
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = HTTPMethods.GET.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { onFailure(error)  }
            
            if let data = data {
                do {
                    let parsedData = try JSONDecoder().decode(decodeModelType, from: data)
                    DispatchQueue.main.async {
                        onSuccess(parsedData)
                    }
                } catch {
                    onFailure(error)
                }
            }
        }
        task.resume()
    }
}

