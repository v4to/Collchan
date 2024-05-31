//
//  APIRequest.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 14.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation
import WebKit

class SessionTaskDelegate: NSObject, URLSessionDelegate {

}
enum MimeType: String {
    case html = "text/html"
    case json = "application/json"
}

class APIRequest<Resource: APIResource>: NSObject, URLSessionDelegate, URLSessionTaskDelegate {

    var resource: Resource?
    var completion: ((Resource.ModelType?) -> Void)?
    var session: URLSession?
    var htmlParser: (any HTMLParsing)?
    
    init(resource: Resource) {
//    init(resource: Resource, htmlParser: (any HTMLParsing)?) {
        super.init()
        self.resource = resource
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
//        self.htmlParser = htmlParser
//        self.session.
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        self.load(request, withCompletion: self.completion!)
    }
}

extension APIRequest: NetworkRequest {
//    func decode(_ data: Data, mimeType: MimeType) -> Resource.ModelType? {
        func decode(_ data: Data) -> Resource.ModelType? {
//        switch mimeType {
//        case .html:
//            // TODO: - Implement Board Html Parser
            print(data)
////            return Resource.ModelType as! Resource.ModelType
//            return nil
//        case .json:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let wrapper = try decoder.decode(Resource.ModelType.self, from: data)
                return wrapper
            } catch {
                print(error)
                return nil
            }
//        }
    }
    func load(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
//    func load(withCompletion completion: @escaping (Resource.ModelType?) -> Void, parser: any HTMLParsing) {
        self.completion = completion
//        var request = URLRequest(url: self.resource.url)
        var request = URLRequest(url: self.resource!.url)
//        self.load(request, withCompletion: completion)
//        request.httpShouldHandleCookies = false
//        let cook = HTTPCookieStorage.shared.cookies
////        print("COOKIES ---\(cook)")
//        let cookies = WKWebsiteDataStore.default().httpCookieStore
//        print("COOKIES ---\(cook)")
////        cookies.getAllCookies({
////            request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: $0)
////        request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cook ?? [])
////        for cookie in cook {
////            request.
////        }
//            request.setValue("\(WKWebView().value(forKey: "userAgent")!)", forHTTPHeaderField: "User-Agent")
//            self.load(request, withCompletion: completion)
        self.load(request, withCompletion: completion)
//        self.load(self.session!, request, withCompletion: completion)
//        })
    }
//    urlsessiontask
}
