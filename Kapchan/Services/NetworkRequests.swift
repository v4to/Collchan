//
//  NetworkRequests.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 21.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

//enum Result {
//    case success(URLResponse)
//    case error(Error)
//}


protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
    
    
//    func create(withCompletion completion: @escaping (Result) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            print(data)
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
        do {
            let wrapper = try decoder.decode(Resource.ModelType.self, from: data)
            return wrapper
        } catch {
            print(error)
            return nil

        }
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
        print(components.url)
        return components.url!
    }
}




enum ServiceMethod: String {
    case get = "GET"
    case post = "POST"
    // implement more when needed: post, put, delete, patch, etc.
}

protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var method: ServiceMethod { get }
}

extension Service {
    public var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if method == .post {
            request.httpBody = body
        }
      
        return request
    }

    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        if let parameters = parameters {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
//        if method == .get {
            // add query items to url
//            guard let parameters = parameters as? [String: String] else {
//                fatalError("parameters for GET http method must conform to [String: String]")
//            }
//        if let parameters = parameters {
//            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//        }
//        }

        return urlComponents?.url
    }
}








enum Result<T> {
    case success(T)
    case failure(Error)
    case empty
}

class ServiceProvider<T: Service> {
    var urlSession = URLSession.shared

    init() { }

    func load(service: T, completion: @escaping (Result<Data>) -> Void) {
        call(service.urlRequest, completion: completion)
    }

    func load<U>(service: T, decodeType: U.Type, completion: @escaping (Result<U>) -> Void) where U: Decodable {
        call(service.urlRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(decodeType, from: data)
                    completion(.success(resp))
                }
                catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            case .empty:
                completion(.empty)
            }
        }
    }
    
//    func post(service: T, completion: @escaping (Result<Data>) -> Void) {
//
//    }
}

extension ServiceProvider {
    private func call(_ request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<Data>) -> Void) {
        urlSession.dataTask(with: request) { (data, _, error) in
            if let error = error {
                deliverQueue.async {
                    completion(.failure(error))
                }
            } else if let data = data {
                deliverQueue.async {
                    completion(.success(data))
                }
            } else {
                deliverQueue.async {
                    completion(.empty)
                }
            }
            }.resume()
    }
}


struct PostResponse: Decodable {
    let error: Int?
    let status: String?
    let num: Int?
    let reason: String?
    
    enum CodingKeys: String, CodingKey {
        case error = "Error"
        case status = "Status"
        case num = "Num"
        case reason = "Reason"
    }
}


struct PostService: Service {
    var baseURL: String = BaseUrls.dvach
    
    var path: String = EndPoints.createPost
    
    var parameters: [String : String]? = ["json": "1"]
    
    var headers: [String : String]?
    
    var body: Data?
    
    var method: ServiceMethod = .post
    
    init(boardId: String, threadId: String, commentText: String, googleRecaptchId: String, captchaId: String) {
        let boundary = UUID().uuidString
        self.headers = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"task\"\r\n\r\n".data(using: .utf8)!)
        data.append("post\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"board\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(boardId)\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"thread\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(threadId)\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"usercode\"\r\n\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"code\"\r\n\r\n".data(using: .utf8)!)
        data.append("code\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"captcha_type\"\r\n\r\n".data(using: .utf8)!)
        data.append("invisible_recaptcha\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"subject\"\r\n\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"icon\"\r\n\r\n".data(using: .utf8)!)
        data.append("-1\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"g-recaptcha-response\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(googleRecaptchId)\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"2chaptcha_id\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(captchaId)\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"comment\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(commentText)\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        print(String(data: data, encoding: .utf8))
        self.body = data
    }
}
