//
//  NetworkRequests.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 21.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                completion(nil)
                return
            }
//            print(self)
            let res = self?.decode(data)

            DispatchQueue.main.async {
                completion(res)
            }
        }
        task.resume()
    }
}

class ImageRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension UIImage {
  func resized(to newSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    defer { UIGraphicsEndImageContext() }

    draw(in: CGRect(origin: .zero, size: newSize))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

extension ImageRequest: NetworkRequest {
    func decode(_ data: Data) -> UIImage? {
        var image = UIImage(data: data)
        image = image?.resized(to: CGSize(width: 90.0, height: 90.0))
//        image.
        return image
//        return UIImage(data: data)
    }
    
    func load(withCompletion completion: @escaping (UIImage?) -> Void) {
        load(url, withCompletion: completion)
    }
}

class APIRequest<Resource: APIResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) -> Resource.ModelType? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let wrapper = try? decoder.decode(Resource.ModelType.self, from: data)
        return wrapper!
    }
    
    func load(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}

protocol APIResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension APIResource {
    var url: URL {
        var components = URLComponents(string: BaseUrls.dvach)!
        components.path = methodPath
        components.queryItems = queryItems
        return components.url!
    }
}

class PostsResource: APIResource {
    typealias ModelType = [Post]
    var methodPath = EndPoints.makabaMobile
    var queryItems: [URLQueryItem]
    
    init(boardId: String, threadId: String, postId: String) {
        queryItems = [
            URLQueryItem(name: "task", value: "get_thread"),
            URLQueryItem(name: "board", value: boardId),
            URLQueryItem(name: "thread", value: threadId),
            URLQueryItem(name: "num", value: postId)
        ]
    }
}
