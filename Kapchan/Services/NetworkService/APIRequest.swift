//
//  APIRequest.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 14.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

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
        let request = URLRequest(url: self.resource.url)
        load(request, withCompletion: completion)
    }
    /*
    func load(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        load(resource.url, withCompletion: completion)
    }*/
}
