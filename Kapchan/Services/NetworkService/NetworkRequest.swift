//
//  Request.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 14.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    func load(_ request: URLRequest, withCompletion completion: @escaping (ModelType?) -> Void) {
        let task = URLSession.shared.dataTask(
            with: request,
            completionHandler: { [weak self] (
                data: Data?,
                response: URLResponse?,
                error: Error?
            ) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                if let response =  response as? HTTPURLResponse {
                    print(response.statusCode)
                }
                print(data)
                let res = self?.decode(data)
                DispatchQueue.main.async {
                    completion(res)
                }
            }
        )
        task.resume()
    }
}
