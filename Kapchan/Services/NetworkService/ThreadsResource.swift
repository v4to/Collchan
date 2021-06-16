//
//  ThreadsResource.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 15.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct ThreadsResource: APIResource {
    typealias ModelType = Threads
    
    let methodPath: String
    let queryItems: [URLQueryItem] = []
    
    init(threadId: String, page: String) {
        self.methodPath = "/" + threadId + "/" + page + ".json"
    }
}
